using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Splitting {
	private static int vertexLimit = 65000;
	private int[] triangles;
	private Vector3[] vertices;
	private Vector3[] normals;
	private Color32[] colors;
	private int currentIndex;
	private List<Mesh> meshes;
	private int lastIndex;

	//from catlike coding
	public int size_x = 100;
	public int size_z = 50;
	public float tileSize = 1.0f;
	
	//@imyjimmy fuck.
	public List<Mesh> Split(MeshData mData) {
		triangles = mData.triangles;
		vertices = mData.vertices;
		normals = mData.normals;
		colors = mData.colors;
		meshes = new List<Mesh>();

		Mesh m;

		if(UI.UIData.isGLIC)
			vertexLimit = 59520;
		
		// Small meshes don't need to be split
		if(mData.vertices.Length < vertexLimit) {
			Debug.Log("Vertices size : "+vertices.Length);
			Debug.Log("   triangle size : "+ triangles.Length);
			Mesh mesh = new Mesh();
			mesh.vertices = vertices;
			mesh.triangles = triangles;
			mesh.normals = normals;
			mesh.colors32 = colors;
			meshes.Add(mesh);

			m = this.makeMesh();
			// meshes.Add(m);
			return meshes;
		}
		
		lastIndex = triangles.Length;
		
		while(currentIndex < lastIndex) {
			FillMesh();
		}
		
		m = this.makeMesh();
		// meshes.Add(m);

		return meshes;
	}
	
	public Mesh makeMesh() {
		int numTiles = size_x * size_z;
		int numTris = numTiles * 2;
		
		int vsize_x = size_x + 1;
		int vsize_z = size_z + 1;
		int numVerts = vsize_x * vsize_z;
		
		// Generate the mesh data
		Vector3[] vertices = new Vector3[ numVerts ];
		Vector3[] normals = new Vector3[numVerts];
		Vector2[] uv = new Vector2[numVerts];
		
		int[] triangles = new int[ numTris * 3 ];

		int x, z;
		for(z=0; z < vsize_z; z++) {
			for(x=0; x < vsize_x; x++) {
				vertices[ z * vsize_x + x ] = new Vector3( x*tileSize, 0, z*tileSize );
				normals[ z * vsize_x + x ] = Vector3.up;
				uv[ z * vsize_x + x ] = new Vector2( (float)x / vsize_x, (float)z / vsize_z );
			}
		}
		Debug.Log ("Done Verts!");
		
		for(z=0; z < size_z; z++) {
			for(x=0; x < size_x; x++) {
				int squareIndex = z * size_x + x;
				int triOffset = squareIndex * 6;
				triangles[triOffset + 0] = z * vsize_x + x + 		   0;
				triangles[triOffset + 1] = z * vsize_x + x + vsize_x + 0;
				triangles[triOffset + 2] = z * vsize_x + x + vsize_x + 1;
				
				triangles[triOffset + 3] = z * vsize_x + x + 		   0;
				triangles[triOffset + 4] = z * vsize_x + x + vsize_x + 1;
				triangles[triOffset + 5] = z * vsize_x + x + 		   1;
			}
		}
		
		Debug.Log ("Done Triangles!");
		
		// Create a new Mesh and populate with the data
		Mesh mesh = new Mesh();
		mesh.vertices = vertices;
		mesh.triangles = triangles;
		mesh.normals = normals;
		mesh.uv = uv;
		
		// Assign our mesh to our filter/renderer/collider
		// MeshFilter mesh_filter = GetComponent<MeshFilter>();
		// MeshRenderer mesh_renderer = GetComponent<MeshRenderer>();
		// MeshCollider mesh_collider = GetComponent<MeshCollider>();
		
		// mesh_filter.mesh = mesh;
		// mesh_collider.sharedMesh = mesh;
		Debug.Log ("Done Mesh!");
		return mesh;
	}
	
	private void FillMesh() {
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
		
		bool roomLeft = true;
		
		while( roomLeft && (currentIndex < lastIndex) ) {
			// The dictionary may contain the correct index for this vertex
			// in the context of the current mesh. That means the vertex already exists
			// in the local mesh.
			if(dict.TryGetValue(triangles[currentIndex], out index)) {
				tris.Add(index);
			} else {
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
			if( (currentVertex > vertexLimit) && ( (currentIndex+1) % 3 == 0) )
			//if(currentVertex > 10000)
				roomLeft = false;
			
			// Next item in triangles
			currentIndex ++;
			
		}
		
		Mesh mesh = new Mesh();
		mesh.vertices = verts.ToArray();
		mesh.triangles = tris.ToArray();
		mesh.normals = norms.ToArray();
		mesh.colors32 = cols.ToArray();
		
		meshes.Add(mesh);
	}
}