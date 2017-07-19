namespace VRModel.Monomer {
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;
	using System.IO;
	using System.Text.RegularExpressions;
	using VRModel;
	using VRModel.Monomer;

	public class RNAModel : FASTAModel {
		public List<int> exonStartIndices;

		// public List<List<string>> orfSeq;
		public List<string> translatedSeq;

		private static RNAModel _instance;
		public static RNAModel Instance {
			get {
				if (_instance == null) {
					RNAModel rnaModel = new RNAModel();
					//load the default file for this RNAModel.
					rnaModel.exonStartIndices = new List<int>();
					rnaModel.exonStartIndices.Add(0); //default to this for now.
					rnaModel.readFile(Application.dataPath + "/StreamingAssets/Gria2Data/gria2_mRNA_rattus_nrovegicus.fasta");
					_instance = rnaModel;
				}
				return _instance;
			}
		}
	
		// public Hashtable exons; // key, value where value = array of exon start, stop coordinates in tuples
		// public Hashtable cds; //coding regions, in the same format above.


		public RNAModel() : base() {

		}

		// public void readFile(string path) : base readFile(string path) {
			
		// }

		public override void addData(string key, string descr, string val) {
			string v = string.Copy(val);
			inferTranslation(v);
			base.addData(key, descr, val);
		}

		public void inferTranslation(string val) {
			translatedSeq = new List<string>();
			for (int i=0; i< (val.Length - 2) / 3; i++) {
				string triplet = "" + val[3*i] + val[3*i+1] + val[3*i+2];
				string aa = GeneticCode.DNAtoAA[triplet];
				Debug.Log("RNAModel.inferTranslation: triplet: " + triplet + " aa: " + aa);
				translatedSeq.Add(aa);
			}			
		}
	}
}

			// if (orfSeq == null) {
			// 	for (int offset = 0; offset < 3; offset++) {
			// 		List<string> currList = new List<string>();
			// 		if (offset > 0) {
			// 			Debug.Log("orfSeq[0]: " + orfSeq[0] + " currList: " + currList);
			// 		}
			// 		for (int i=0; i< val.Length - 2 - offset; i++) {
			// 			string triplet = val[i+offset] + val[i+1+offset] + val[i+2+offset];
			// 			Debug.Log("RNAModel.inferORFS: triplet: " + triplet);
			// 			string aa = GeneticCode.DNAtoAA[triplet];
			// 			currList.Add(aa);
			// 		}
			// 		orfSeq.Add(currList);
			// 	}
			// }

			//return orfSeq;