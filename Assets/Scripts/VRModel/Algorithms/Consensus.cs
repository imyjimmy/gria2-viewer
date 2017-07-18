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
		public List<List<string>> nucXaa;
		public List<string> aas { get; set; }
		
		public Consensus() {
			// nucXaa = new List<List<string>>{ new List<string>(), new List<string>()};
		}

		public int getResNum(int pos, Nuc n) {
			if (nucXaa == null) {
				AAListToNuc();
			}

			string nuc = nucXaa[0][pos];
			if (Nucleotide.NucToStr(n).Equals(nuc)) { //matches our data struct, implying correct alignment

				return pos/3;
			} else {
				//something wrong
				Debug.Log("something went wrong in Consensus.getResNum. res numbers and Nuc n do not match.");
				//NOTE: it could be the case that the alignment went like so:
				// ATG | GAG        | --- | GTA       | GGT |
				// M   |  somehting | L   | something | something
				//                    ^ 
				// therefore getResNum(6, G) now refers to ---, L. instead of G of the original pos 6.
				// such cases all fall into this branch.
				return -1; 
			}
		}

		public void AAListToNuc() { //populates nucXaa list. assumes first string is going back to RNA.

		}

		//@todo: public int getNucPos(int pos, string residue) {}
	}
}