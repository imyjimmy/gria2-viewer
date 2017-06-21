
namespace VRModel {

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
	}
}