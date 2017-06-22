/*
*/
namespace VRModel.Algorithms {
	using VRModel.Nucleotides;

	public class Consensus {

		public float identity { get; set; }
		public List<string> agree { get; set; }
		public List<string> disagree { get; set; }

		public List<string> comparisons { get; private set; }

		public Seq type { get; private set; }
		
		public Consensus() {

		}
	}
}