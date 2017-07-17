namespace VRController {
	using UnityEngine;
	using UnityEngine.UI;
	using System.Collections;
	using Hover;

	using Molecule;
	using Molecule.Model;

	public class Protein3DViewController : MonoBehaviour {
		public GameObject loadBox;
		public ScenePreload_5L1B scene;
		public Ribbons ribbons;
		public PostProcessing postprocessing;
		public Splitting split;

		public delegate void ShowOnModelSelect();
		public static event ShowOnModelSelect SelectedEvent;

		public void Awake() {

		}

		public void Start() {
			//example of referencing a script attached to another component:
			//dnaPlaneController = (DNAPlaneController) DNA_Plane.GetComponent(typeof(DNAPlaneController));
			loadBox = GameObject.Find("LoadBox");
			scene = (ScenePreload_5L1B) loadBox.GetComponent(typeof(ScenePreload_5L1B));

			if (loadBox == null) {
				Debug.Log("loadBox is null");
			}
			if (scene == null) {
				Debug.Log("scene is null");
			}
		}

		public void Update() {
			if (ribbons == null) {
				ribbons = scene.ribbons;
			}
			if (postprocessing == null) {
				postprocessing = ribbons.postprocessing;
			}
			if (split == null) {	
				split = postprocessing.split;
			}
			// Debug.Log("splitting script: " + split); 
		}

		//updates the protein. @todo: make this an event called via delegate.
		public void showOnModel() {
			Debug.Log("inside Protein3DViewController. Clicked Button.");
			//SelectedEvent += UpdateSplit; 
			// split.updateSplit(10);
			DNAPanelController.UVCoordChangedEvent += Update3DModelFocus;
			RNAPanelController.UVCoordChangedEvent += Update3DModelFocus;
			Debug.Log("added Update3DModelFocus to DNA and RNAPanelController");
		}

		public void deregister() {
			DNAPanelController.UVCoordChangedEvent -= Update3DModelFocus;
			RNAPanelController.UVCoordChangedEvent -= Update3DModelFocus;
		}

		public void Update3DModelFocus(Vector2 uv) {
			Debug.Log("Update3DModelFocus, uv: " + uv.x + "," + uv.y);
			int pos = split.getResidueNum(uv);
			split.updateSplit(pos);
		}
	}
}