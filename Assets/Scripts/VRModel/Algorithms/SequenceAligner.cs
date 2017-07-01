
namespace VRModel.Algorithms {
  using UnityEngine;
  using System;
  using System.IO;
  using System.Collections;
  using System.Collections.Generic;
  using System.Text.RegularExpressions;


  using VRModel;
  using VRModel.Nucleotides;

  public class SequenceAligner {

    public int openGapPenalty = { get; set; }
    public int gapExtPenalty = { get; set; }
    public int matchScore = { get; set; }
    public int mismatchPenalty = { get; set; }

    public Seq seqType { get; set; }
    //public Nuc nucType { get; set; }
    public enum Direction : byte {ST, L, T, R, D, LD, LT, LTD };
    
    private Dictionary<string, Nuc> nSeqs; //nuc seq comparisons
    private Dictionary<string, string> pSeqs; //protein seq comparisons.
    private Dictionary<string, int> pam100;

    private DNAModel dna;
    private RNAModel rna;
    private ProteinModel protein;

    private Dictionary<string, string> niceNameDNA;
    private Dictionary<string, string> niceNameRNA;
    private Dictionary<string, string> niceNameProtein;

    //also a Nuc -> string 

    //pairwise
    private int[][] matrix;
    private Direction[][] cell_origin;

    //MSA
    private Dictionary<string, string> msaPairs;
    private Dictionary<string, string> msaPileup;
    private Dictionary<string, float> msaScores;
    private Dictionary<string, float> msaDistances;
    private Dictionary<string, float> msaTransformDistances;

    private static SequenceAligner _instance;
    
    public static SequenceAligner Instance {
      get { 
        if (_instance == null) {
          SequenceAligner s = new SequenceAligner();
          _instance = s;
          }
        return _instance;
      }
    }

    public SequenceAligner() {
      //set auto properties
      openGapPenalty = -3;
      gapExtPenalty = -1;
      matchScore = 1;
      mismatchPenalty = -1;

      pam100 = new Dictionary<string, int>();
    }

    public void populateSequences(Seq type) {
      switch (type) {
        case Seq.DNA:
          registerDNAModel();
          niceNameDNA = dna.niceName;
        case Seq.RNA:
          registerRNAModel();
          niceNameRNA = rna.niceName;
        case Seq.AA:
          registerProteinModel();
          niceNameProtein = protein.niceName;
      }
    }

    public void populatePAM() {
      Debug.Log("inside populatePAM");
      string column = string.Empty;
      string line = string.Empty;
      
      Regex rgx = new Regex("\\s+");
      string replacement = "";

      StreamReader reader = new StreamReader(Application.dataPath + "/StreamingAssets/100pam.txt");
      int row = 0;
      do {
        string line = reader.ReadLine();
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

    public void startPairwise() {
      //createMatrix
      //cell_origin , Direction[][]
      //initializeMatrix()
      //needlemanWunsch
      //getAlignment
    }

    public void startMSA() {
      
      //get keys.
      //while ( keys.Length > 1) {
        // ~ basically pairwise ~ //
        //for
          //for
            //createMatrix
            //cell_origin, Direction[][]
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





    public void registerDNAModel() {
      if (dna == null) {
        dna = DNAModel.Instance;
      }
    }

    public void registerRNAModel() {
      if (rna == null) {
        rna = RNAModel.Instance;
      }
    }

    public void registerProteinModel() {
      if (protein == null) {
        protein = ProteinModel.Instance;
      }
    }



  }
}