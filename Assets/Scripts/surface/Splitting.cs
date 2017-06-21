using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Molecule.Model;
using Controller;
using VRModel;
//using Hover.InputModules.Follow;

public class Splitting {
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

	//@imyjimmy called by PostProcessing.GenerateMeshes(List<Vector3> vertices, List<Vector3> normals, 
		//List<int> triangles, List<Color32> colors, int[] ss,
	    //string tag="RibbonObj", string gameobj="Ribbons")
	public List<Mesh> Split(MeshData mData) {
		Debug.Log("inside Split(mData);");

		triangles = mData.triangles;
		vertices = mData.vertices;
		normals = mData.normals;
		colors = mData.colors;
		meshes = new List<Mesh>();

		//get the mapping of each individual residue to its associated normals, triangles, vertices, colors.
		residueSeq = mData.residueSeq;
		
		// debug();

		//register a method to DNAPanel's UVChanged event.
		DNAPanelController.UVCoordChangedEvent += getResidueForUV;

		if(UI.UIData.isGLIC)
			vertexLimit = 59520;
		
		// Small meshes don't need to be split
		if(mData.vertices.Length < vertexLimit) {
			Debug.Log("Within vertex limit.\nVertices size : "+vertices.Length);
			Debug.Log("   triangle size : "+ triangles.Length);
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

	//@imyjimmy proof of concept of adding/ changing the mesh.
	public void updateSplit() {
		Debug.Log("inside Splitting. Proof of concept.");
		// Mesh m = this.makeMesh();
		// meshes.Add(m);
		// GameObject ribbObj = new GameObject("Ribbons");
		// ribbObj.tag = "RibbonObj";
		// ribbObj.AddComponent<MeshFilter>();
		// ribbObj.AddComponent<MeshRenderer>();
		// ribbObj.GetComponent<MeshFilter>().mesh = m;
		// ribbObj.GetComponent<Renderer>().material = new Material(Shader.Find("Custom/Ribbons"));
		// ribbObj.transform.position = CENTER;
		// ribbObj.transform.localPosition = CENTER;
	}

	public void getResidueForUV(Vector2 uv) {
		Debug.Log("Splitting.cs: getResidueForUV(uv): " + uv);
		int DNASeqNum = DNAPanelController.Instance.getSeqPos(uv);
	 	string nuc = DNAPanelController.Instance.getNucAcidForUV(uv);
		Debug.Log("Pos: " + DNASeqNum + ", DNA: " + nuc);
	}

	public void generateSubMeshes() {

	}

	public void debug() {
		Debug.Log("triangles length: " + triangles.Length + " normals length: " + normals.Length);
		for (int i=0; i < triangles.Length; i++) {
			Debug.Log("triangles[" + i + "]: " + triangles[i] + "\nnormals[" + i + "]: " + normals[i]);
		}

		Debug.Log("residue info make it to Splitting.cs");
		foreach (Residue r in residueSeq) {
			Debug.Log("r: " + r.name
			+ "," + AminoAcid.OneLetterCode[r.name]
			+ ", triangles: " + r.triangles[0] + "," + r.triangles[1]
			+ ", vertices: " + r.vertices[0] + "," + r.vertices[1]
			+ ", normals: " + r.normals[0] + "," + r.normals[1]
			+ " triangle value at r.triangles[0]: " + triangles[r.triangles[0]]
			+ " triangle value at r.triangles[1]: " + triangles[r.triangles[1]]
			+ " also vertices: " + vertices[r.vertices[0]] + "," + vertices[r.vertices[1]] 
			+ " normals: " + normals[r.normals[0]] + "," + normals[r.normals[1]]);
		}
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
					//error case. how the fuck can this happen!?
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
					r.triangles.Add(last);

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