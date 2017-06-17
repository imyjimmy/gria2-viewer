//@imyjimmy
namespace VRModel {
	using System.Collections;
	using System.Collections.Generic;

	public class Residue {
		public string name { get; set; }
		public List<int> colors { get; set; }
		public List<int> vertices { get; set; }
		public List<int> normals { get; set; }
		public List<int> triangles { get; set; }

		//if Splitting.cs separates the protein into more than 1 mesh, 
		//the mesh number refers to the mesh index in which the residue is represented.
		//colors, verts, normals and triangle indices are all reset with respect to the current mesh.
		//(I think)
		public List<int> meshNumber { get; set; }
	}
}