// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "VacuumShaders/The Amazing Wireframe/Projector"
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
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			
			#pragma target 3.0


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

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float4 uvShadow : TEXCOORD0;
				float4 uvFalloff : TEXCOORD1;

				fixed3 mass : TEXCOORD2;	
				float distanceFade : TEXCOORD3;

				UNITY_FOG_COORDS(4)				
			};
			
			
			v2f vert (vInput v)
			{
				v2f o;


//Curved World Compatibility
//V_CW_TransformPoint(v.vertex);

				
				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.uvShadow = mul (unity_Projector, v.vertex);
				o.uvFalloff = mul (unity_ProjectorClip, v.vertex);

				UNITY_TRANSFER_FOG(o,o.pos);

				o.mass = fixed3(floor(v.texcoord.z),  frac(v.texcoord.z) * 10, v.texcoord.w);


				//Distance Fade
				float fixedSize = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex).xyz);
				float distanceFade = (_V_WIRE_DistanceFadeEnd - fixedSize) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);

				o.distanceFade = lerp(1, saturate(distanceFade), _V_WIRE_DistanceFade);

				return o;
			}
			
			
			
			fixed4 frag (v2f i) : SV_Target
			{				
				fixed4 projT = tex2Dproj (_ShadowTex, UNITY_PROJ_COORD(i.uvShadow));
				projT.a *= tex2Dproj (_FalloffTex, UNITY_PROJ_COORD(i.uvFalloff)).a;
									

				half value = ExtructWireframeFromMass(i.mass, 1);


				half4 res = projT * _V_WIRE_Color;
				res.rgb *= _V_WIRE_EmissionStrength;
				res.a = lerp(projT.a * _V_WIRE_Color.a, 0, value);


				//Distance Fade
				res.a *= i.distanceFade;

			
				UNITY_APPLY_FOG(i.fogCoord, res);			


				return res;
			}
			ENDCG
		} 
	}
}
