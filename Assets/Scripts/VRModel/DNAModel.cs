
namespace VRModel {
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

		private static DNAModel _instance;
		public static DNAModel Instance {
			get {
				if (_instance == null) {
					DNAModel dnaModel = new DNAModel();
					_instance = dnaModel;
				}
				return _instance;
			}
		}
	
		public Hashtable exons; // key, value where value = array of exon start, stop coordinates in tuples
		public Hashtable cds; //coding regions, in the same format above.

		/*Tuple<int, int>[] tuples =
			{
			    Tuple.Create(50, 350),
			    Tuple.Create(50, 650),
			    ...
			}; */

		public DNAModel() : base() {

		}

		// public void readFile(string path) : base readFile(string path) {
			
		// }
	}
}
