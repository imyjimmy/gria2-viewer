//@imyjimmy
namespace VRModel {
	using System.Collections;
	using System.Collections.Generic;
	using UnityEngine;
	/*=========================================================================================
	* NOTICE: This class is VERY IMPORTANT to protein visualization in the current iteration.|
	* BUT it is by no means good programming practice. It is hacky by every standard.        |
	* this has to do with building gria2-viewer off 2014 UnityMol.                           |
	* =========================================================================================
	* How it works: 
	* - a List<Residue> represents the entire protein structure and is eventually passed into Splitting.cs
	* - each Residue object lists the start and end indices of triangle, color, vertex numbers 
	*   in the mesh which represents that particular residue.
	* - When user hovers hand over a position in RNA Plane, the coordinate is eventually passed to SequenceModel,
	*   eventually we figure out what residue it is.
	* - that particular Residue then gets highlighted because we have access to List<int> vertices for that residue,
	*   meaning we know exactly where it is.
	* This is why I said it's hacky.
	*/
	public class Residue {
		public string name { get; set; }

		public List<int> triangles { get; set; }
		public List<Color32> colors { get; set; }
		public List<int> vertices { get; set; }
		public List<int> normals { get; set; }

		//if Splitting.cs separates the protein into more than 1 mesh, 
		//the mesh number list refers to the mesh numbers in which the residue is represented.
		//colors, verts, normals and triangle indices are all reset with respect to the current mesh.
		//(I think)
		public List<int> meshIndices { get; set; }
	}
}
