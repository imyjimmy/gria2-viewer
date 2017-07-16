
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
		private DNAModel dna;
		private RNAModel rna;
		private ProteinSeqModel proteinSeq;

		public List<string> alignment;

		private static SequenceModel _instance;
		public static SequenceModel Instance {
			get {
				if(_instance == null) {
					SequenceModel t = new SequenceModel();
					_instance = t;
				}
				return _instance;
			}
		}

		public SequenceModel() {
			//blah blah...
			SequenceAligner seqAligner = new SequenceAligner();
			SequenceModel.Instance.registerSeqType(Seq.DNA);
			SequenceModel.Instance.registerSeqType(Seq.RNA);
		}

		// public FASTAModel registerSeqType(Seq type) {
		// 	switch (type) {
		// 		case Seq.DNA:
		// 		return registerDNAModel();
		// 		case Seq.RNA:
		// 		return registerRNAModel();
		// 		case Seq.AA:
		// 		return registerProteinSeqModel();
		// 	}
		// 	return null;
		// }

		public Nuc getDNA() {
			//
			return Nuc.A;
		}

		//niceName: rattus, mus musculus, etc.
		//int pos: the position we are interested in
		//Nuc n : whether it's A|T|C|G
		//Seq type: DNA or RNA. shouldn't be AA.
		public string getPeptide(string name, int pos, Nuc n, Seq type) {
			Debug.Log("inside getPeptide");
			if (alignment == null) {
				alignment = new List<string>();
			}
			
			ProteinSeqModel p = ProteinSeqModel.Instance;

			seqAligner.align(name, type, p.protein3DSeq);

			// string key; 
			// if (p.niceName.TryGetValue(name, out key)) {
			// 	string[] vals = p.data[key];
			// 	string seq = vals[1];
			// } else {
			// 	//lol
			// }

			return "haha";
		}

		public int getResNum(string niceName, int pos, Nuc n, Seq type) {
			return 0;
		}
		//everything is aligned with respect to Rattus nrovegicus
		//what kind of output are we trying to get?
		// position => % consensus as float, List<string> agree, List<string> disagree
		// consensus class.
		// public Consensus align(List<string> niceName, Seq type) {

		// }

		// //DNA, at certain position ==> RNA or AA at another position.
		// public Consensus crossAlign(string niceName, Seq inSeqType, Seq outSeqType) {

		// }


		// public DNAModel registerDNAModel() {
		// 	if (dna == null) {
		// 		dna = DNAModel.Instance;
		// 	}
		// 	// niceNameDNA = dna.niceName;
		// 	return dna;
		// }

		// public RNAModel registerRNAModel() {
		// 	if (rna == null) {
		// 		rna = RNAModel.Instance;
		// 	}
		// 	// niceNameRNA = rna.niceName;
		// 	return rna;
		// }

		// public ProteinSeqModel registerProteinSeqModel() {
		// 	if (proteinSeq == null) {
		// 		proteinSeq = ProteinSeqModel.Instance;
		// 	}
		// 	// niceNameProtein = ProteinSeqModel.niceName;
		// 	return proteinSeq;
		// }

	}
}