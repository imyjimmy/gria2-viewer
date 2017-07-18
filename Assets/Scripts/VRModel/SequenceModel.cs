
namespace VRModel {
	using UnityEngine;
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using VRModel.Algorithms;
	using VRModel.Monomer;

	public enum Seq {DNA, RNA, AA};
	// public DNA
	//maps DNA, RNA, Peptide sequences.
	//interacts with DNAModel, etc.
	public class SequenceModel {
		public DNAModel dna; //@todo: protected?
		public RNAModel rna;
		public ProteinModel proteinSeq;

		public SequenceAligner seqAligner;
		public Dictionary<string, Consensus> alignments;


		// private static SequenceModel _instance;
		// public static SequenceModel Instance {
		// 	get {
		// 		if(_instance == null) {
		// 			SequenceModel t = new SequenceModel();
		// 			_instance = t;
		// 		}
		// 		return _instance;
		// 	}
		// }

		public SequenceModel() {
			//blah blah...
			seqAligner = new SequenceAligner(this);
			alignments = new Dictionary<string, Consensus>();
			registerModel(Seq.DNA);
			registerModel(Seq.RNA);
		}

		private FASTAModel registerModel(Seq type) {
			switch (type) {
				case Seq.DNA:
				return registerDNAModel();
				case Seq.RNA:
				return registerRNAModel();
				case Seq.AA:
				return registerProteinModel();
			}
			return null;
		}

		public Nuc getDNA() {
			//
			return Nuc.A;
		}

		//niceName: rattus, mus musculus, etc.
		//int pos: the position we are interested in
		//Nuc n : whether it's A|T|C|G
		//Seq type: DNA or RNA. shouldn't be AA.
		public string getPeptide(string name, int pos, Nuc n, Seq type) {
			string result;
			string key = name + "," + name + ":" + type.ToString() + "," + Seq.AA.ToString();
			
			int index;
			int offset = 0;
			FASTAModel m = registerModel(type); //lol
			if (m.GetType() == typeof(RNAModel)) {
				offset = (m as RNAModel).exonStartIndices[0];
			} else { //dna model, uses start index.
				offset = (m as DNAModel).indexStart;
			}
			
			Consensus alignment;
			if (!alignments.TryGetValue(key, out alignment)) { //alignment is null, create one.
				if (proteinSeq == null) {
					registerProteinModel();
				}
				Debug.Log("inside getPeptide");
				alignment = seqAligner.alignTo3DProtein(name, type, proteinSeq._3DSeq);
				alignment.id = key;
				alignments[key] = alignment;
			} else { 
				// (alignment != null)
			}

			index = alignment.getResNum(pos - offset , n);
			if ( index == -1 ) {
				return "-";
			}
			result = proteinSeq._3DSeq[index].name;

			return result;
		}

		//NOTICE: VERY SIMILAR TO GETPEPTIDE. @todo: create a common helper function for these two functions.
		public int getPeptidePos(string name, int pos, Nuc n, Seq type) {
			Debug.Log("getPeptidePos");
			int index;
			int offset = 0;
			FASTAModel m = registerModel(type); //lol
				if (m.GetType() == typeof(RNAModel)) {
					offset = (m as RNAModel).exonStartIndices[0];
				} else { //dna model, uses start index.
					offset = (m as DNAModel).indexStart;
				}
			
			Consensus alignment;
			string key = name + "," + name + ":" + type.ToString() + "," + Seq.AA.ToString();
			Debug.Log("getPeptidePos, key: " + key);
			
			if (alignments.TryGetValue(key, out alignment)) {
				index = alignment.getResNum(pos - offset , n);
				if ( index == -1 ) {
					return -1; //"-"
				}
			} else { //make the alignment object.
				if (proteinSeq == null) {
					registerProteinModel();
				}

				alignment = seqAligner.alignTo3DProtein(name, type, proteinSeq._3DSeq);
				alignment.id = key;
				alignments[key] = alignment; //warning, overwrite the old val at the given key!
			}

			index = alignment.getResNum(pos - offset , n);
			if ( index == -1 ) {
				return -1; //"-"
			}

			return index;
		}
		//public getXPeptide() { ...@todo }

		//niceName: rattus, mus musculus, etc.
		//int pos: the position we are interested in
		//Nuc n : whether it's A|T|C|G
		//Seq type: DNA or RNA. shouldn't be AA.
		//returns the residue number of the 3d protein to which the Nuc n int pos refers.

		//everything is aligned with respect to Rattus nrovegicus
		//what kind of output are we trying to get?
		// position => % consensus as float, List<string> agree, List<string> disagree
		// consensus class.
		// public Consensus align(List<string> niceName, Seq type) {

		// }

		// //DNA, at certain position ==> RNA or AA at another position.
		// public Consensus crossAlign(string niceName, Seq inSeqType, Seq outSeqType) {

		// }


		private DNAModel registerDNAModel() {
			if (dna == null) { //guarantees instance is only set once.
				dna = DNAModel.Instance;
			}
			// niceNameDNA = dna.niceName;
			return dna;
		}

		private RNAModel registerRNAModel() {
			if (rna == null) {
				rna = RNAModel.Instance;
			}
			// niceNameRNA = rna.niceName;
			return rna;
		}

		private ProteinModel registerProteinModel() {
			if (proteinSeq == null) {
				proteinSeq = ProteinModel.Instance;
			}
			// niceNameProtein = ProteinModel.niceName;
			return proteinSeq;
		}

	}
}