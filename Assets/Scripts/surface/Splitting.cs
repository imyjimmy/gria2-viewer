using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Molecule.Model;
using Controller;
using VRModel;
using VRModel.Monomer;
//using Hover.InputModules.Follow;

public class Splitting  {
	private static int vertexLimit = 65000;
	private int[] triangles;
	private Vector3[] vertices;
	private Vector3[] normals;
	private Color32[] colors;
	private int currentIndex;
	private List<Mesh> meshes;
	private int lastIndex;

	//proof of concept, from catlike coding.
	public int size_x = 100;
	public int size_z = 50;
	public float tileSize = 1.0f;

	//imyjimmy
	private List<Residue> residueSeq;
	private Vector3 CENTER = new Vector3(0f,0f,0f);
	private PostProcessing pp;
	private GameObject LoadBox;

	//@imyjimmy called by PostProcessing.GenerateMeshes(List<Vector3> vertices, List<Vector3> normals, 
		//List<int> triangles, List<Color32> colors, int[] ss,
	    //string tag="RibbonObj", string gameobj="Ribbons")
	public List<Mesh> Split(MeshData mData, PostProcessing postprocessing) {
		Debug.Log("inside Split(mData);");
		if (pp == null) {
			pp = postprocessing;
		}
		LoadBox = GameObject.Find("LoadBox");

		triangles = mData.triangles;
		vertices = mData.vertices;
		normals = mData.normals;
		colors = mData.colors;
		meshes = new List<Mesh>();

		//get the mapping of each individual residue to its associated normals, triangles, vertices, colors.
		residueSeq = mData.residueSeq;

		//register a method to DNAPanel's UVChanged event.
		DNAPanelController.UVCoordChangedEvent += getResidueForUV;

		if(UI.UIData.isGLIC)
			vertexLimit = 59520;
		
		// Small meshes don't need to be split
		if(mData.vertices.Length < vertexLimit) {
			Debug.Log("Within vertex limit.\nVertices size : "+vertices.Length);
			Debug.Log("   triangle size : "+ triangles.Length);
			debug();
			Mesh mesh = new Mesh();
			mesh.vertices = vertices;
			mesh.triangles = triangles;
			mesh.normals = normals;
			mesh.colors32 = colors;
			meshes.Add(mesh);

			return meshes;
		}
		
		lastIndex = triangles.Length;
		
		int resNum = 0;
		while(currentIndex < lastIndex) {
			FillMesh(resNum);
		}

		return meshes;
	}
	
	private void FillMesh(int resNum) {
		Debug.Log("inside FillMesh()");
		List<int> tris = new List<int>();
		List<Vector3> verts = new List<Vector3>();
		List<Vector3> norms = new List<Vector3>();
		List<Color32> cols = new List<Color32>();
		Dictionary<int, int> dict = new Dictionary<int, int>();
		int currentVertex = 0;
		
		// Should not matter, as it should never be used unless dict.TryGetValue() succeeds
		int index = -1;
		int vIndex;
		bool useColors = (colors != null);
		
		bool vertexLimitReached = false;
		
		while( !vertexLimitReached && (currentIndex < lastIndex) ) {
			// The dictionary may contain the correct index for this vertex
			// in the context of the current mesh. That means the vertex already exists
			// in the local mesh.
			if(dict.TryGetValue(triangles[currentIndex], out index)) {
				tris.Add(index);
				// Debug.Log("FillMesh() while loop, if condition. currentIndex: " + currentIndex + ", out index: " + index);
			} else {
				// Debug.Log("FillMesh() while loop, else condition.");
				// If not, we add it. The index of the vertex in the original
				// mesh is the key, and the value is currentVertex
				dict.Add(triangles[currentIndex], currentVertex);
				
				// We add the vertex, color and normal pointed to by the global index
				vIndex = triangles[currentIndex];
				verts.Add(vertices[vIndex]);
				norms.Add(normals[vIndex]);
				if(useColors)
					cols.Add(colors[vIndex]);		
				// But we reference it with the local index.
				tris.Add(currentVertex);
				currentVertex++;
			}
			// We don't want to exceed the vertex limit, which is something like 65534, but
			// we must also take care not to exit the function in the middle of a triangle.
			if( (currentVertex > vertexLimit) && ( (currentIndex+1) % 3 == 0) ) {
			//if(currentVertex > 10000)
				vertexLimitReached = true;
			}
			// Next item in triangles
			currentIndex++;	
		} 		

		Mesh mesh = new Mesh();
		mesh.vertices = verts.ToArray();
		mesh.triangles = tris.ToArray();
		mesh.normals = norms.ToArray();
		mesh.colors32 = cols.ToArray();
		this.meshes.Add(mesh);

		//fix residue entry at currentIndex.
		fixResidueEntry(currentIndex, verts.Count, norms.Count);
	}

	public void oldUpdateSplit(int resNum) {	
		int beginV;
		int endV;
		Residue r;
		Mesh m;
		for (int i = 0; i < residueSeq.Count; i++) {
			r = residueSeq[resNum];
			beginV = r.vertices[0];
			endV = r.vertices[1];
			m = meshes[0];

			Debug.Log("beginV: " + beginV + " endV: " + endV);
			Debug.Log(" colors length: " + m.colors32.Length + " vert length: " + m.vertices.Length);
		}

		r = residueSeq[resNum];
		beginV = r.vertices[0];
		endV = r.vertices[1];
		m = meshes[0];

		Color32[] highlightColors = new Color32[m.colors32.Length];
		
		Debug.Log("out of the for loop. beginV: " + beginV + " endV: " + endV);
		Debug.Log("colors length: " + m.colors32.Length + " vert length: " + m.vertices.Length);

		for ( int vInt = 0; vInt < m.colors32.Length; vInt++) {
			if (vInt >= beginV && vInt <= endV) {
				highlightColors[vInt] = new Color32(255,231,99,128);
			} else {
				highlightColors[vInt] = m.colors32[vInt];
			}
		}

		m.colors32 = highlightColors;
	}

	//@imyjimmy proof of concept of adding/ changing the mesh.
	public void updateSplit(int resNum) {
		float x, y, z = 0.0f;

		// oldUpdateSplit(resNum);

		Residue r = residueSeq[resNum];
		Debug.Log("updatesplit: r.vertices.Length: " + r.vertices.Count);
		foreach (int s in r.vertices) {
			Debug.Log("s: " + meshes[0].vertices[s]);
		}
		int beginV = r.vertices[0];
		int endV = r.vertices[1];

		if (r.vertices.Count > 2) {
			//hold that thought for now
		}

		float maxX = float.MinValue, maxY = float.MinValue, maxZ = float.MinValue;
		float y_MaxX = 0.0f, z_MaxX = 0.0f, x_MaxY = 0.0f, z_MaxY = 0.0f, x_MaxZ = 0.0f, y_MaxZ = 0.0f;

		float minX = float.MaxValue, minY = float.MaxValue, minZ = float.MaxValue;
		float y_MinX = 0.0f, z_MinX = 0.0f, x_MinY = 0.0f, z_MinY = 0.0f, x_MinZ = 0.0f, y_MinZ = 0.0f;

		// foreach (int mIndex in r.meshIndices) { //consodering meshindices of length 1 for now.
			int mIndex = 0;
			Mesh m = meshes[mIndex];
			for (int vInt = beginV; vInt <= endV; vInt++) {
				Vector3 v = pp.gameObjects[mIndex].transform.TransformPoint(m.vertices[vInt]);
				// x += v.x;
				if (v.x > maxX) {
					maxX = v.x;
					y_MaxX = v.y;
					z_MaxX = v.z;
				}

				if (v.x < minX) {
					minX = v.x;
					y_MinX = v.y;
					z_MinX = v.z;
				}

				// y += v.y;
				if (v.y > maxY) {
					maxY = v.y;
					x_MaxY = v.x;
					z_MaxY = v.z;
				}

				if (v.y < minY) {
					minY = v.y;
					x_MinY = v.x;
					z_MinY = v.z;
				}
				
				// z += v.z;
				if (v.z > maxZ) {
					maxZ = v.z;
					x_MaxZ = v.x;
					y_MaxZ = v.y;
				}
				if (v.z < minZ) {
					minZ = v.z;
					x_MinZ = v.x;
					y_MinZ = v.y;
				}
			}
		// }

		Debug.Log("x: " + maxX + "," + minX + " y: " + maxY + "," + minY + " z: " + maxZ + "," + minZ);
		Vector3 avgCoord = new Vector3( (maxX + minX) / 2.0f, (maxY + minY) / 2.0f, (maxZ + minZ) / 2.0f );
		Debug.Log("updating split, avgCoord: " + avgCoord);

		Mesh focusMesh = diamond(new Vector3(maxX, y_MaxX, z_MaxX), new Vector3(x_MaxY, maxY, z_MaxY), new Vector3(x_MaxZ, y_MaxZ, maxZ),
			new Vector3(minX, y_MinX, z_MinX), new Vector3(x_MinY, minY, z_MinY), new Vector3(x_MinZ, y_MinZ, minZ), avgCoord);
		
		GameObject ProteinFocus = new GameObject("ProteinFocus");
		ProteinFocus.AddComponent<MeshFilter>();
		ProteinFocus.AddComponent<MeshRenderer>();
		
		Material material = ProteinFocus.GetComponent<Renderer>().material;
		material = new Material(Shader.Find("Standard"));
		material.SetColor("_Color", new Color32(255,231,99,128));
		// ProteinFocus.GetComponent<Renderer>().material = new Material(Shader.Find("Custom/Ribbons"));

		ProteinFocus.GetComponent<MeshFilter>().mesh = focusMesh;

		// Vector3 worldAvgCoord = transform.TransformPoint(avgCoord);
		ProteinFocus.transform.position = avgCoord;
		// ProteinFocus.transform.localScale *= 1.2f;
		ProteinFocus.tag = "RibbonObj";
		ProteinFocus.transform.parent = LoadBox.transform;

  		ProteinFocus.transform.localPosition = LoadBox.transform.localPosition;
	}

	private Mesh diamond(Vector3 maxX, Vector3 maxY, Vector3 maxZ, Vector3 minX, Vector3 minY, Vector3 minZ, Vector3 avg) {
		Vector3[] vertices = new Vector3[] {maxX, maxY, maxZ, minX, minY, minZ};
		//									[0,   1,    2,    3,    4,    5]
		int[] triangles = new int[] {1,2,0, 
									1,0,5,
									1,5,3,
									1,3,2,
									4,0,2,
									4,5,0,
									4,3,5,
									4,2,3};
		Vector3[] normals = new Vector3[] {maxX - avg, maxY - avg, maxZ - avg, avg - minX, avg - minY, avg - minZ};
		Color32[] colors = new Color32[] {new Color32(255,231,99,128), new Color32(255,231,99,128), new Color32(255,231,99,128), 
			new Color32(255,231,99,128), new Color32(255,231,99,128), new Color32(255,231,99,128)};

		Mesh diamond = new Mesh();
		diamond.vertices = vertices;
		diamond.triangles = triangles;
		diamond.normals = normals;
		diamond.colors32 = colors;

		// Debug.Log("diamond. normals length: " + normals.Length);
		return diamond;
	}

	public void getResidueForUV(Vector2 uv) {
		Debug.Log("Splitting.cs: getResidueForUV(uv): " + uv);
		int DNASeqNum = DNAPanelController.Instance.getSeqPos(uv);
	 	string nuc = DNAPanelController.Instance.getNucAcidForUV(uv);
		Debug.Log("Pos: " + DNASeqNum + ", DNA: " + nuc);
	}

	public void debug() {
		Debug.Log("triangles length: " + triangles.Length + " normals length: " + normals.Length);
		for (int i=0; i < triangles.Length; i++) {
			Debug.Log("triangles[" + i + "]: " + triangles[i]);
		}

		// Debug.Log("MeshData colors:");
		// for (int i=0; i < colors.Length; i++) {
		// 	Debug.Log("colors[" + i + "]: " + colors[i]);
		// }

		Debug.Log("residue info make it to Splitting.cs");

	}

	//
	public void fixResidueEntry(int tIndex, int vertLength, int normLength) {
		Debug.Log("fixResidueEntry: " + vertLength + ", " + normLength);
		//List<Residue>
		int i = 0;
		while (i < residueSeq.Count) {
			if (tIndex > residueSeq[i].triangles[1]) {
				//nothing happens, keep going.
			} else { //tIndex <= residueSeq[i].triangles[1]
				//tri index must be less than or eq to the value in triangles[1] for the residue at index i.
				if (residueSeq[i].triangles[0] > tIndex) {
					//error case. this can't happen;
				} else {
					//a scenario where the triangle index splits a residue between two meshes.
					//[0,1,2,3,4,5,6,7,8,9,10], length = 11
					//         ^
					//         |
					//       tIndex
					//[0,1,2,3],[4,5,6,7,8,9,10]
					Residue r = residueSeq[i];
					int last = r.triangles[1];

					r.triangles[1] = tIndex-1;
					r.triangles.Add(tIndex);
					r.triangles.Add(last); //last is now "first"

					last = r.vertices[1];
					r.vertices[1] = r.vertices[0]+vertLength-1;
					r.vertices.Add(0);
					r.vertices.Add(last - vertLength);

					last = r.normals[1];
					r.normals[1] = r.normals[0]+normLength-1;
					r.normals.Add(0);
					r.normals.Add(last - normLength);
					
					r.meshIndices.Add(this.meshes.Count-1);
					r.meshIndices.Add(this.meshes.Count);

					residueSeq[i] = r;

					//go through all the previous residue Seqs and update their mesh numbers.
					for (int y = 0; y < i; y++) {
						residueSeq[y].meshIndices.Add(this.meshes.Count-1);
					}

					break;
				}

			}
			i++;
		}
	}
}
	// public Mesh makeMesh() {
	// 	int numTiles = size_x * size_z;
	// 	int numTris = numTiles * 2;
		
	// 	int vsize_x = size_x + 1;
	// 	int vsize_z = size_z + 1;
	// 	int numVerts = vsize_x * vsize_z;
		
	// 	// Generate the mesh data
	// 	Vector3[] vertices = new Vector3[ numVerts ];
	// 	Vector3[] normals = new Vector3[numVerts];
	// 	Vector2[] uv = new Vector2[numVerts];
		
	// 	int[] triangles = new int[ numTris * 3 ];

	// 	int x, z;
	// 	for(z=0; z < vsize_z; z++) {
	// 		for(x=0; x < vsize_x; x++) {
	// 			vertices[ z * vsize_x + x ] = new Vector3( x*tileSize, 0, z*tileSize );
	// 			normals[ z * vsize_x + x ] = Vector3.up;
	// 			uv[ z * vsize_x + x ] = new Vector2( (float)x / vsize_x, (float)z / vsize_z );
	// 		}
	// 	}
	// 	Debug.Log ("Done Verts!");
		
	// 	for(z=0; z < size_z; z++) {
	// 		for(x=0; x < size_x; x++) {
	// 			int squareIndex = z * size_x + x;
	// 			int triOffset = squareIndex * 6;
	// 			triangles[triOffset + 0] = z * vsize_x + x + 		   0;
	// 			triangles[triOffset + 1] = z * vsize_x + x + vsize_x + 0;
	// 			triangles[triOffset + 2] = z * vsize_x + x + vsize_x + 1;
				
	// 			triangles[triOffset + 3] = z * vsize_x + x + 		   0;
	// 			triangles[triOffset + 4] = z * vsize_x + x + vsize_x + 1;
	// 			triangles[triOffset + 5] = z * vsize_x + x + 		   1;
	// 		}
	// 	}
		
	// 	Debug.Log ("Done Triangles!");
		
	// 	// Create a new Mesh and populate with the data
	// 	Mesh mesh = new Mesh();
	// 	mesh.vertices = vertices;
	// 	mesh.triangles = triangles;
	// 	mesh.normals = normals;
	// 	mesh.uv = uv;
		
	// 	// Assign our mesh to our filter/renderer/collider
	// 	// MeshFilter mesh_filter = GetComponent<MeshFilter>();
	// 	// MeshRenderer mesh_renderer = GetComponent<MeshRenderer>();
	// 	// MeshCollider mesh_collider = GetComponent<MeshCollider>();
		
	// 	// mesh_filter.mesh = mesh;
	// 	// mesh_collider.sharedMesh = mesh;
	// 	Debug.Log ("Done Mesh!");
	// 	return mesh;
	// }

		// foreach (Residue r in residueSeq) {
		// 	Debug.Log("r: " + r.name
		// 	+ "," + AminoAcid.OneLetterCode[r.name]
		// 	+ ", triangles: " + r.triangles[0] + "," + r.triangles[1]
		// 	+ ", vertices: " + r.vertices[0] + "," + r.vertices[1]
		// 	+ ", normals: " + r.normals[0] + "," + r.normals[1]
		// 	+ " triangle value at r.triangles[0]: " + triangles[r.triangles[0]]
		// 	+ " triangle value at r.triangles[1]: " + triangles[r.triangles[1]]
		// 	+ " also vertices: " + vertices[r.vertices[0]] + "," + vertices[r.vertices[1]] 
		// 	+ " normals: " + normals[r.normals[0]] + "," + normals[r.normals[1]]);
		// }