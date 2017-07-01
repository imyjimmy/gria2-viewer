// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "Hidden/VacuumShaders/The Amazing Wireframe/Geometry Shader/Projector"
{
	Properties 
	{
		//Tag   
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0 

		[HideInInspector] _Color("Color (RGB)", color) = (1, 1, 1, 1)
		[HideInInspector] _MainTex("Base (RGB)", 2D) = "white"{}		

		//Visual Options
		[V_WIRE_Title] _V_WIRE_Title_V_Options("Default Visual Options", float) = 0  

		[NoScaleOffset] _ShadowTex ("Color (RGB) Mask (A)", 2D) = "white" {}
		[NoScaleOffset] _FalloffTex ("FallOff (A)", 2D) = "" {}


		//Wire S Options  
		[V_WIRE_Title]  _V_WIRE_Title_S_Options("Wire Source Options", float) = 0
		[V_WIRE_SourceProjector] _V_WIRE_Source_Options ("", float) = 0
		_V_WIRE_Size("Size ", Float) = 1
		[V_WIRE_Toggle] _V_WIRE_FixedSize("   Reduce By Distance", float) = 0
		[Toggle(V_WIRE_TRY_QUAD_ON)] _V_WIRE_TryQuad("Try Quad", Float) = 0
			
		//Wire Options
		[V_WIRE_Title] _V_WIRE_Title_W_Options("Wire Visual Options", float) = 0  
		_V_WIRE_Color("Color", color) = (0, 0, 0, 1)
		[V_WIRE_PositiveFloat] _V_WIRE_EmissionStrength("Emission Strength", float) = 1

		//Transparency          
		[V_WIRE_Title]		  _V_WIRE_Transparency_M_Options("Wire Transparency Options", float) = 0
		[V_WIRE_DistanceFade]  _V_WIRE_DistanceFade ("Distance Fade", Float) = 0
		[HideInInspector] _V_WIRE_DistanceFadeStart("", Float) = 5
		[HideInInspector] _V_WIRE_DistanceFadeEnd("", Float) = 10
	}
	
	Subshader 
	{
		Tags { "Queue"="Transparent" } 
		 
		Pass 
		{
			ZWrite Off
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha 
			Offset -1, -1
	
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			
			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS_Platform.cginc"


			sampler2D _ShadowTex;
			sampler2D _FalloffTex;
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
						
			
			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


			struct vInput
			{
				float4 vertex : POSITION;
				half4 texcoord : TEXCOORD0;				
			};

			struct v2f_surf
			{
				float4 pos : SV_POSITION;
				float4 uvShadow : TEXCOORD0;
				float4 uvFalloff : TEXCOORD1;

				fixed3 custompack2 : TEXCOORD2;
				float3 worldPos : TEXCOORD3;

				float3 objectPos : TEXCOORD4;

				UNITY_FOG_COORDS(5)				
			};


			#pragma shader_feature	V_WIRE_TRY_QUAD_OFF V_WIRE_TRY_QUAD_ON			

			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS.cginc"

			
			v2f_surf vert (vInput v)
			{
				v2f_surf o;


//Curved World Compatibility
//V_CW_TransformPoint(v.vertex);

				o.objectPos = v.vertex.xyz;
				
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uvShadow = mul (unity_Projector, v.vertex);
				o.uvFalloff = mul (unity_ProjectorClip, v.vertex);
				o.custompack2 = 0;

				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				UNITY_TRANSFER_FOG(o,o.pos);
				
				return o;
			}
			
			
			
			fixed4 frag (v2f_surf i) : SV_Target
			{				

				fixed4 projT = tex2Dproj (_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
				projT.a *= tex2Dproj (_FalloffTex, UNITY_PROJ_COORD(i.uvFalloff)).a;
								
				half value = ExtructWireframeFromMass(i.custompack2.xyz, 1);
				
				half4 res = projT * _V_WIRE_Color;
				res.rgb *= _V_WIRE_EmissionStrength;
				res.a = lerp(projT.a * _V_WIRE_Color.a, 0, value);


				//Distance Fade
				float fixedSize = distance(_WorldSpaceCameraPos, i.worldPos);
				float distanceFade = (_V_WIRE_DistanceFadeEnd - fixedSize) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);

				res.a *= lerp(1, saturate(distanceFade), _V_WIRE_DistanceFade);

			
				UNITY_APPLY_FOG(i.fogCoord, res);			


				return res;
			}
			ENDCG
		} 
	}
}
