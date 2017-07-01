Shader "Hidden/VacuumShaders/The Amazing Wireframe/Tessellation/Shadow/Opaque"
{
		Properties
	{
		//Tag         
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0

		//Rendering Options
		[V_WIRE_RenderingOptions] _V_WIRE_RenderingOptions_PBREnumID("", float) = 0
		 
		[MaterialEnum(Off,0,Front,1,Back,2)] _Cull("Cull", Int) = 2 
		 
		//Tessellation Options 
		[V_WIRE_Title] _V_WIRE_Title_T_Options("Tessellation Options", float) = 0
		[V_WIRE_Tessellation] _V_WIRE_TessellationEnumID("", Float) = 0
		[HideInInspector] _V_WIRE_Tessellation("", Range(1, 32)) = 4
		[HideInInspector] _V_WIRE_Tessellation_MinDistance("", float) = 10
		[HideInInspector] _V_WIRE_Tessellation_MaxDistance("", float) = 35
		[HideInInspector] _V_WIRE_Tessellation_EdgeLength("", Range(2, 64)) = 16
		[HideInInspector] _V_WIRE_Tessellation_DispTex("", 2D) = "black" {}
		[HideInInspector] _V_WIRE_Tessellation_DispTex_Scroll("", vector) = (0, 0, 0, 0)
	    [HideInInspector] _V_WIRE_Tessellation_DispStrength("", float) = 0
		[Toggle(V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT)] _V_WIRE_NormalReconstruct("Reconstruct Normal", Float) = 0

		//Visual Options 
		[V_WIRE_Title] _V_WIRE_Title_V_Options("Default Visual Options", float) = 0

		//Base
		_Color("Color (RGB)", color) = (1, 1, 1, 1)
		_MainTex("Base (RGB)", 2D) = "white"{}
		[V_WIRE_UVScroll] _V_WIRE_MainTex_Scroll("    ", vector) = (0, 0, 0, 0)

		//Bump
		[V_WIRE_BumpPBR]  _V_WIRE_BumpEnumID("", Float) = 0
		[HideInInspector] _V_WIRE_NormalMap("", 2D) = "bump" {}

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0


		//Vertex Color
		[V_WIRE_Toggle] _V_WIRE_VertexColor("Vertex Color", float) = 0


		//Wire S Options  
		[V_WIRE_Title] _V_WIRE_Title_S_Options("Wire Source Options", float) = 0  		
		 
		//Source
		[V_WIRE_Source] _V_WIRE_Source_Options ("", float) = 0
		[HideInInspector] _V_WIRE_SourceTex("", 2D) = "white"{}
		[HideInInspector] _V_WIRE_SourceTex_Scroll("", vector) = (0, 0, 0, 0)
			   
		[HideInInspector] _V_WIRE_FixedSize("", float) = 0
		[HideInInspector] _V_WIRE_Size("", Float) = 1
			 
		//Wire Options  
		[V_WIRE_Title] _V_WIRE_Title_W_Options("Wire Visual Options", float) = 0  	

		_V_WIRE_Color("Color", color) = (0, 0, 0, 1)
		_V_WIRE_WireTex("Color Texture (RGBA)", 2D) = "white"{}
		[V_WIRE_UVScroll] _V_WIRE_WireTex_Scroll("    ", vector) = (0, 0, 0, 0)
		[Enum(UV0,0,UV1,1)] _V_WIRE_WireTex_UVSet("    UV Set", float) = 0

		//Emission
		[V_WIRE_PositiveFloat]_V_WIRE_EmissionStrength("Emission Strength", float) = 0

		//Vertex Color 
		[V_WIRE_Toggle] _V_WIRE_WireVertexColor("Vertex Color", Float) = 0

		//Light
		[V_WIRE_IncludeLight] _V_WIRE_IncludeLightEnumID ("", float) = 0

		//Transparency          
		[V_WIRE_Title]		  _V_WIRE_Transparency_M_Options("Wire Transparency Options", float) = 0
		[V_WIRE_Transparency] _V_WIRE_TransparencyEnumID("", float) = 0
		[HideInInspector]	  _V_WIRE_TransparentTex_Invert("    ", float) = 0
		[HideInInspector]	  _V_WIRE_TransparentTex_Alpha_Offset("    ", Range(-1, 1)) = 0

		//Fresnel
		[V_WIRE_Fresnel]  _V_WIRE_FresnelEnumID("Fresnel", Float) = 0
		[HideInInspector] _V_WIRE_FresnelInvert("", float) = 0
		[HideInInspector] _V_WIRE_FresnelBias("", Range(-1, 1)) = 0
		[HideInInspector] _V_WIRE_FresnelPow("", Range(1, 16)) = 1

		//Distance Fade  
		[V_WIRE_DistanceFade]  _V_WIRE_DistanceFade("Distance Fade", Float) = 0
		[HideInInspector] _V_WIRE_DistanceFadeStart("", Float) = 5
		[HideInInspector] _V_WIRE_DistanceFadeEnd("", Float) = 10

		//Dynamic Mask
		[V_WIRE_Title]		 _V_WIRE_Title_M_Options("Dynamic Mask Options", float) = 0
		[V_WIRE_DynamicMask] _V_WIRE_DynamicMaskEnumID("", float) = 0
		[HideInInspector]    _V_WIRE_DynamicMaskInvert("", float) = -1
		[HideInInspector]    _V_WIRE_DynamicMaskEffectsBaseTexEnumID("", int) = 0
		[HideInInspector]    _V_WIRE_DynamicMaskEffectsBaseTexInvert("", float) = 0	
		[HideInInspector]    _V_WIRE_DynamicMaskType("", Float) = 1
		[HideInInspector]    _V_WIRE_DynamicMaskSmooth("", Range(0, 1)) = 1
	}


		SubShader  
		{		
			Tags{ "RenderType" = "Opaque" }
			
			// Pass to render object as a shadow caster
			Pass 
			{
				Name "ShadowCaster" 
				Tags{ "LightMode" = "ShadowCaster" }
				ZWrite On ZTest LEqual
		 
				CGPROGRAM
				#pragma vertex tessvert_surf
				#pragma hull hs_surf
				#pragma domain ds_surf
				#pragma geometry geom
				#pragma fragment frag
				#pragma target 5.0 

				#pragma multi_compile_shadowcaster 
				#include "UnityCG.cginc" 
				#include "Lighting.cginc"
			  
				
				#define V_WIRE_SHADOWCASTER 

				#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Shadow.cginc" 			
				#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS.cginc"

				#pragma shader_feature _ V_WIRE_TESSELLATION_DISTANCE_BASED V_WIRE_TESSELLATION_EDGE_LENGTH
				#pragma shader_feature _ V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT
				#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Tessellation.cginc"


				ENDCG 
			}
		}
}
 