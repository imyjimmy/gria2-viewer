/// @file ScenePreload_1KX2.cs
/// @brief Details to be specified
/// @author FvNano/LBT team
/// @author Marc Baaden <baaden@smplinux.de>
/// @date   2013-4
///
/// Copyright Centre National de la Recherche Scientifique (CNRS)
///
/// contributors :
/// FvNano/LBT team, 2010-13
/// Marc Baaden, 2010-13
///
/// baaden@smplinux.de
/// http://www.baaden.ibpc.fr
///
/// This software is a computer program based on the Unity3D game engine.
/// It is part of UnityMol, a general framework whose purpose is to provide
/// a prototype for developing molecular graphics and scientific
/// visualisation applications. More details about UnityMol are provided at
/// the following URL: "http://unitymol.sourceforge.net". Parts of this
/// source code are heavily inspired from the advice provided on the Unity3D
/// forums and the Internet.
///
/// This software is governed by the CeCILL-C license under French law and
/// abiding by the rules of distribution of free software. You can use,
/// modify and/or redistribute the software under the terms of the CeCILL-C
/// license as circulated by CEA, CNRS and INRIA at the following URL:
/// "http://www.cecill.info".
/// 
/// As a counterpart to the access to the source code and rights to copy, 
/// modify and redistribute granted by the license, users are provided only 
/// with a limited warranty and the software's author, the holder of the 
/// economic rights, and the successive licensors have only limited 
/// liability.
///
/// In this respect, the user's attention is drawn to the risks associated 
/// with loading, using, modifying and/or developing or reproducing the 
/// software by the user in light of its specific status of free software, 
/// that may mean that it is complicated to manipulate, and that also 
/// therefore means that it is reserved for developers and experienced 
/// professionals having in-depth computer knowledge. Users are therefore 
/// encouraged to load and test the software's suitability as regards their 
/// requirements in conditions enabling the security of their systems and/or 
/// data to be ensured and, more generally, to use and operate it in the 
/// same conditions as regards security.
///
/// The fact that you are presently reading this means that you have had 
/// knowledge of the CeCILL-C license and that you accept its terms.
///
/// $Id: ScenePreload_1KX2.cs 368 2013-08-29 13:10:00Z erwan $
///
/// References : 
/// If you use this code, please cite the following reference : 	
/// Z. Lv, A. Tek, F. Da Silva, C. Empereur-mot, M. Chavent and M. Baaden:
/// "Game on, Science - how video game technology may help biologists tackle
/// visualization challenges" (2013), PLoS ONE 8(3):e57990.
/// doi:10.1371/journal.pone.0057990
///
/// If you use the HyperBalls visualization metaphor, please also cite the
/// following reference : M. Chavent, A. Vanel, A. Tek, B. Levy, S. Robert,
/// B. Raffin and M. Baaden: "GPU-accelerated atom and dynamic bond visualization
/// using HyperBalls, a unified algorithm for balls, sticks and hyperboloids",
/// J. Comput. Chem., 2011, 32, 2924
///

using UnityEngine;
using System.Collections;
using UI;
using ParseData.ParsePDB;

public class ScenePreload_5L1B : MonoBehaviour {
	private float pdb_progress = 0;
	private string progresses;
	
	private GameObject LoadBox;	//@imyjimmy

	// Use this for initialization
	void Start () 
	{

	}
	
	// Update is called once per frame
	void Update () {
	
	}

	IEnumerator InitScene(RequestPDB requestPDB)
	{
		//http://www.shaman.ibpc.fr/umolweb/Scenes/1KX2/1KX2.pdb
		// StartCoroutine(requestPDB.LoadPDBWWW("http://www.shaman.ibpc.fr/umolweb/Scenes/1KX2/1KX2.pdb"));
		// StartCoroutine(requestPDB.LoadPDBWWW("http://imyjimmy.com/pdb-files/5l1b.pdb"));  //5l1b //1l2y
		StartCoroutine(requestPDB.LoadPDBWWW("http://imyjimmy.com/pdb-files/1l2y.pdb"));  //5l1b //1l2y

		while(!RequestPDB.isDone) {
			pdb_progress = requestPDB.progress;
			Debug.Log(pdb_progress);
			yield return new WaitForEndOfFrame();
		}
		pdb_progress = 1.0f;
		
		//requestPDB.LoadPDBResource("1KX2");
		// UIData.atomtype = UIData.AtomType.hyperball;
		// UIData.bondtype = UIData.BondType.hyperstick;
		UIData.atomtype = UIData.AtomType.noatom;
		UIData.bondtype = UIData.BondType.nobond;
		UIData.secondarystruct = true;

		//trying it out
		Ribbons ribbons = new Ribbons();
		ribbons.CreateRibbons();
		// toggle_NA_HIDE = !toggle_NA_HIDE; //GUIMoleculeController.toggle_NA_HIDE

		LoadBox = GameObject.Find("LoadBox");
		GameObject[] objs = GameObject.FindGameObjectsWithTag("RibbonObj");

		GUIMoleculeController.showOpenMenu = false;
		GUIMoleculeController.showAtomMenu = false;
		GUIMoleculeController.globalRadius = 0.3f;
		GUIMoleculeController.shrink = 0.00001f;//100.00f; //0.000001f;
		GUIMoleculeController.linkScale = 0.4f;

		foreach(GameObject o in objs) {
			o.transform.parent = LoadBox.transform;
			o.transform.localScale = LoadBox.transform.localScale;
			o.transform.localPosition = LoadBox.transform.localPosition;
		}

		SendMessage("Display",SendMessageOptions.DontRequireReceiver);	
	}
	
	void OnGUI()
	{
		if(pdb_progress >= 1.0f)
			return;
		progresses = "PDB loading: " + Mathf.CeilToInt(pdb_progress*100) + "%\n";
		//GUI.enabled = false;
		progresses = GUI.TextArea(new Rect(Screen.width/2 - 100, Screen.height/2 - 50, 200,100), progresses);
		//GUI.enabled = true;
	}
}
