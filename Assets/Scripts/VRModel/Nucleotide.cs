/* 
* @imyjimmy
*/
namespace VRModel {
	using UnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;

	public enum Nuc {A,T,C,G,X}; //X is used to mark ends of nucleotide sequences.

	public class Nucleotide { //call it types? StaticEnums? lol
		

		public static readonly Dictionary<Nuc, string> nucStr = new Dictionary<Nuc, string> {
			{Nuc.A, "A"},
			{Nuc.T, "T"},
			{Nuc.C, "C"},
			{Nuc.G, "G"},
			{Nuc.X, "X"}
		};

		public static readonly Dictionary<Nuc, Color> defaultColor = new Dictionary<Nuc, Color> {
			{Nuc.A, UnityEngine.Color.green},
			{Nuc.C, UnityEngine.Color.blue},
			{Nuc.T, UnityEngine.Color.red},
			{Nuc.G, UnityEngine.Color.yellow},
			{Nuc.X, UnityEngine.Color.black}
		};

		// public static readonly Dictionary<Nuc, Color32> defaultColor32 = new Dictionary<Nuc, Color32> {

		// };

		public static Nuc charToNuc(char c) {
			return strToNuc(Char.ToString(c));
		}

		public static Nuc strToNuc(string x) {
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