
namespace VRModel {
	using TnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;

	public class GeneticCode {
		public static readonly Dictionary<string, string> DNAToAA = new Dictionary<string, string> {
			{"ATG", "MET"},
			{"ATA", "ILE"},
			{"ATC", "ILE"},
			{"ATT", "ILE"},
			
			{"CTT", "LET"},
			{"CTC", "LET"},
			{"CTA", "LET"},
			{"CTG", "LET"},
			
			{"TTA", "LET"},
			{"TTG", "LET"},
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
			{"GAA", "GLT"},
			{"GAG", "GLT"},
			
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
			{"GGG", "GLY"}

		};
		public static readonly Dictionary<string, string> RNAToAA = new Dictionary<string, string> {
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

		public static readonly Dictionary<string, List<string>> AAToDNA = new Dictionary<string, List<string>>();
		public static readonly Dictionary<string, List<string>> AAToRNA = new Dictionary<string, List<string>>();

		
	}
}