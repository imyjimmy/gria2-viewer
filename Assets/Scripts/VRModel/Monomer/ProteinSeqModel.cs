namespace VRModel.Monomer {
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;
	using System.IO;
	
	using System.Text.RegularExpressions;
	// using UI;

	public class ProteinSeqModel : FASTAModel {
		// key contains: complement, indexStart, indexEnd, etc.

		private static ProteinSeqModel _instance;
		public static ProteinSeqModel Instance {
			get {
				if (_instance == null) {
					ProteinSeqModel ProteinSeqModel = new ProteinSeqModel();
					//load the default file for this ProteinSeqModel.
					ProteinSeqModel.readFile(Application.dataPath + "/StreamingAssets/Gria2Data/gria2_protein_sequence_rattus_nrovegicus.fasta");
					_instance = ProteinSeqModel;
				}
				return _instance;
			}
		}

		public ProteinSeqModel() : base() {

		}

		// public void readFile(string path) : base readFile(string path) {
			
		// }
	}
}