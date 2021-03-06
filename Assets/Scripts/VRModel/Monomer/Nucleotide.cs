/* 
* @imyjimmy
*/
namespace VRModel.Monomer {
	using UnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;

	public enum Nuc {A,T,C,G,X}; //X is used to mark where MSA alignment skips.

	public class Nucleotide {

		public static readonly Dictionary<Nuc, string> nucStr = new Dictionary<Nuc, string> {
			{Nuc.A, "A"},
			{Nuc.T, "T"},
			{Nuc.C, "C"},
			{Nuc.G, "G"},
			{Nuc.X, "-"}
		};

		public static readonly Dictionary<string, Nuc> strNuc = new Dictionary<string, Nuc> {
			{"A", Nuc.A},
			{"T", Nuc.T},
			{"C", Nuc.C},
			{"G", Nuc.G},
			{"-", Nuc.X}
		};

		public static readonly Dictionary<Nuc, Color32> defaultColor = new Dictionary<Nuc, Color32> {
			{Nuc.A, new Color32(68,155,255,255)}, 
			{Nuc.C, new Color32(224,81,62,255)},
			{Nuc.T, new Color32(244,220,110,255)},
			{Nuc.G, new Color32(83,209,131,255)},
			{Nuc.X, new Color32(99,99,99,255)}
		};

		public static readonly Dictionary<Nuc, Color32> dimColor = new Dictionary<Nuc, Color32> {
			{Nuc.A, new Color32(60,101,147,255)},
			{Nuc.C, new Color32(175,84,72,255)},
			{Nuc.T, new Color32(183,169,108,255)},
			{Nuc.G, new Color32(79,135,100,255)},
			{Nuc.X, defaultColor[Nuc.X]}
		};

		public static readonly Dictionary<Nuc, Color32> litColor = new Dictionary<Nuc, Color32> {
			{Nuc.A, new Color32(25,132,255,255)},
			{Nuc.C, new Color32(255,65,40,255)},
			{Nuc.T, new Color32(255,224,89,255)},
			{Nuc.G, new Color32(74,247,140,255)},
			{Nuc.X, defaultColor[Nuc.X]}
		};

		public static Nuc CharToNuc(char c) {
			return strNuc[Char.ToString(c)];
		}

		public static Nuc StrToNuc(string x) {
			try {
				return (Nuc) Enum.Parse(typeof(Nuc), x);
			}
			catch {
				throw new Exception();
			}
		}

		public static string NucToStr(Nuc n) {
			//PetType pet = (PetType)Enum.Parse(typeof(PetType), value); // See if the conversion succeeded: if (pet == PetType.Dog) 
			return n.ToString();
		}
	}
}