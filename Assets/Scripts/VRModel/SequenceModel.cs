
namespace VRModel {
	using System;
	using System.Collections;
	using System.Collections.Generic;
	using VRModel.Algorithms;
	using VRModel.Monomer;


	public enum Seq {DNA, RNA, AA};

	//maps DNA, RNA, Peptide sequences.
	//interacts with DNAModel, etc.
	public class SequenceModel {
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
		}

		public Nuc getDNA() {
			//
			return Nuc.A;
		}

		//niceName: rattus, mus musculus, etc.
		//int pos: the position we are interested in
		//Nuc n : whether it's A|T|C|G
		//Seq type: DNA or RNA. shouldn't be AA.
		public string getPeptide(string niceName, int pos, Nuc n, Seq type) {
			return "G";
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


	}
}