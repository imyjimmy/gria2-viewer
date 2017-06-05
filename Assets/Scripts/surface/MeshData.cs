using UnityEngine;
using System.Collections.Generic;
using VRModel;

public class MeshData {
	public int[] triangles;
	public Vector3[] vertices;
	public Vector3[] normals;
	public Color32[] colors;

	public List<Residue> residueSeq = new List<Residue>();
}