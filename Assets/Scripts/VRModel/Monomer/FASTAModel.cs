//author: @imyjimmy
//loads fasta files.

namespace VRModel.Monomer {
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;
	using System.IO;
	using System.Text.RegularExpressions;
	// using UI;

	public class FASTAModel {

		public Dictionary<string, string[]> data; //key: ">NM_001001775.3"
								//note: DNAModel key contains: complement, indexStart, indexEnd, etc. 
								//value : [descr, sequence]
								//@todo: [descr, indexStart, indexEnd, sequence]
								//value example: ["Gallus gallus glutamate ionot...subunit 2 (GRIA2),...mRNA",
								// ATTATCCC...]
		//public string niceName;
		public Dictionary<string, string> niceName;

		public FASTAModel() {
			data = new Dictionary<string, string[]>();
			niceName = new Dictionary<string, string>();
		}

		//Note: nice name mapping is seperate from reading the file, which just populates the data hashtable.
		public virtual void readFile(string path) {
			Debug.Log("inside readFile for fasta data. path: " + path);
			// string newPath = Application.dataPath + "/StreamingAssets";
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
					Debug.Log("matched the key: " + key + " m.Length: " + m.Length + " line.Length: " + line.Length + " key.Length: " + key.Length);
					descr = line.Substring(m.Length+1, line.Length-(m.Length)-1);
				} else {
					line = Regex.Replace(line, @"\t|\n|\r", "");
					val += line;
				}
			}

			Debug.Log("key: " + key + " descr: " + descr + " value: " + val);
			this.addData(ref key, ref descr, ref val);
			Debug.Log("key: " + key + " descr: " + descr + " value: " + val);

			reader.Close();
		}

		public virtual void addData(ref string key, ref string descr, ref string val) {
			string[] values = new string[2] {descr, val};
			this.data.Add(key, values);
			
			//adding a nicename mapping. key ==> description which usually has species name, is human readable
			//also adding description ==> key mapping so we can go back and forth.
			string[] temp = values[0].Split(' ');
			string name = temp[0] + " " + temp[1];
			Debug.Log("adding nicename: " + name);

			this.niceName.Add(name, key);
			this.niceName.Add(key, name);
			
			key = descr = val = string.Empty;
		}
	}
}