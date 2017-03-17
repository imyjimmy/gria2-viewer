//@imyjimmy
namespace View.DNA {
	using UnityEngine;
	using System.Collections;

	[ExecuteInEditMode]
	[RequireComponent(typeof(MeshFilter))]
	[RequireComponent(typeof(MeshRenderer))]
	[RequireComponent(typeof(MeshCollider))]

	public class TileDNA : MonoBehaviour {
		
		public int size_x = 100;
		public int size_z = 50;
		public float tileSize = 1.0f;
		public bool viewGenerated = false;

		// private GameObject DNA_Plane;
		
		// Use this for initialization
		void Start () {
			// DNA_Plane = GameObject.Find("DNA_Plane");
			// gameObject.SetActive(false);
		}
		
		public void BuildMesh() {
			Debug.Log("BuildMesh DNA_Plane");

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
			MeshFilter mesh_filter = GetComponent<MeshFilter>();
			MeshRenderer mesh_renderer = GetComponent<MeshRenderer>();
			MeshCollider mesh_collider = GetComponent<MeshCollider>();
			
			mesh_filter.mesh = mesh;
			mesh_collider.sharedMesh = mesh;
			Debug.Log ("Done Mesh!");
			
		}
		
		
	}
}
