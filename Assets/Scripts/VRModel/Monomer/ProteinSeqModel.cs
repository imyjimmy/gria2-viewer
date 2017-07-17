namespace VRModel.Monomer {
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;
	using System.IO;
	using VRModel; //do I need to specify this?
	
	using System.Text.RegularExpressions;
	// using UI;

	public class ProteinModel : FASTAModel {
		// key contains: complement, indexStart, indexEnd, etc.
		public List<Residue> _3DSeq;

		private static ProteinSeqModel _instance;
		public static ProteinSeqModel Instance {
			get {
				if (_instance == null) {
					ProteinSeqModel p = new ProteinSeqModel();
					//load the default file for this ProteinSeqModel.
					p.readFile(Application.dataPath + "/StreamingAssets/Gria2Data/gria2_protein_sequence_rattus_nrovegicus.fasta");
					// 3DSeq = new List<Residue>();
					_instance = p;
				}
				return _instance;
			}
		}

		public ProteinModel() : base() {

		}

		// public void readFile(string path) : base readFile(string path) {
			
		// }
	}
}