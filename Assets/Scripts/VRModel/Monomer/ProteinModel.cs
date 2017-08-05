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

		private static ProteinModel _instance;
		public static ProteinModel Instance {
			get {
				if (_instance == null) {
					ProteinModel p = new ProteinModel();
					//load the default file for this ProteinSeqModel.
					// p.readFile(Application.dataPath + "/StreamingAssets/Gria2Data/gria2_protein_sequence_rattus_nrovegicus.fasta");
					p.readFile(Application.dataPath + "/StreamingAssets/CACNB2Data/CACNB2_Protein_rattus_norvegicus.fasta");
					// 3DSeq = new List<Residue>();
					_instance = p;
				}
				return _instance;
			}
		}

		public ProteinModel() : base() {

		}

		public override void addData(string key, string descr, string val) {
			string[] values = new string[2] {descr, val};
			this.data.Add(key, values);

			string[] temp = values[0].Split('[');
			string name = temp[1].Split(']')[0];
			
			this.niceName.Add(name, key);
			this.niceName.Add(key, name);
		}
		
		// public void readFile(string path) : base readFile(string path) {
			
		// }
	}
}