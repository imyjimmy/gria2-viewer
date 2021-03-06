
namespace VRController {
	using UnityEngine;
	using UnityEngine.UI;
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using Hover.Core.Items.Types;
	using Hover.Core.Cursors;
	using Hover.Core.Renderers;

	using VRModel;
	using VRModel.Monomer;
	using VRModel.Algorithms;

	public class DNAPanelController : MonoBehaviour {
		private static DNAPanelController _instance;
		public static DNAPanelController Instance { 
			get { 
				if (_instance == null) {
					DNAPanelController dnaPanel = new DNAPanelController();
					_instance = dnaPanel; 
				}

				return _instance;
			}
		}

		//GRIA2 DNA: 179704629-179584302

		/* UI elements */
		public GameObject DNA_Panel;
		private GameObject Center;

		private GameObject Look;
		private GameObject RightIndex;

		private GameObject DNAUI;
		private GameObject RightIndexUI;
		private GameObject RightIndexSelection;

		private HoverCursorFollower HoverLookCursor;
		private Transform HoverRightIndexTransform;
		// public FollowCursor Look; 

		/* DNA start, end indices */
		private int startIndex;
		private int endIndex;

		public DNAModel DNA_Model;
		private string key;
		private int seqLength;
		private SequenceModel seqModel;

		//textures...
		private int textureX = 64;
		private int textureY; 
		private int numRows;
		public float tileSize = 1.0f;
		public bool viewGenerated = false;
		public float uvPos = 0.0f;
		private float textureOffset = 0.0f;

		public Vector2 oldLookUV = new Vector2(-100.0f, -100.0f);
		public Vector2 oldUVRightIndex = new Vector2(-100.0f, -100.0f);

		//event handing via delegates
		public delegate void OnUVCoordChange(Vector2 uv);
		public static event OnUVCoordChange UVCoordChangedEvent;

		public delegate void OnNiceNameChange(string name);
		public static event OnNiceNameChange NiceNameChangedEvent;

		public void Awake() {
			Debug.Log("DNAPanelController.Awake()");
			_instance = this;

			Center = GameObject.Find("CenterEyeAnchor");
			Look = GameObject.Find("CursorRenderers/Look");
			RightIndex = GameObject.Find("HoverKit/Cursors/RightHand/RightIndex");
			
			//@todo: this should be in the DNAModel.
			//ex: startIndex = DNAModel.startIndex("rattus nrovegicus");
			// startIndex = 0;
			// endIndex = 79;
			startIndex = 179704629; //hard coded for now. gria2 rattus nrovegicus.
			endIndex = 179584302;
		}

		//
		public void Start() {
			Debug.Log("DNAPanelController.Start()");

			DNA_Model = DNAModel.Instance;	//get the DNA Model.
			key = DNA_Model.niceName["Rattus norvegicus"];
			seqLength = DNA_Model.data[key][1].Length;
			textureY = seqLength / textureX;
			numRows = 24;

			Debug.Log("numRows: " + numRows + " seqLength: " + seqLength + " textureX: " + textureX);
			//Load UIs
			DNAUI = GameObject.Find("CursorRenderers/Look/DNA_Letter_UI");
			DNAUI.SetActive(false);
			RightIndexUI = GameObject.Find("CursorRenderers/RightIndex/DNA_Letter_UI");
			RightIndexUI.SetActive(false);
			RightIndexSelection = GameObject.Find("CursorRenderers/RightIndex/HoverOpaqueCursorArcRenderer-Default");


			// DNA_Model.readFile(Application.dataPath + "/StreamingAssets/Gria2Data/1L2Y_nuc.fasta");

			//figure out where the user is looking and pointing.
			HoverLookCursor = Look.GetComponent<HoverCursorFollower>();
			HoverRightIndexTransform = RightIndex.transform;

			//subscribe updateUV method to UVCoordChangedEvent.
			UVCoordChangedEvent += updateRightIndexUV; 
			// UVCoordChangedEvent += updateLookUV;
		    NiceNameChangedEvent += updateNiceNameKey;
		    Debug.Log("added UVCoordChangedEvent events");
		}

		public void Update() {
			// Vector2? _uvLook = getUVFromCursor(HoverLookCursor);

			Vector2? _uvRightIndex = getUVFromCursor(HoverRightIndexTransform);
			if (_uvRightIndex != null && gameObject.GetComponent<Renderer>().enabled && isPanelSelected()) {
				Vector2 uvRightIndex = _uvRightIndex.Value;
				Debug.Log("uvRightIndex: " + uvRightIndex + " oldUVRightIndex: " + oldUVRightIndex);
				if (uvRightIndex != oldUVRightIndex && UVCoordChangedEvent != null) {
					UVCoordChangedEvent(uvRightIndex);
				}
			} else {
				Debug.Log("getUVFromCursor was called but the right conditions were not met\nto consider UVCoordChangedEvents");
				Invoke("turnOffUI",2);
			}
		}

		public bool isPanelSelected() {
			HoverIndicator hi = RightIndexSelection.GetComponent<HoverIndicator>();
			return (hi.SelectionProgress >= 0.8f);
		}

		public void turnOffUI() {
			HoverIndicator hi = RightIndexSelection.GetComponent<HoverIndicator>();
			if (hi != null) {
				if (hi.SelectionProgress < 0.05f) {
					RightIndexUI.SetActive(false);
				}
			}
		}

		public Vector2? getUVFromCursor(Transform t) {
			if (t != null) {
				RaycastHit? raycastHit = raycastHitCursor(t);

				if (raycastHit == null) {
	            	return null;
				}

				RaycastHit hit = raycastHit.Value;
				Renderer renderer = hit.transform.GetComponent<Renderer>();
				MeshCollider meshCollider = hit.transform.GetComponent<MeshCollider>();
				MeshFilter mf = hit.transform.GetComponent<MeshFilter>();

				Texture2D texture = renderer.material.mainTexture as Texture2D;
	        	Vector2 uv = hit.textureCoord;
	        	
	        	uv.x = texture.width - uv.x*texture.width;
	        	uv.y = uv.y * texture.height + textureOffset; //* 0.0255f @imyjimmy

	        	Debug.Log("textureCoord: " + uv + " color: " + texture.GetPixel((int)uv.x, (int)uv.y));
	        	// Debug.Log("int coords: " + (int) uv.x + ", " + (int) uv.y);

	        	return uv;
        	} else {
        		return null;
        	}	
		}	

		public RaycastHit? raycastHitCursor(Transform t) {
			Vector3 rcWorldPos = t.position;
			Vector3 localPos = t.InverseTransformPoint(t.position);
			Vector3 offset = new Vector3(0.0f, 1.0f, -0.35f); //new Vector3(0.0f,-.25f,-1.2f), 
			Vector3 result = rcWorldPos - offset;
			Debug.DrawLine(rcWorldPos, result ,Color.cyan);
			// Debug.DrawRay(new Vector3(0.0f,-.25f,-1.2f), rcWorldPos, Color.yellow);
			int mask = 1 << 14;
			mask = ~mask;
			RaycastHit raycastHit;
			if (!Physics.Linecast(rcWorldPos, result, out raycastHit, mask)) {
				return null;
			}
			return raycastHit;
		}

		public void updateLabel(GameObject label, Vector2 uv) {
			// Debug.Log("updating label.");
			Text t = label.GetComponent<Text>();
			t.text = getNucAcidForUV(uv);
		}

		public int getSeqPos(Vector2 uv) {
			int toReturn = ((int) uv.y) * textureX + (int) uv.x;
			// Debug.Log("getSeqPos(uv): " + uv + " pos: " + toReturn);
			return toReturn;
		}

		public string getNucAcidForUV(Vector2 uv) {
			string result = "";
			
			if (key != null) {
				int pos = ((int) uv.y) * textureX + (int) uv.x;
				string[] values = (string[]) DNA_Model.data[key]; //use that nicename thing now!
				// string[] values = (string[]) DNA_Model.data[">TC5b"];
				string seq = values[1];
				// Debug.Log("sequence length: " + seq.Length + " pos: " + pos);

				char code = seq[pos];

				int dnaPos = 0;
				if (startIndex < endIndex) {
					dnaPos = startIndex + pos;
				} else { //reverse complement scenario
					dnaPos = startIndex - pos;
				}

				result = code + ":" + dnaPos.ToString();
			}
			return result;
		}

		// should I even?!
		// public int getPosForUV(Vector2 uv) {
		// 	if (key != null) {
		// 		int pos = ((int) uv.y) * textureX + (int) uv.x;
		// 	}
		// }

		public void updateLookUV(Vector2 uv) {
			Debug.Log("inside update UV. oldUV: " + oldLookUV + " new uv: " + uv);
			oldLookUV = uv;
		}

		public void updateRightIndexUV(Vector2 uv) {
			Debug.Log("inside update UV. oldUV: " + oldUVRightIndex + " new uv: " + uv);
			bool updateLabelCond = !oldUVRightIndex.Equals(new Vector2(0.0f, 0.0f));

			oldUVRightIndex = uv;
			
			RightIndexUI.SetActive(true);
			foreach (Transform child in RightIndexUI.transform) {
				// Debug.Log("child: " + child);
				child.gameObject.SetActive(true);
				MonoBehaviour[] scripts = child.gameObject.GetComponents<MonoBehaviour>();
				foreach (MonoBehaviour m in scripts) {
					m.enabled = true;
				}
			}

			Canvas c = RightIndexUI.GetComponentInChildren(typeof(Canvas)) as Canvas; //GameObject.Find("CursorRenderers/Look/DNA_Letter_UI/Canvas/Label");
			GameObject label = (GameObject) c.transform.FindChild("Label").gameObject;
			label.SetActive(true);

			if (updateLabelCond) {
				updateLabel(label, uv);
			}
		}

		public void updateNiceNameKey(string name) {
			key = DNA_Model.niceName[name];
			textureY = DNA_Model.data[key][1].Length / textureX;
		}

		//called by Molecule3D.ToggleDNA
		public void BuildMeshUVs() {
			Debug.Log("BuildMesh DNA_Plane. numRows: " + numRows + " seqLength: " + seqLength + " textureX: " + textureX);
			int test = (seqLength / textureX) / numRows;
			Debug.Log("divide: " + test);
			Debug.Log("casting to float: " + (float) test);
			// Debug.Log(gameObject.name);
			Mesh mesh = gameObject.GetComponent<MeshFilter>().mesh;
			Vector2[] uvs = mesh.uv;
			float yFactor = (float) 1.0 / (float) ((seqLength / textureX) / numRows);
			Vector2 factor = new Vector2(1.00f, yFactor); //0.0255;
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

		public void UpdateMeshTexture(float v) {
			MeshRenderer mesh_renderer = GetComponent<MeshRenderer>();
			mesh_renderer.material.SetTextureOffset("_MainTex", new Vector2(0.0f, -1.0f * v));
			textureOffset = -1.0f * v * (float) ((seqLength / textureX) / numRows);
		}

		public void BuildTexture() { //, ParseDNA parseDNA) {
			//this.DNA_Model = parseDNA;

			Debug.Log("inside build texture");
			string[] val = DNA_Model.data[key];
			string sequence = val[1];

			var texture = new Texture2D(textureX, textureY, TextureFormat.BGRA32, true);
 			GetComponent<Renderer>().material.mainTexture = texture;    		

   	  		texture.SetPixel(textureX, textureY, Color.black); // mark the end of this texture.
   	  		
			Debug.Log("sequence: " + sequence);

			for (int i=0; i< sequence.Length; i++) {
				Nuc n = Nucleotide.CharToNuc(sequence[i]);
				texture.SetPixel(i % textureX, i / textureX, Nucleotide.defaultColor[n]);
			}

     		texture.filterMode = FilterMode.Point;
    	 	texture.Apply();
		}

		public void updatePosition(HoverItemDataSlider slider) {
			float v = slider.Value;
			Debug.Log("updating slider, value: " + v);
			UpdateMeshTexture(v);
			//1.0 = 0.0%, 0.0 = 100.0%;
		}

		/* EXPERIMENTAL GET CDS */
		public void getCDS() {
			if (seqModel == null) {
				seqModel = new SequenceModel();
			}
			List<string> cds = seqModel.getCDS(key);
			BuildCDSTexture(cds);
		}

		public void ungetCDS() {
			//@todo.
		}

		public void BuildCDSTexture(List<string> cds) {
			Debug.Log("inside build CDS texture");
			string sequence1 = cds[0];
			string sequence2 = cds[1];

			var texture = new Texture2D(textureX, textureY, TextureFormat.BGRA32, true);
 			GetComponent<Renderer>().material.mainTexture = texture;    		

 			//@todo: get new textureX, textureY values from alignment.
   	  		texture.SetPixel(textureX, textureY, Color.black); // mark the end of this texture.
   	  		
			Debug.Log("sequence2: " + sequence2);
			if (sequence1.Length != sequence2.Length) {
				throw new Exception("two sequences from alignment are not the same length.");
			}

			for (int i=0; i< sequence1.Length; i++) {
				Nuc n1 = Nucleotide.CharToNuc(sequence1[i]);
				Nuc n2 = Nucleotide.CharToNuc(sequence2[i]);

				if ( n1 == n2) {
					texture.SetPixel(i % textureX, i / textureX, Nucleotide.litColor[n1]);
				} else {
					texture.SetPixel(i % textureX, i / textureX, Nucleotide.dimColor[n1]);
				}
			}

     		texture.filterMode = FilterMode.Point;
    	 	texture.Apply();	
		}
	}

}