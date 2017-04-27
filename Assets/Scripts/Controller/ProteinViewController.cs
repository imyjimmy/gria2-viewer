//@todo: this is actually what we refer to as the model.
namespace Controller {
	using UnityEngine;
	using UnityEngine.UI;
	using System.Collections;
	using Hover;

	using Molecule;
	using Molecule.Model;

	public class ProteinViewController : MonoBehaviour {
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

		//updates the protein. somehow...
		public void showOnModel() {
			Debug.Log("inside ProteinViewController. Clicked Button.");
			split.updateSplit();
		}
	}
}