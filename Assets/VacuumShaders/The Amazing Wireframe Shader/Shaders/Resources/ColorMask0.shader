Shader "Hidden/VacuumShaders/The Amazing Wireframe/ColorMask0"
{
	SubShader 
	{
	   
		//PassName "BASE" 
		Pass  
		{
			Name "BASE"  

			ZWrite On
			ColorMask 0


			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag  

			 

			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_ColorMask0.cginc"   

			ENDCG   
		} //Pass

	} //SubShader

} //Shader
