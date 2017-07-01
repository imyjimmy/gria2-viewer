Shader "Hidden/VacuumShaders/The Amazing Wireframe/Tessellation/ColorMask0"
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
			// compile directives
			#pragma vertex tessvert_surf
			#pragma hull hs_surf
			#pragma domain ds_surf
			#pragma fragment frag_surf
			#pragma target 5.0 
			#include "UnityCG.cginc"
			#include "Lighting.cginc"


			struct v2f_surf 
			{
				float4 pos : SV_POSITION;
			};

			// vertex shader
			v2f_surf vert_surf(appdata_full v) 
			{
				v2f_surf o;
				UNITY_INITIALIZE_OUTPUT(v2f_surf,o);

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}


#pragma shader_feature _ V_WIRE_TESSELLATION_DISTANCE_BASED V_WIRE_TESSELLATION_EDGE_LENGTH
#pragma shader_feature _ V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Tessellation.cginc"


			// fragment shader
			fixed4 frag_surf() : SV_Target
			{		
				return 0;
			}

			ENDCG
		}

	} //SubShader

} //Shader
