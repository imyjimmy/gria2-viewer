namespace Controller {
	using UnityEngine;
	using UnityEngine.UI;
	using System.Collections;

	//Attach this script to cursors such as Hover's Look cursor.
	public class UIActivatorController : MonoBehaviour {

		public void Awake() {

		}

		public void Start() {
		}

		public void Update() {
			Debug.Log("UIActivatorController.transform: " + this.transform.position);

			Debug.DrawRay(new Vector3(0.0f,-.25f,-1.2f), this.transform.position, Color.green);
		}
	}
}