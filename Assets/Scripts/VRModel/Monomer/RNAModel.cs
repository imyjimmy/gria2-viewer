namespace VRModel.Monomer {
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;
	using System.IO;
	// using ParseData.IParsePDB;
	// using System.Net;
	// using System.Linq;
	// using System;
	// using Molecule.Model;
	// using Molecule.Control;
	// using System.Xml;
	// using System.Text;	
	using System.Text.RegularExpressions;
	// using UI;

	public class RNAModel : FASTAModel {
		public List<int> exonStartIndices;

		private static RNAModel _instance;
		public static RNAModel Instance {
			get {
				if (_instance == null) {
					RNAModel rnaModel = new RNAModel();
					//load the default file for this RNAModel.
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
	}
}