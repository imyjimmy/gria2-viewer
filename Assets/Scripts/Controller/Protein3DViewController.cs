namespace Controller {
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

		public void Start() {
			//example of referencing a script attached to another component:
			//dnaPlaneController = (DNAPlaneController) DNA_Plane.GetComponent(typeof(DNAPlaneController));
			loadBox = GameObject.Find("LoadBox");
			scene = (ScenePreload_5L1B) loadBox.GetComponent(typeof(ScenePreload_5L1B));
		}

		public void Update() {
			ribbons = scene.ribbons;
			postprocessing = ribbons.postprocessing;
			split = postprocessing.split;
			// Debug.Log("splitting script: " + split); 
		}

		//updates the protein. @todo: make this an event called via delegate.
		public void showOnModel() {
			Debug.Log("inside Protein3DViewController. Clicked Button.");
			split.updateSplit();
		}
	}
}