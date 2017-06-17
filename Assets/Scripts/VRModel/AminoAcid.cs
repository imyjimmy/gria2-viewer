
namespace VRModel {
	
	using UnityEngine;
	using System.Collections;
	using System.Collections.Generic;

	public static class AminoAcid {

		public static readonly Dictionary<string, string> OneLetterCode = new Dictionary<string, string> {
			{"GLY", "G"},
			{"Glycine", "G"},
			{"ALA", "A"},
			{"Alanine", "A"},
			{"LEU", "L"},
			{"Leucine", "L"},
			{"MET", "M"},
			{"Methionine", "M"},
			{"PHE", "F"},
			{"Phenylalanine", "F"},
			{"TRP", "W"},
			{"Tryptophan", "W"},
			{"LYS", "K"},
			{"Lysine", "K"},
			{"GLN", "Q"},
			{"Glutamine", "Q"},
			{"GLU", "E"},
			{"Glutamic Acid", "E"},
			{"SER", "S"},
			{"Serine", "S"},
			{"PRO", "P"},
			{"Proline", "P"},
			{"VAL", "V"},
			{"Valine", "V"},
			{"ILE", "I"},
			{"Isoleucine", "I"},
			{"CYS", "C"}, 
			{"Cysteine", "C"},
			{"TYR", "Y"},
			{"Tyrosine", "Y"},
			{"HIS", "H"},
			{"Histidine", "H"},
			{"ARG", "R"},
			{"Arginine", "R"},
			{"ASN", "N"},
			{"Asparagine", "N"},
			{"ASP", "D"},
			{"Aspartic Acid", "D"},
			{"THR", "T"},
			{"Threonine", "T"}
		};

		public static readonly Dictionary<string, string> FullName = new Dictionary<string, string> {
			{"GLY", "Glycine"}, 
			{"G", "Glycine"},
			{"ALA", "Alanine"},
			{"A", "Alanine"},
			{"LEU", "Leucine"},
			{"L", "Leucine"},
			{"MET", "Methionine"},
			{"M", "Methionine"},
			{"PHE", "Phenylalanine"},
			{"F", "Phenylalanine"},
			{"TRP", "Tryptophan"},
			{"W", "Tryptophan"},
			{"LYS", "Lysine"},
			{"K", "Lysine"},
			{"GLN", "Glutamine"},
			{"Q", "Glutamine"},
			{"GLU", "Glutamic Acid"},
			{"E", "Glutamic Acid"},
			{"SER", "Serine"},
			{"S", "Serine"},
			{"PRO", "Proline"},
			{"P", "Proline"},
			{"VAL", "Valine"},
			{"V", "Valine"},
			{"ILE", "Isoleucine"},
			{"I", "Isoleucine"},
			{"CYS", "Cysteine"},
			{"C", "Cysteine"},
			{"TYR", "Tyrosine"},
			{"Y", "Tyrosine"},
			{"HIS", "Histidine"},
			{"H", "Histidine"},
			{"ARG", "Arginine"},
			{"R", "Arginine"},
			{"ASN", "Asparagine"},
			{"N", "Asparagine"},
			{"ASP", "Aspartic Acid"},
			{"D", "Aspartic Acid"}, 
			{"THR", "Threonine"},
			{"T", "Threonine"}
		};

		public static readonly Dictionary<string, string> ThreeLetterCode = new Dictionary<string, string> {
			{"Glycine", "GLY"}, 
			{"G", "GLY"},
			{"Alanine", "ALA"},
			{"A", "ALA"},
			{"Leucine", "LEU"},
			{"L", "LEU"},
			{"Methionine", "MET"},
			{"M", "MET"},
			{"Phenylalanine", "PHE"},
			{"F", "PHE"},
			{"Tryptophan", "TRP"},
			{"W", "TRP"},
			{"Lysine", "LYS"},
			{"K", "LYS"},
			{"Glutamine", "GLN"},
			{"Q", "GLN"},
			{"Glutamic Acid", "GLU"},
			{"E", "GLU"},
			{"Serine", "SER"}, 
			{"S", "SER"},
			{"P", "PRO"},
			{"Proline", "PRO"},
			{"V", "VAL"},
			{"Valine", "VAL"},
			{"Isoleucine", "ILE"},
			{"I", "ILE"},
			{"Cysteine", "CYS"},
			{"C", "CYS"},
			{"Tyrosine", "TYR"},
			{"Y", "TYR"},
			{"Histidine", "HIS"},
			{"H", "HIS"},
			{"Arginine", "ARG"},
			{"R", "ARG"},
			{"Asparagine", "ASN"},
			{"N", "ASN"},
			{"Aspartic Acid", "ASP"},
			{"D", "ASP"},
			{"Threonine", "THR"},
			{"T", "THR"}
		};
	}
}