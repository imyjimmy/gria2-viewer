//author: @imyjimmy
//loads fasta files.

namespace ParseData.ParseFASTA {
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

	public class ParseFASTA {

		public Hashtable data; //key: ">NM_001001775.3" 
								//value : [descr, sequence]
								//example: ["Gallus gallus glutamate ionot...subunit 2 (GRIA2),...mRNA",
								// ATTATCCC...]

		public ParseFASTA() {
			data = new Hashtable();
		}

		public void readFile(string path) {
			Debug.Log("inside readFile for fasta data.");
			StreamReader reader = new StreamReader(path);

			string key, descr, val;
			key = descr = val = string.Empty;

			while (!reader.EndOfStream) {
				string line = reader.ReadLine();

				Match m = Regex.Match(line, @"^>\S+");
				if (m.Success) { // starts with >alpha-numeric_stuff , that's the key...
					if (key != string.Empty && val != string.Empty) {	//add the prev key value pair, if available.
						Debug.Log("key: " + key + " value: " + val + " descr: " + descr);
						this.addData(ref key, ref descr, ref val);
						Debug.Log("key: " + key + " value: " + val + " descr: " + descr);
					}

					key = m.Value;
					Debug.Log("matched the key: " + key);
					descr = line.Substring(m.Length-1, line.Length-(m.Length-1));
				} else {
					line = Regex.Replace(line, @"\t|\n|\r", "");
					val += line;
				}
			}

			Debug.Log("key: " + key + " value: " + val + " descr: " + descr);
			this.addData(ref key, ref descr, ref val);
			Debug.Log("key: " + key + " value: " + val + " descr: " + descr);

			reader.Close();
		}

		public void addData(ref string key, ref string descr, ref string val) {
			string[] values = new string[2] {descr, val};
			this.data.Add(key, values);
			key = descr = val = string.Empty;
		}
	}
}