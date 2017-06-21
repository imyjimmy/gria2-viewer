/* 
* @imyjimmy
*/
namespace VRModel {
	using UnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;

	public class Nucleotides { //call it types? StaticEnums? lol
		public enum Nuc {A,T,C,G};

		public static readonly Dictionary<Nuc, string> nucStr = new Dictionary<Nuc, string> {
			{Nuc.A, "A"},
			{Nuc.T, "T"},
			{Nuc.C, "C"},
			{Nuc.G, "G"}
		};

		public static readonly Dictionary<Nuc, Color> defaultColor = new Dictionary<Nuc, Color> {
			{Nuc.A, UnityEngine.Color.green},
			{Nuc.C, UnityEngine.Color.blue},
			{Nuc.T, UnityEngine.Color.red},
			{Nuc.G, UnityEngine.Color.yellow}
		};

		// public static readonly Dictionary<Nuc, Color32> defaultColor32 = new Dictionary<Nuc, Color32> {

		// };
	}
}