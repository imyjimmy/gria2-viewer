
namespace VRModel.Algorithms {
	using UnityEngine;
	using System;
	using System.IO;
	using System.Collections;
	using System.Collections.Generic;
	using System.Text.RegularExpressions;

	using VRModel;
	using VRModel.Monomer;

	public class SequenceAligner {

		public int openGapPenalty { get; set; }
		public int gapExtPenalty { get; set; }
		public int matchScore { get; set; }
		public int mismatchPenalty { get; set; }

		public Seq seqType { get; set; }
		//public Nuc nucType { get; set; }
		public enum Direction : byte {START, L, T, R, D, LD, LT, LTD };
		
		// private Dictionary<string, Nuc> nSeqs; //nuc seq comparisons
		// private Dictionary<string, string> pSeqs; //protein seq comparisons.
		private Dictionary<string, int> pam100;

		private DNAModel dna;
		private RNAModel rna;
		private ProteinSeqModel proteinSeq;

		//also a Nuc -> string 

		//pairwise
		private int[,] matrix;
		private Direction[,] cell_origin;

		//MSA
		private Dictionary<string, string> msaPairs;
		private Dictionary<string, string> msaPileup;
		private Dictionary<string, float> msaScores;
		private Dictionary<string, float> msaDistances;
		private Dictionary<string, float> msaTransformDistances;

		public SequenceAligner() {
			//set auto properties
			openGapPenalty = -3;
			gapExtPenalty = -1;
			matchScore = 1;
			mismatchPenalty = -1;
			pam100 = new Dictionary<string, int>();
		}

		public FASTAModel registerSequences(Seq type) {
			switch (type) {
				case Seq.DNA:
				return registerDNAModel();
				case Seq.RNA:
				return registerRNAModel();
				case Seq.AA:
				return registerProteinSeqModel();
			}
		}

		public void populatePAM() {
			Debug.Log("inside populatePAM");
			if (pam100 == null) {
				pam100 = new Dictionary<string, int>();
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
		private void needlemanWunsch(string seq1, string seq2) {
			for (int i = 1; i < this.matrix.GetLength(0); i++) {
				for (int j = 1; j < this.matrix.GetLength(1); j++) {
					this.matrix[i, j] = this.scoreEntry(i, j, seq1, seq2);
				}
			}
		}

		//3.1 part of needlemanWunsh
		private int scoreEntry(int i, int j, string seq1, string seq2) {
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
			int diag = this.matrix[i-1, j-1] + this.matchOrMismatch(i-1, j-1, seq1, seq2);
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
		private int decideGapPenalty() {
			if (prev_i < i) { //from top
				if (prev_i != 0 && ( 
					this.matrix[prev_i, prev_j] - this.matrix[prev_i-1, prev_j] == gapExtensionPenalty ||
					this.matrix[prev_i, prev_j] - this.matrix[prev_i-1, prev_j] == openGapPenalty))
					{ //this.cellOrigin(matrix, prev_i, prev_j, seq1, seq2).equals("TOP")
							//the previous cell either started the gap from the same direction or it extended it.
							//prev_i can't be 0, if it were we can't extend the gap from top.
					return gapExtensionPenalty;
				} else { 
					return openGapPenalty;
				}
			} else { //prev_j < j
					//from left
					//analogous logic
				if (prev_j != 0 && (
					this.matrix[prev_i, prev_j] - this.matrix[prev_i, prev_j-1] == gapExtensionPenalty ||
					this.matrix[prev_i, prev_j] - this.matrix[prev_i, prev_j-1] == openGapPenalty)) { 
					//this.cellOrigin(matrix, prev_i, prev_j, seq1, seq2).equals("LEFT")
					return gapExtensionPenalty;
				} else {
					return openGapPenalty;
				}
			}
		}

		//3.3
		private int matchOrMismatch() {
		// // System.out.println("sequence type: " + seq_type);
			if (seqType != seq.AA) { //nucleotide comparison.
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
				if (pam100.TryGetValue("" + x + y, out score) {
					return score;
				}
				else {
					return pam100.TryGetValue("" + y + x, out score);
				}
					// System.out.println("protein score: " + score);
				return score;
			}
		}

    /* 4. getAlignment
    *  next major step.
    *  j is the column, i is the row.
    */
    public void getAlignment(String key1, String key2, String seq1, String seq2) {
        //first, get the max value of the bottom row of 'matrix'
        int max = 0;
        int max_j_index = 0;
        int max_i_index = 0;
        int i = this.matrix.length-1;

        List<Integer>max_i_indices = new ArrayList<Integer>();
        List<Integer>max_j_indices = new ArrayList<Integer>();

        for (int j = 0; j < this.matrix[i].length; j++) {
            if (j == 0) {
                max = this.matrix[i][j];
                max_j_index = 0;

                max_j_indices.add(new Integer(max_j_index));
                max_i_indices.add(new Integer(max_i_index));
            } else {
                if (this.matrix[i][j] > max) {
                    max = this.matrix[i][j];
                    // max_j_index = j;
                    // max_i_index = i;
                    max_j_indices.clear();
                    max_i_indices.clear();

                    // System.out.println("max_j_indices.size(); " + max_j_indices.size());
                    // System.out.println("clearing prev, then adding: " + i + " , " + j);

                    max_j_indices.add(new Integer(j));
                    max_i_indices.add(new Integer(i));
                } else if (matrix[i][j] == max) {
                    //tie. add without clearing.
                    // System.out.println("max_j_indices.size(); " + max_j_indices.size());
                    // System.out.println("adding without clearing: " + i + " , " + j);
                    

                    max_j_indices.add(new Integer(j));
                    max_i_indices.add(new Integer(i));
                }
            }
        }
        //now we have the max along the bottom row.
        //now going along the rightmost column.
        int j = this.matrix[0].length-1;
        for (int k = 0; k < this.matrix.length-1; k++) {
            if (this.matrix[k][j] > max) {
                // System.out.println("along the rightmost column, coordinates of max score: " + k + " , " + j);
                max_j_indices.clear();
                max_i_indices.clear();

                max_j_indices.add(new Integer(j));
                max_i_indices.add(new Integer(k));
                max = matrix[k][j];
            } else if (this.matrix[k][j] == max) {
                // System.out.println("max_j_indices.size(); " + max_j_indices.size());
                // System.out.println("adding without clearing: " + k + " , " + j);
                
                max_j_indices.add(new Integer(j));
                max_i_indices.add(new Integer(k));
            }
        }

        //assuming one max value for now...
        // System.out.println("Max: " + max + " at j: " + max_j_index + " at i: " + max_i_index);

        //@todo: before traverse, pretty print terminal gap
        List<String> terminalGaps = new ArrayList<String>();

        // System.out.println("max_j_indices.size(); " + max_j_indices.size());
        for (int k = 0; k < max_j_indices.size(); k++) {
            String terminalGap = "";
            i = max_i_indices.get(k).intValue();
            j = max_j_indices.get(k).intValue();
            
            // System.out.println("coordinates of max score: " + i + " , " + j);
            int m = this.matrix.length - 1;
            int n = this.matrix[0].length - 1;
            // System.out.println("matrix.length-1: " +  m + " , maxtrix[0].length -1: " + n);
            if (i != matrix.length-1 || j != matrix[0].length -1 ) {
                // System.out.println("adding a terminal gap");
                terminalGaps.add(k, prettyPrintTerminal(i, j, seq1, seq2));
            } else {
                terminalGaps.add(k, "");
            }

            // System.out.println("doing a traverse...");
            // this.numSolutions = 4;
            this.numTies = 5;
            // System.out.println("numSolutions: " + this.numSolutions);
            // System.out.println("numTies: " + this.numTies);
            this.traverse(i, j, max, key1, key2, seq1, seq2, terminalGaps.get(k));
            this.numSolutions = 0;

            if (this.num2kStrings > 1) {
                break;
            }
        }
    }

    public string terminalGap(int i, int j, string seq1, string seq2) {
        string terminal = "";
        if (i < this.matrix.length-1) { //not the bottom row
            // System.out.println("not the bottom row");
            for (int k = i; k < this.matrix.length-1; k++) {
                terminal += "" + "-" + seq1.charAt(k);
                // System.out.println("terminal: " + terminal);
            }
            //example: "-A-A-A"
        } else { //not the rightmost column
            // System.out.println("not the rightmost column");
            for (int l = j; l < this.matrix[0].length-1; l++) {
                terminal += seq2.charAt(l) + "-";
            }
        }

        String reverse = "";
        for (int k = terminal.length()-1; k>=0; k--) {
            reverse += String.valueOf(terminal.charAt(k));
        }
        
        return reverse;
    }

		/* ==========================
		* Public Methods for interaction with other modules below
		*  ==========================
		*/

		public void startPairwise(string name1, Seq type1, string name2, Seq type2) {
			FASTAModel seqModel1 = registerSequences(type1);
			FASTAModel seqModel2 = registerSequences(type2);

			string key1 = seqModel1.niceName[name1];
			string key2 = seqModel2.niceName[name2];
			
			string seq1 = seqModel1.data[key1,1];
			string seq2 = seqModel2.data[key2,1];

			createMatrices(seq1, seq2);
			initializeMatrices();
			needlemanWunsch(seq1, seq2);
			//getAlignment
		}

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



		public DNAModel registerDNAModel() {
			if (dna == null) {
				dna = DNAModel.Instance;
			}
			// niceNameDNA = dna.niceName;
			return dna;
		}

		public RNAModel registerRNAModel() {
			if (rna == null) {
				rna = RNAModel.Instance;
			}
			// niceNameRNA = rna.niceName;
			return rna;
		}

		public ProteinSeqModel registerProteinModel() {
			if (proteinSeq == null) {
				proteinSeq = ProteinSeqModel.Instance;
			}
			// niceNameProtein = ProteinSeqModel.niceName;
			return proteinSeq;
		}



	}
}