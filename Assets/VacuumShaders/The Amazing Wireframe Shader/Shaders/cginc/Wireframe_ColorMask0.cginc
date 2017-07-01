#ifndef VACUUM_WIREFRAME_COLORMASK0_CGINC
#define VACUUM_WIREFRAME_COLORMASK0_CGINC


//Curved World Compatibility
//#include "Assets/VacuumShaders/Curved World/Shaders/cginc/CurvedWorld_Base.cginc"
 

struct v2f   
{  
	float4 pos : SV_POSITION;	
};
	 
v2f vert(float4 v : POSITION)   
{
	v2f o;
	UNITY_INITIALIZE_OUTPUT(v2f,o); 
	
//V_CW_TransformPoint(v);

	o.pos = mul(UNITY_MATRIX_MVP, v);

	return o;
}

fixed4 frag () : SV_Target 
{
	return 0;
}

	
#endif
