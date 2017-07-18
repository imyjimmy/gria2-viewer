
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

	public class DNAModel : FASTAModel {
		// key contains: complement, indexStart, indexEnd, etc.
		public int indexStart;
		public int indexEnd;

		private static DNAModel _instance;
		public static DNAModel Instance {
			get {
				if (_instance == null) {
					DNAModel dnaModel = new DNAModel();
					//load the default file for this DNAModel.
					dnaModel.readFile(Application.dataPath + "/StreamingAssets/Gria2Data/gria2_dna_rattus_nrovegicus.fasta");
					dnaModel.indexStart = 179704629;
					dnaModel.indexEnd = 179584302;
					_instance = dnaModel;
				}
				return _instance;
			}
		}
	
		// public Hashtable exons; // key, value where value = array of exon start, stop coordinates in tuples
		// public Hashtable cds; //coding regions, in the same format above.


		public DNAModel() : base() {

		}

		// public void readFile(string path) : base readFile(string path) {
			
		// }
	}
}
