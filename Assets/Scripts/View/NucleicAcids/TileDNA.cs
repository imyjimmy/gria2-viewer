//@imyjimmy
//Should probably move it to controller...
namespace View.NucleicAcids {
	using UnityEngine;
	using System.Collections;

	using ParseData.ParseFASTA;

	[ExecuteInEditMode]
	[RequireComponent(typeof(MeshFilter))]
	[RequireComponent(typeof(MeshRenderer))]
	[RequireComponent(typeof(MeshCollider))]

	public class TileDNA : MonoBehaviour {
		
		// public int size_x = 20;
		// public int size_z = 128;

		public int textureX = 128;
		public int textureY = 941; // must be sequence length / 128.

		public float tileSize = 1.0f;
		public bool viewGenerated = false;

		// private Material material;

		// private GameObject DNA_Plane;
		
		// this script is not active on start.
		void Start () {

		}
		
		//called by Molecule3D.ToggleDNA
		public void BuildMesh(GameObject DNA_Plane) {
			Debug.Log("BuildMesh DNA_Plane");
			Mesh mesh = DNA_Plane.GetComponent<MeshFilter>().mesh;
			Vector2[] uvs = mesh.uv;
			
			Vector2 factor = new Vector2(1.00f, 0.0255f);
			for (int i=0; i<uvs.Length; i++) {
				uvs[i] = Vector2.Scale(uvs[i], factor);
			}

			mesh.uv = uvs;
			
			// Assign our mesh to our filter/renderer/collider
			// MeshFilter mesh_filter = GetComponent<MeshFilter>();
			MeshRenderer mesh_renderer = DNA_Plane.GetComponent<MeshRenderer>();
			// MeshCollider mesh_collider = DNA_Plane.GetComponent<MeshCollider>();
			
			mesh_renderer.material.SetTextureScale("_MainTex", new Vector2(-1,1)); //flips uvs so that 0,0 starts at upper left.

			Debug.Log ("Done Mesh!");
		}

		public void BuildTexture(GameObject DNA_Plane, ParseDNA parseDNA) {
			Debug.Log("inside build texture");
			string sequence = "";
			foreach (DictionaryEntry de in parseDNA.data) {
				string[] val = (string[]) de.Value;
				Debug.Log("Key = " + de.Key + ", Descr = " + val[0] + ", Value = " + val[1]);
				Debug.Log("dna.length: " + val[1].Length);
				sequence = val[1];
			}

			var texture = new Texture2D(textureX, textureY, TextureFormat.BGRA32, true);
 			DNA_Plane.GetComponent<Renderer>().material.mainTexture = texture;    		

   	  		texture.SetPixel(textureX, textureY, Color.black); // mark the end of this texture.
   	  		
			Debug.Log("sequence: " + sequence);

			for (int i=0; i< sequence.Length; i++) {
				switch(sequence[i]) {
					case 'A':
						//something
						texture.SetPixel(i % textureX, i / textureX, A.color);
						break;
					case 'T':
						texture.SetPixel(i % textureX, i / textureX, T.color);
						break;
					case 'C':
						texture.SetPixel(i % textureX, i / textureX, C.color);
						break;
					case 'G':
						texture.SetPixel(i % textureX, i / textureX, G.color);
						break;
					case 'X':
						texture.SetPixel(i % textureX, i / textureX, Color.black);
						break;
				}
			}
     		texture.filterMode = FilterMode.Point;
    	 	texture.Apply();
		}

		// public void setColor(Texture2D texture, int width, int height, Color nucColor) {
		// 	Color[] colorBlock = new Color[width * height];
		// 	for (int i = 0; i < colorBlock.Length; i++) {
		// 		colorBlock[i] = nucColor;
		// 	}
		// 	texture.SetPixels(colorBlock);
		// }
	}
}