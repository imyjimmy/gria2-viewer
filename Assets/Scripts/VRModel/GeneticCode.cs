
namespace VRModel {
	using UnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;

	public class GeneticCode {
		//@todo: add hashtable representing degeneracy
		
		public static readonly Dictionary<string, string> DNAtoAA = new Dictionary<string, string> {
			{"ATG", "MET"},
			{"ATA", "ILE"},
			{"ATC", "ILE"},
			{"ATT", "ILE"},
			
			{"CTT", "LEU"},
			{"CTC", "LEU"},
			{"CTA", "LEU"},
			{"CTG", "LEU"},
			
			{"TTA", "LEU"},
			{"TTG", "LEU"},
			{"TTT", "PHE"},
			{"TTC", "PHE"},
			
			{"GTT", "VAL"},
			{"GTC", "VAL"},
			{"GTA", "VAL"},
			{"GTG", "VAL"},
			
			{"TCT", "SER"},
			{"TCC", "SER"},
			{"TCA", "SER"},
			{"TCG", "SER"},
			
			{"CCT", "PRO"},
			{"CCC", "PRO"},
			{"CCA", "PRO"},
			{"CCG", "PRO"},
			
			{"ACT", "THR"},
			{"ACC", "THR"},
			{"ACA", "THR"},
			{"ACG", "THR"},
			
			{"GCT", "ALA"},
			{"GCC", "ALA"},
			{"GCA", "ALA"},
			{"GCG", "ALA"},
			
			{"TAT", "TYR"},
			{"TAC", "TYR"},
			{"TAA", "STOP"},
			{"TAG", "STOP"},
			
			{"CAT", "HIS"},
			{"CAC", "HIS"},
			{"CAA", "GLN"},
			{"CAG", "GLN"},
			
			{"AAT", "ASN"},
			{"AAC", "ASN"},
			{"AAA", "LYS"},
			{"AAG", "LYS"},
			
			{"GAT", "ASP"},
			{"GAC", "ASP"},
			{"GAA", "GLU"},
			{"GAG", "GLU"},
			
			{"TGT", "CYS"},
			{"TGC", "CYS"},
			{"TGA", "STOP"},
			{"TGG", "TRP"},

			{"CGT", "ARG"},
			{"CGC", "ARG"},
			{"CGA", "ARG"},
			{"CGG", "ARG"},

			{"AGT", "SER"},
			{"AGC", "SER"},
			{"AGA", "ARG"},
			{"AGG", "ARG"},

			{"GGT", "GLY"}, 
			{"GGC", "GLY"},
			{"GGA", "GLY"},
			{"GGG", "GLY"},
			{"---", "---"}
		};
		
		public static readonly Dictionary<string, string> RNAtoAA = new Dictionary<string, string> {
			{"AUG", "MET"},
			{"AUA", "ILE"},
			{"AUC", "ILE"},
			{"AUU", "ILE"},
			
			{"CUU", "LEU"},
			{"CUC", "LEU"},
			{"CUA", "LEU"},
			{"CUG", "LEU"},
			
			{"UUA", "LEU"},
			{"UUG", "LEU"},
			{"UUU", "PHE"},
			{"UUC", "PHE"},
			
			{"GUU", "VAL"},
			{"GUC", "VAL"},
			{"GUA", "VAL"},
			{"GUG", "VAL"},
			
			{"UCU", "SER"},
			{"UCC", "SER"},
			{"UCA", "SER"},
			{"UCG", "SER"},
			
			{"CCU", "PRO"},
			{"CCC", "PRO"},
			{"CCA", "PRO"},
			{"CCG", "PRO"},
			
			{"ACU", "THR"},
			{"ACC", "THR"},
			{"ACA", "THR"},
			{"ACG", "THR"},
			
			{"GCU", "ALA"},
			{"GCC", "ALA"},
			{"GCA", "ALA"},
			{"GCG", "ALA"},
			
			{"UAU", "TYR"},
			{"UAC", "TYR"},
			{"UAA", "STOP"},
			{"UAG", "STOP"},
			
			{"CAU", "HIS"},
			{"CAC", "HIS"},
			{"CAA", "GLN"},
			{"CAG", "GLN"},
			
			{"AAU", "ASN"},
			{"AAC", "ASN"},
			{"AAA", "LYS"},
			{"AAG", "LYS"},
			
			{"GAU", "ASP"},
			{"GAC", "ASP"},
			{"GAA", "GLU"},
			{"GAG", "GLU"},
			
			{"UGU", "CYS"},
			{"UGC", "CYS"},
			{"UGA", "STOP"},
			{"UGG", "TRP"},

			{"CGU", "ARG"},
			{"CGC", "ARG"},
			{"CGA", "ARG"},
			{"CGG", "ARG"},

			{"AGU", "SER"},
			{"AGC", "SER"},
			{"AGA", "ARG"},
			{"AGG", "ARG"},

			{"GGU", "GLY"}, 
			{"GGC", "GLY"},
			{"GGA", "GLY"},
			{"GGG", "GLY"}
		};

		public static readonly Dictionary<string, List<string>> AAtoDNA = new Dictionary<string, List<string>>{
			{"MET", new List<string>{"ATG"}},
			{"ILE", new List<string>{"ATA", "ATC", "ATT"}},
			{"LEU", new List<string>{"CTT", "CTC", "CTA", "CTG", "TTA", "TTG"}},
			{"PHE", new List<string>{"TTT", "TTC"}},
			{"VAL", new List<string>{"GTT", "GTC", "GTA", "GTG"}},
			{"SER", new List<string>{"TCT", "TCC", "TCA", "TCG", "AGT", "AGC"}},
			{"PRO", new List<string>{"CCT", "CCC", "CCA", "CCG"}},
			{"THR", new List<string>{"ATC", "ACC", "ACA", "ACG"}},
			{"ALA", new List<string>{"GCT", "GCC", "GCA", "GCG"}},
			{"TYR", new List<string>{"TAT", "TAC"}},
			{"STOP", new List<string>{"TAA", "TAG", "TGA"}},
			{"HIS", new List<string>{"CAT", "CAC"}},
			{"GLN", new List<string>{"CAA", "CAG"}},
			{"ASN", new List<string>{"AAT", "AAC"}},
			{"LYS", new List<string>{"AAA", "AAG"}},
			{"ASP", new List<string>{"GAT", "GAC"}},
			{"GLU", new List<string>{"GAA", "GAG"}},
			{"CYS", new List<string>{"TGT", "TGC"}},
			{"TRP", new List<string>{"TGG"}},
			{"ARG", new List<string>{"CGT", "CGC", "CGA", "CGG", "AGA", "AGG"}},
			{"GLY", new List<string>{"GGT", "GGC", "GGA", "GGG"}},
			{"---", new List<string>{"---"}}
		};
		//public static readonly Dictionary<string, List<string>> AAToRNA = new Dictionary<string, List<string>>();
	}
}