//@todo: this is actually what we refer to as the model.
namespace Controller {
	using UnityEngine;
	using UnityEngine.UI;
	using System.Collections;
	using Hover;

	using Molecule.Model;

	public class ProteinViewController : MonoBehaviour {

		//updates the protein. somehow...
		public void highlightDifferences() {
			Debug.Log("inside ProteinViewController. Clicked Button.");
			Splitting split = new Splitting();
		}
	}
}