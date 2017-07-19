/*
*/
namespace VRModel.Algorithms {
	using UnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using VRModel.Monomer;

	public class Consensus { //consensus generator?

		public string id { get; set; } //format: "niceName1, niceName2, ... : Seq.Type1, Seq.Type2, ... etc"

		public List<string> nucs { get; set; }
		public List<int[]> cds { get; set; }
		public List<List<string>> nucMapAA { get; set; }
		public List<string> nucXaa { get; set; } //
		public List<string> aas { get; set; }
		
		public Consensus() {
			nucXaa = new List<string>();
		}

		public int getResNum(int pos, Nuc n) {
			if (nucXaa.Count == 0) {
				AAConsensusNucList();
			}

			Debug.Log("pos: " + pos); 
			Debug.Log("nucXaa[0]: " + nucXaa[0]);
			Debug.Log(" nucXaa[0].Length: " + nucXaa[0].Length);
			string nuc = Char.ToString(nucXaa[0][pos]);
			if (Nucleotide.NucToStr(n).Equals(nuc)) { //matches our data struct, implying correct alignment

				return pos/3;
			} else {
				//something wrong
				//NOTE: it could be the case that the alignment went like so:
				// 012   345          678   9
				// ATG | GAG        | --- | GTA       | GGT |      //sequence mRNA
				// M   |  somehting | L   | something | something  //sequence according to 3D protein
				//                    ^ 
				// therefore getResNum(6, G) now refers to ---, L. instead of G of the original pos 6.
				// such cases all fall into this branch.
				string _1stStr = nucXaa[0];
				int numDashes = 0;
				for (int i=0; i < pos; i++) {
					if ( _1stStr[i].Equals('-')) {
						numDashes++;
					}
				}
				Debug.Log("numDashes: " + numDashes);
				nuc = Char.ToString(nucXaa[0][((pos + numDashes) / 3)]);
				if (Nucleotide.NucToStr(n).Equals(nuc)) {
					return (pos + numDashes) / 3;
				}
				Debug.Log("residue can't be found in Consensus for the given seq position in RNA.");
				return -1; 
			}
		}

		//populates nucXaa list using nucMapAA. assumes first string in aas list is going back to RNA.
		public void AAConsensusNucList() {
			string _1stStr = aas[0]; 	//| "LL-COOL-J" | <--Protein seq from mRNA translation.
										//| "LLXCOOLXJ" | <--3D Protein seq from pdb file.
			List<string> codons = nucMapAA[0];
			Debug.Log("AAConsensusNucList: " + _1stStr); 
			foreach (string s in codons){
				Debug.Log("codon: " + s);
			}

			string nucFromAA = "";

			int numDashes = 0;
			for (int i=0; i<_1stStr.Length; i++) {
				if (_1stStr[i].Equals('-')) {
					numDashes++;
					nucFromAA += "---";
				} 
				nucFromAA += codons[i-numDashes];
			}

			nucXaa.Add(nucFromAA);
			nucXaa.Add(aas[1]);
		}

		//@todo: public int getNucPos(int pos, string residue) {}
	}
}