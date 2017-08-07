
namespace VRModel.Algorithms {
	using UnityEngine;
	using System;
	using System.IO;
	using System.Collections;
	using System.Collections.Generic;
	using System.Text.RegularExpressions;

	using VRModel;

	using VRModel.Monomer;
	
	//Instances of this class execute pairwise alignments using the Needleman-Wunsch algorithm.
	//Gets data from a SequenceModel instance, and populates a Consensus object upon completion.
	//SequenceModel object stores hashes of Consensus objects. See Consensus documentation.  
	public class SequenceAligner {
		public SequenceModel seqModel;
		public string id; // Consensus id in case of doing multiple comparisons in the seqModel.

		public int openGapPenalty { get; set; }
		public int gapExtPenalty { get; set; }
		public int matchScore { get; set; }
		public int mismatchPenalty { get; set; }
		public bool consideringTies { get; set; }

		//public Nuc nucType { get; set; }
		public enum Direction : byte {START, L, T, D, LD, LT, TD, LTD };
		
		// private Dictionary<string, Nuc> nSeqs; //nuc seq comparisons
		// private Dictionary<string, string> pSeqs; //protein seq comparisons.
		private Dictionary<string, int> pam100;

		//also a Nuc -> string 

		//pairwise
		private int[,] matrix;
		private Direction[,] cell_origin;
		private List<string> result;

		//MSA @todo: implement MSA.
		private Dictionary<string, string> msaPairs;
		private Dictionary<string, string> msaPileup;
		private Dictionary<string, float> msaScores;
		private Dictionary<string, float> msaDistances;
		private Dictionary<string, float> msaTransformDistances;

		//sets inital parameters
		public SequenceAligner(SequenceModel _seqModel) {
			seqModel = _seqModel;
			Debug.Log("SequenceAligner(): seqModel: " + seqModel);
			//set auto properties
			openGapPenalty = -3;
			gapExtPenalty = -1;
			matchScore = 1;
			mismatchPenalty = -1;
			consideringTies = false; //can set to true sometime later
			pam100 = new Dictionary<string, int>();
		}

		//PAM100 is a matrix of amino acid substitution likelihoods. Not all amino acids undergo mutation at the same rate.
		public void populatePAM() {
			Debug.Log("inside populatePAM");
			if (pam100.Count == 0) {
				populatePAM();
			}
			string column = string.Empty;
			string line = string.Empty;
			
			Regex rgx = new Regex("\\s+");
			string replacement = "";

			StreamReader reader = new StreamReader(Application.dataPath + "/StreamingAssets/100pam.txt");
			int row = 0;
			do {
				line = reader.ReadLine();
				if ( line.StartsWith(" ")) { //first line
					line = line.Replace(" ", "");
					line = rgx.Replace(line, replacement);
					column = line;
				} else { //not the first line.
					char aa = line[0];
					for (int i = row-1; i < column.Length; i++) {
						string number = line.Substring(3*i+2, 3*i+4);
						number = rgx.Replace(number, replacement);

						int val = int.Parse(number);
						string key = "" + aa + column[i];

						pam100.Add(key, val);
					}
				}
				row++;
			} while (!reader.EndOfStream);

		}

		//1. create matrices.
		private void createMatrices(string seq1, string seq2) {
			matrix = new int[seq1.Length+1, seq2.Length+1];
			cell_origin = new Direction[seq1.Length+1, seq2.Length+1];
		}

		//2. initialize matrices with default values.
		private void initializeMatrices() {
			for (int i = 0; i < this.matrix.GetLength(0); i++) {
				if (i == 0) {
					for (int j = 0; j < this.matrix.GetLength(1); j++) {
						this.matrix[i, j] = 0;
					} 
				} else { //i = 1, 2, etc.
					this.matrix[i, 0] = 0;
				}
			}

			for (int i = 0; i < this.cell_origin.GetLength(0); i++) {
				if (i == 0) {
					for (int j = 0; j < this.cell_origin.GetLength(1); j++) {
						if (j == 0) {
							this.cell_origin[i, j] = Direction.START;
						} else {
							this.cell_origin[i, j] = Direction.L;
						}
					}
				} else {
					this.cell_origin[i, 0] = Direction.T;
				}
			}
		}

		//3. needlemanWunsch
		//global gap alignment begins...//
		private void needlemanWunsch(string seq1, string seq2, Seq type1, Seq type2) {
			for (int i = 1; i < this.matrix.GetLength(0); i++) {
				for (int j = 1; j < this.matrix.GetLength(1); j++) {
					this.matrix[i, j] = this.scoreEntry(i, j, seq1, seq2, type1, type2);
				}
			}
		}

		//3.1 part of needlemanWunsh
		private int scoreEntry(int i, int j, string seq1, string seq2, Seq type1, Seq type2) {
			//from the left
			int left = this.matrix[i, j-1] + this.decideGapPenalty(i, j, i, j-1);
			int max = left; //max score so far. 
			this.cell_origin[i, j] = Direction.L;

			//from top therfore decrement i.
			int top = this.matrix[i-1, j] + this.decideGapPenalty(i, j, i-1, j);
			
			if (top > max) {
				max = top;
				this.cell_origin[i, j] = Direction.T;
			} else if (top == left) {
				//tie score, what to do? max is still same value, but cell_origin needs to take note
				this.cell_origin[i, j] = Direction.LT;
			}

			//DG, LD, TD, ALL;
			int diag = this.matrix[i-1, j-1] + this.matchOrMismatch(i-1, j-1, seq1, seq2, type1, type2);
			if (diag > max) {
				max = diag;
				this.cell_origin[i, j] = Direction.D;
			} else if (diag == max && this.cell_origin[i, j] == Direction.L) {
				this.cell_origin[i, j] = Direction.LD;
			} else if (diag == max && this.cell_origin[i, j] == Direction.T) {
				this.cell_origin[i, j] = Direction.TD;
			} else if (diag == max && this.cell_origin[i, j] == Direction.LT) {
				this.cell_origin[i, j] = Direction.LTD;
			}

			// System.out.println("left: " + left + " top: " + top + " diag: " + diag + " max: " + max);
			return max;
		}

		//3.2
		private int decideGapPenalty(int i, int j, int prev_i, int prev_j) {
			if (prev_i < i) { //from top
				if (prev_i != 0 && ( 
					this.matrix[prev_i, prev_j] - this.matrix[prev_i-1, prev_j] == gapExtPenalty ||
					this.matrix[prev_i, prev_j] - this.matrix[prev_i-1, prev_j] == openGapPenalty))
					{ //this.cellOrigin(matrix, prev_i, prev_j, seq1, seq2).equals("TOP")
							//the previous cell either started the gap from the same direction or it extended it.
							//prev_i can't be 0, if it were we can't extend the gap from top.
					return gapExtPenalty;
				} else { 
					return openGapPenalty;
				}
			} else { //prev_j < j
					//from left
					//analogous logic
				if (prev_j != 0 && (
					this.matrix[prev_i, prev_j] - this.matrix[prev_i, prev_j-1] == gapExtPenalty ||
					this.matrix[prev_i, prev_j] - this.matrix[prev_i, prev_j-1] == openGapPenalty)) { 
					//this.cellOrigin(matrix, prev_i, prev_j, seq1, seq2).equals("LEFT")
					return gapExtPenalty;
				} else {
					return openGapPenalty;
				}
			}
		}

		//3.3
		private int matchOrMismatch(int i, int j, string seq1, string seq2, Seq type1, Seq type2) {
		// // System.out.println("sequence type: " + seq_type);
			if (type1 != Seq.AA && type2 != Seq.AA) { //nucleotide comparison.
				if (seq1[i] == seq2[j]) {
					return matchScore;
				} else {
					return mismatchPenalty;
				}
			} else { //protein comparison. use that pam matrix.
				int score;
				char x = seq1[i];
				char y = seq2[j];
					// System.out.println("Comparing: " + x + " and " + y + "...");
				if (pam100.TryGetValue("" + x + y, out score)) {
					return score;
				}
				else {
					pam100.TryGetValue("" + y + x, out score);
					return score;
				}
					// System.out.println("protein score: " + score);
				return score;
			}
		}

		/* 4. getAlignment
		*  next major step.
		*  j is the column, i is the row.
		*/
		public void getAlignment(string key1, string seq1, string key2, string seq2) { //first, get the max value of the bottom row of 'matrix'		
			int max = 0;
			int max_j_index = 0;
			int max_i_index = 0;
			int i = this.matrix.GetLength(0)-1;

			List<int>max_i_indices = new List<int>();
			List<int>max_j_indices = new List<int>();

			int j = 0;
			for (j = 0; j < this.matrix.GetLength(1); j++) {
				if (j == 0) {
					max = this.matrix[i, j];
					max_j_index = 0;

					max_j_indices.Add(max_j_index);
					max_i_indices.Add(max_i_index);
				} else {
					if (this.matrix[i, j] > max) {
						max = this.matrix[i, j];
										// max_j_index = j;
										// max_i_index = i;
						max_j_indices.Clear();
						max_i_indices.Clear();

										// System.out.println("max_j_indices.size(); " + max_j_indices.size());
										// System.out.println("clearing prev, then adding: " + i + " , " + j);

						max_j_indices.Add(j);
						max_i_indices.Add(i);
					} else if (matrix[i, j] == max) {
										//tie. add without clearing.
										// System.out.println("max_j_indices.size(); " + max_j_indices.size());
										// System.out.println("adding without clearing: " + i + " , " + j);

						max_j_indices.Add(j);
						max_i_indices.Add(i);
					}
				}
			}
				//now we have the max along the bottom row.
				//now going along the rightmost column.
			j = this.matrix.GetLength(1)-1;
			for (int k = 0; k < this.matrix.GetLength(0)-1; k++) {
				if (this.matrix[k, j] > max) {
								// System.out.println("along the rightmost column, coordinates of max score: " + k + " , " + j);
					max_j_indices.Clear();
					max_i_indices.Clear();

					max_j_indices.Add(j);
					max_i_indices.Add(k);
					max = matrix[k, j];
				} else if (this.matrix[k, j] == max) {
								// System.out.println("max_j_indices.size(); " + max_j_indices.size());
								// System.out.println("adding without clearing: " + k + " , " + j);

					max_j_indices.Add(j);
					max_i_indices.Add(k);
				}
			}

				//assuming one max value for now...
				// System.out.println("Max: " + max + " at j: " + max_j_index + " at i: " + max_i_index);

				//@todo: before traverse, pretty print terminal gap
			List<string> terminalGaps = new List<string>();

				// System.out.println("max_j_indices.size(); " + max_j_indices.size());
			for (int k = 0; k < max_j_indices.Count; k++) {
				string terminalGap = "";
				i = max_i_indices[k];
				j = max_j_indices[k];

						// System.out.println("coordinates of max score: " + i + " , " + j);
				int m = this.matrix.GetLength(0) - 1;
				int n = this.matrix.GetLength(1) - 1;
						// System.out.println("matrix.length-1: " +  m + " , maxtrix.GetLength(1) -1: " + n);
				if (i != matrix.GetLength(0)-1 || j != matrix.GetLength(1) -1 ) {
								// System.out.println("adding a terminal gap");
					terminalGaps.Insert(k, terminalGapstring(i, j, seq1, seq2));
				} else {
					terminalGaps.Insert(k, "");
				}

						// System.out.println("doing a traverse...");
						//old variables from Osier's algorithms class, may not need.
						// this.numSolutions = 4;
						// this.numTies = 5;
						// System.out.println("numSolutions: " + this.numSolutions);
						// System.out.println("numTies: " + this.numTies);
				this.traverse(i, j, max, key1, key2, seq1, seq2, terminalGaps[k]);
						// this.numSolutions = 0;

				if ( !consideringTies ) {
					break;
				}
			}
		}

		//returns a string which represents terminal gaps.
		public string terminalGapstring(int i, int j, string seq1, string seq2) {
			string terminal = "";
				if (i < this.matrix.GetLength(0)-1) { //not the bottom row
						// System.out.println("not the bottom row");
					Debug.Log("terminalGapstring, seq1: " + seq1 + "\ni: " + i + "\nmatrix Length(0): " + this.matrix.GetLength(0));
					for (int k = i; k < this.matrix.GetLength(0)-1; k++) {

						terminal += "" + "-" + seq1[k];
								// System.out.println("terminal: " + terminal);
					}
						//example: "-A-A-A"
				} else { //not the rightmost column
						// System.out.println("not the rightmost column");
					for (int l = j; l < this.matrix.GetLength(1)-1; l++) {
						terminal += seq2[l] + "-";
					}
				}

				string reverse = "";
				for (int k = terminal.Length-1; k>=0; k--) {
					reverse += Char.ToString(terminal[k]);
				}
				
				return reverse;
			}

		//traverses the alignment.
		//START, L, T, D, LD, LT, TD, LTD
		//j is the column, i is the row.
		private void traverse(int i, int j, int max, string key1, string key2, string seq1, string seq2, string output) {
			if (cell_origin[i, j] == Direction.START) {
				prettyPrintAlignment(key1, key2, max, output);
			} else if (cell_origin[i, j] == Direction.D) {
        	output += Char.ToString(seq1[i-1]) + Char.ToString(seq2[j-1]);
        	// System.out.println("diag case reached: " + i + "," + j);
        	this.traverse(i-1, j-1, max, key1, key2, seq1, seq2, output);
			} else if (cell_origin[i, j] == Direction.L) {
				output += "-" + Char.ToString(seq2[j-1]);
				this.traverse(i, j-1, max, key1, key2, seq1, seq2, output);
			} else if (cell_origin[i, j] == Direction.T) {
        		output += Char.ToString(seq1[i-1]) + "-";
        		this.traverse(i-1, j, max, key1, key2, seq1, seq2, output);
			} else if (cell_origin[i, j] == Direction.LD) { //left diag
				//traversing diag
        		String temp = output;
        		output += Char.ToString(seq1[i-1]) + Char.ToString(seq2[j-1]);
        		this.traverse(i-1, j-1, max, key1, key2, seq1, seq2, output);  

		        // System.out.println("tie, and there's less than 2 1k strings...");
		        if ( consideringTies ) { //traversing left
		        	temp += Char.ToString(seq1[i-1]) + "-";
		        	this.traverse(i-1, j, max, key1, key2, seq1, seq2, temp);
		        }

			} else if (cell_origin[i, j] == Direction.LT) {
				//left top.
        		// System.out.println("tie between top, left. go left first. i, j: " + i + "," + j);
        		// System.out.println("tie, and there's less than 2 1k strings...");
        		String temp = output;
        
        		output += "-" + Char.ToString(seq2[j-1]);
        		this.traverse(i, j-1, max, key1, key2, seq1, seq2, output); // go left
        		// System.out.println("done going left, now going top");
        
	        	if ( consideringTies ) { //top
	        		temp += Char.ToString(seq1[i-1]) + "-";
	        		this.traverse(i-1, j, max, key1, key2, seq1, seq2, temp);
	      		}  
			} else if (cell_origin[i, j] == Direction.TD) {
	        String temp = output;
	        output += Char.ToString(seq1[i-1]) + Char.ToString(seq2[j-1]);
	        this.traverse(i-1, j-1, max, key1, key2, seq1, seq2, output);  //traversing diag
	        // System.out.println("tie, and there's less than 2 1k strings...");
	        
		        if ( consideringTies ) {
			    	temp += Char.ToString(seq1[i-1]) + "-";
			    	this.traverse(i-1, j, max, key1, key2, seq1, seq2, temp);
			    }

			} else if (cell_origin[i, j] == Direction.LTD) {
				string temp = output;
				string temp2 = output;

	        	output += Char.ToString(seq1[i-1]) + Char.ToString(seq2[j-1]);
	        	this.traverse(i-1, j-1, max, key1, key2, seq1, seq2, output);                 
	        
	        	if ( consideringTies ) {
		        	//left 
		        	temp += "-" + Char.ToString(seq2[j-1]);
		        	this.traverse(i, j-1, max, key1, key2, seq1, seq2, temp);

		        	//top
		        	temp2 += Char.ToString(seq1[i-1]) + "-";
		        	this.traverse(i-1, j, max, key1, key2, seq1, seq2, temp2);
		      	}
			}
		}

		//prints the alignment by adding it to result List.
	    	private void prettyPrintAlignment(string key1, string key2, int max, string alignStr) {
			string reverse = "";
			for (int i = alignStr.Length-1; i>=0; i--) {
			  reverse += Char.ToString(alignStr[i]);
			}
			string top = "";
			string bottom = "";
			for (int i = 0; i < alignStr.Length; i++) {
			  if (i % 2 == 0) {
			    bottom += Char.ToString(reverse[i]);
			  } else {
			    top += Char.ToString(reverse[i]);
			  }
			}
			
			result = new List<string>();
			Debug.Log("SeqAligner: " + alignStr);
			Debug.Log("SeqAligner: " + top + " , " + bottom);
			result.Add(top);
			result.Add(bottom);
	    	}

		//We need to get the data model so we can actually perform the pairwise alignments.
	    	private FASTAModel getFASTAModel(Seq type) {
	    		FASTAModel seq;
	    		switch (type) {
				case Seq.DNA:
				seq = seqModel.dna; //assumes that these have already been registered. 
							//see private registermodel function in SequenceModel.
				break;
				case Seq.RNA:
				seq = seqModel.rna; 
				break;
				case Seq.AA:
				seq = seqModel.proteinSeq;
				break;
				default:
				throw new ArgumentOutOfRangeException();
			}
			return seq;
		}
		
		/* ==========================
		* Public Methods for interaction with other modules (particularly SequenceModel) below
		*  ==========================
		*/
		//for a DNA sequence, get the coding regions 
		//(pairwise align with corresponding mRNA sequence of Gria2 of the same species)
		//@todo: untested and probably doesn't work yet.
		public Consensus getCDS(string name, string id) {
			Consensus c;
			if (!seqModel.alignments.TryGetValue(id, out c)) {
				c = new Consensus();
			}
			startPairwise(name, Seq.DNA, name, Seq.RNA);
			c.nucs = result;
			c.id = id;
			return c;
		}
		
		// translate(mRNA) <== pairwise-align ==> 3D Seq
		// Consensus object will be loaded with the aa seq to aa seq (from 3d protein) alignments
		// The first aa seq will actually have to map back to mRNA nucleotides. But that's job of Consensus.
		// Not sure if it's the best way to do this however. Open to better ideas.
		public Consensus alignTo3DProtein(string name, Seq type, List<Residue> _3DSeq) {
			if (pam100 == null) {
				populatePAM();
			}
			FASTAModel model = getFASTAModel(type);
			string key = model.niceName[name];
			string seq = model.data[key][1];

			id = name + "," + name + ":" + type.ToString() + "," + Seq.AA.ToString();

			Consensus c;
			if (!seqModel.alignments.TryGetValue(id, out c)) { 
				c = new Consensus();
				//map DNA, AA. onto nucXaa.
				List<List<string>> mapping = new List<List<string>>();
				List<string> nuc = new List<string>();
				List<string> aa = new List<string>();

				for (int i=0; i < seq.Length / 3; i++) {
					string codon = "" + seq[i*3] + seq[i*3 + 1] + seq[i*3 + 2];
					string AA3 = GeneticCode.DNAtoAA[codon];
					// Debug.Log("AA3: " + AA3);
					string oneLetter = AminoAcid.OneLetterCode[AA3];
					nuc.Add(codon);
					aa.Add(oneLetter);
				}

				mapping.Add(nuc);
				mapping.Add(aa);

				c.nucMapAA = mapping;

				startPairwise(name, type, name, Seq.AA);
				
				if (c == null) {
					Debug.Log("pairwise algorithm did not work!!!"); //not sure how it follows that if c is null, alg didnt work.
				}
				
				c.aas = result;
				seqModel.alignments[id] = c;
			}

			return c;
		}

		//pairwise alignments begin here. 
		public void startPairwise(string name1, Seq type1, string name2, Seq type2) {	
			FASTAModel model1;
			FASTAModel model2;

			model1 = getFASTAModel(type1);
			model2 = getFASTAModel(type2);

			string key1 = model1.niceName[name1];
			string key2 = model2.niceName[name2];
			
			string seq1 = model1.data[key1][1];
			string seq2 = model2.data[key2][1];

			if (type1 == Seq.RNA && type2 == Seq.AA) {
				seq1 = "";
				seq2 = "";
				foreach( string s in (model1 as RNAModel).translatedSeq) {
					string oneLetter = AminoAcid.OneLetterCode[s];
					seq1 += oneLetter;
				}
				type1 = Seq.AA; //rna model seq goes undercover as the theoretical AA translation.

				if (model2 == null) {
					Debug.Log("model2 is null!!!!");
				}
				foreach ( Residue r in (model2 as ProteinModel)._3DSeq) {
					string oneLetter = AminoAcid.OneLetterCode[r.name];
					seq2 += oneLetter;
				}
			}

			Debug.Log("startPairwise: seq1: " + seq1 + "," + seq2);
			createMatrices(seq1, seq2);
			initializeMatrices();
			needlemanWunsch(seq1, seq2, type1, type2);
			getAlignment(name1, seq1, name2, seq2);
		}

		//@todo: implement this.
		public void startMSA() {
			
			//get keys.
			//while ( keys.Length > 1) {
				// ~ basically pairwise ~ //
				//for
					//for
						//createMatrix
						//cell_origin, Direction[,]
						//initializeMatrix()
						//needlemanWunsch()
						//getAlignment()

				//if (no outgroup)
					//pick an outgroup, populateTransformedDistances

				//pick closest pair
				//generate Consensus Seq

				//Remove Old Keys

				//Add NewKey
				//update keys.
			//}

			//MSA Pileup. Access the Alignment object.
		}

	}
}
