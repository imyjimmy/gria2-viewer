
namespace Controller {
	using UnityEngine;
	using UnityEngine.UI;
	using System.Collections;
	using Hover.Core.Items.Types;

	//todo: consider putting ParseDNA in model, rename it DNAModel?
	using ParseData.ParseFASTA;
	using View.NucleicAcids;

	public class DNAPlaneController : MonoBehaviour {
		//GRIA2 DNA: 179704629-179584302

		private Camera camera;
		private GameObject Look;
		private GameObject DNAUI;

		private int startIndex;
		private int endIndex;

		public ParseDNA DNA_Model;

		//textures...
		public int textureX = 128;
		public int textureY = 941; // must be sequence length / 128.
		public float tileSize = 1.0f;
		public bool viewGenerated = false;
		public float uvPos = 0.0f;

		public void Awake() {

		}

		public void Start() {
			startIndex = 179704629; //hard coded for now.
			endIndex = 179584302;

			camera = Camera.main;
			Debug.Log("DNA Plane camera: " + camera.transform);
			Look = GameObject.Find("CursorRenderers/Look");
			DNAUI = GameObject.Find("CursorRenderers/Look/DNA_Letter_UI");
			DNAUI.SetActive(false);
			Debug.Log("DNAUI is active?: " + DNAUI.activeInHierarchy);

			//workaround until I implement singleton model.
			DNA_Model = new ParseDNA();
			DNA_Model.readFile(Application.dataPath + "/StreamingAssets/Gria2_data/gria2_dna_rattus_nrovegicus.fasta");
		}

		public void Update() {
			// Debug.Log("DNA Letter UI" + DNAUI);
			// Debug.Log("gameObject: " gameObject.name);

			Debug.DrawRay(camera.transform.position, camera.transform.forward, Color.red);
			Vector2? uv = raycastLookCursor();

			if (uv != null) {
				DNAUI.SetActive(true);
				foreach (Transform child in DNAUI.transform) {
					// Debug.Log("child: " + child);
					child.gameObject.SetActive(true);
					MonoBehaviour[] scripts = child.gameObject.GetComponents<MonoBehaviour>();
					foreach (MonoBehaviour m in scripts) {
						m.enabled = true;
					}
				}
				GameObject label = GameObject.Find("CursorRenderers/Look/DNA_Letter_UI/Canvas/Label");
				label.SetActive(true);
				updateLabel(label, uv.Value);
			} else {
				DNAUI.SetActive(false);
			}
		}

		public Vector2? raycastLookCursor() {
			RaycastHit raycastHit;
			if (!Physics.Raycast(camera.transform.position, camera.transform.forward, out raycastHit)) {
            	return null;
			}

			Renderer renderer = raycastHit.transform.GetComponent<Renderer>();
			MeshCollider meshCollider = raycastHit.transform.GetComponent<MeshCollider>();
			MeshFilter mf = raycastHit.transform.GetComponent<MeshFilter>();

			//mf.uv;

			// if (meshRenderer == null || meshRenderer.sharedMaterial == null || 
			// 	meshRenderer.sharedMaterial.mainTexture == null || meshCollider == null){
			// 	return null;
			// }

			// Debug.Log("got meshRenderer, meshCollider");

			Texture2D texture = renderer.material.mainTexture as Texture2D;
        	Vector2 uv = raycastHit.textureCoord;
        	Vector2 uv2 = raycastHit.textureCoord2;
        	uv.x = texture.width - uv.x*texture.width;
        	uv.y = uv.y * texture.height; //* 0.0255f 

        	Debug.Log("textureCoord: " + uv + " color: " + texture.GetPixel((int)uv.x, (int)uv.y));
        	Debug.Log("int coords: " + (int) uv.x + ", " + (int) uv.y);

        	return uv;		
		}	

		public void updateLabel(GameObject label, Vector2 uv) {
			// Debug.Log("in nucleic Acid bruh");
			Text t = label.GetComponent<Text>();
			t.text = getNucAcidForUV(uv);
		}

		public string getNucAcidForUV(Vector2 uv) {
			// foreach (DictionaryEntry de in DNA_Model.data) {
			// 	string[] val = (string[]) de.Value;
			// 	Debug.Log("Key = " + de.Key + ", Descr = " + val[0] + ", Value = " + val[1]);
			// }
			// Debug.Log((int) uv.x + "," + (int) uv.y);

			int pos = ((int) uv.y) * textureX + (int) uv.x;

			string[] values = (string[]) DNA_Model.data[">NC_005101.4:c179704629-179584302"];
			string seq = values[1];
			// Debug.Log("sequence: " + seq.Length + " pos: " + pos);

			char code = seq[pos];

			int dnaPos = 0;
			if (startIndex < endIndex) {
				dnaPos = startIndex + pos;
			} else { //reverse complement scenario
				dnaPos = startIndex - pos;
			}

			string result = code + ":" + dnaPos.ToString();
			return result;
		}
	
		//called by Molecule3D.ToggleDNA
		public void BuildMesh(GameObject DNA_Plane) {
			Debug.Log("BuildMesh DNA_Plane");
			Debug.Log(gameObject.name);
			Mesh mesh = gameObject.GetComponent<MeshFilter>().mesh;
			Vector2[] uvs = mesh.uv;
			
			Vector2 factor = new Vector2(1.00f, 0.0255f); //0.0255;
			for (int i=0; i<uvs.Length; i++) {
				uvs[i] = Vector2.Scale(uvs[i], factor);
			}

			mesh.uv = uvs;
			
			// Assign our mesh to our filter/renderer/collider
			MeshFilter mesh_filter = GetComponent<MeshFilter>();
			MeshRenderer mesh_renderer = GetComponent<MeshRenderer>();
			MeshCollider mesh_collider = GetComponent<MeshCollider>();
			
			mesh_renderer.material.SetTextureScale("_MainTex", new Vector2(-1,1)); //flips uvs so that 0,0 starts at upper left.

			mesh_filter.mesh = mesh;
			mesh_collider.sharedMesh = mesh;
			Debug.Log ("Done Mesh!");
		}

		public void BuildTexture(GameObject DNA_Plane, ParseDNA parseDNA) {
			this.DNA_Model = parseDNA;

			Debug.Log("inside build texture");
			string sequence = "";
			foreach (DictionaryEntry de in parseDNA.data) {
				string[] val = (string[]) de.Value;
				Debug.Log("Key = " + de.Key + ", Descr = " + val[0] + ", Value = " + val[1]);
				Debug.Log("dna.length: " + val[1].Length);
				sequence = val[1];
			}

			var texture = new Texture2D(textureX, textureY, TextureFormat.BGRA32, true);
 			GetComponent<Renderer>().material.mainTexture = texture;    		

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

		public void updatePosition(HoverItemDataSlider slider) {
			float v = slider.Value;
			Debug.Log("value: " + v);
			//1.0 = 0.0%, 0.0 = 100.0%;
		}
	}

}