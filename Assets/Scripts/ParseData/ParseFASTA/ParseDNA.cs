
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

	public class ParseDNA : ParseFASTA {
	
		public Hashtable exons; // key, value where value = array of exon start, stop coordinates in tuples
		public Hashtable cds; //coding regions, in the same format above.

		/*Tuple<int, int>[] tuples =
			{
			    Tuple.Create(50, 350),
			    Tuple.Create(50, 650),
			    ...
			}; */

		public ParseDNA() : base() {

		}
	}
}
