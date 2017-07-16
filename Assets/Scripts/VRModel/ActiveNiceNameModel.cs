
namespace VRModel {
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;

	public class ActiveNiceNameModel {

		public delegate void ActiveNiceNameChanged(string Nicename);
		public static event ActiveNiceNameChanged OnActiveNiceNameChangedEvent;

		public List<string> activeNiceNames; 

		private static ActiveNiceNameModel _instance;
		public static ActiveNiceNameModel Instance {
			get {
				if (_instance == null) {
					ActiveNiceNameModel names = new ActiveNiceNameModel();
					_instance = names;
				}
				return _instance;
			}
		}


		public ActiveNiceNameModel() {
			activeNiceNames = new List<string>();
			OnActiveNiceNameChangedEvent += updateNiceName;	

			activeNiceNames.Add("Rattus norvegicus"); //defaults man...
		}

		public void updateNiceName(string name) {
			string result = activeNiceNames.Find(x => x.Equals(name));
			if (result == null) {
				activeNiceNames.Add(name);
			}
			foreach (string x in activeNiceNames) {
				if (x.Equals(name)) {
					activeNiceNames.Remove(x);
					break;
				}
			}
		}
	}
}