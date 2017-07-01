Shader "VacuumShaders/The Amazing Wireframe/Standard"
{
	Properties
	{
		//Tag         
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0

		 
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		
		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
		_GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
		[Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

		[Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
		_MetallicGlossMap("Metallic", 2D) = "white" {}

		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0

		_BumpScale("Scale", Float) = 1.0
		_BumpMap("Normal Map", 2D) = "bump" {}

		_Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
		_ParallaxMap ("Height Map", 2D) = "black" {}

		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
		_OcclusionMap("Occlusion", 2D) = "white" {}

		_EmissionColor("Color", Color) = (0,0,0)
		_EmissionMap("Emission", 2D) = "white" {}
		
		_DetailMask("Detail Mask", 2D) = "white" {}

		_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
		_DetailNormalMapScale("Scale", Float) = 1.0
		_DetailNormalMap("Normal Map", 2D) = "bump" {}

		[Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0


		// Blending state
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0



//Wireframe//////////////////////////////////////////////////////////////////
		
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
		[HideInInspector]      _V_WIRE_EmissionStrength("Emission Strength", float) = 0
		[V_WIRE_DynamicGI]	   _V_WIRE_DynamicGIEnumID ("", Float) = 0 
		[HideInInspector]      _V_WIRE_DynamicGI("", Float) = 0
		[HideInInspector]      _V_WIRE_DynamicGIStrength("", Float) = 0
		[HideInInspector]      _V_WIRE_ObjectWorldPos("", vector) = (0, 0, 0, 0)

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
	    [V_WIRE_Fresnel]  _V_WIRE_FresnelEnumID ("Fresnel", Float) = 0	
		[HideInInspector] _V_WIRE_FresnelInvert("", float) = 0
		[HideInInspector] _V_WIRE_FresnelBias("", Range(-1, 1)) = 0
		[HideInInspector] _V_WIRE_FresnelPow("", Range(1, 16)) = 1
		 
		//Distance Fade  
	    [V_WIRE_DistanceFade]  _V_WIRE_DistanceFade ("Distance Fade", Float) = 0
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

	CGINCLUDE
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup
	ENDCG

	SubShader
	{
		Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
		LOD 300
	

		// ------------------------------------------------------------------
		//  Base forward pass (directional light, emission, lightmaps, ...)
		Pass
		{
			Name "FORWARD" 
			Tags { "LightMode" = "ForwardBase" }

			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]

			CGPROGRAM
			#pragma target 3.0
		 
			// -------------------------------------

			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
		    #pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			//NOT SUPPORED BY WIREFRAME SHADER #pragma shader_feature _PARALLAXMAP

			//Wireframe
			#define V_WIRE_PBR
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON	
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog

			#pragma vertex vertBase
			#pragma fragment fragBase
			#include "UnityStandardCoreForward.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Additive forward pass (one light per pass)
		Pass
		{
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Fog { Color (0,0,0,0) } // in additive pass fog should be black
			ZWrite Off
			ZTest LEqual

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------


			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2
			//NOT SUPPORED BY WIREFRAME SHADER #pragma shader_feature _PARALLAXMAP

			//Wireframe
			#define V_WIRE_PBR
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON	
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog

			#pragma vertex vertAdd
			#pragma fragment fragAdd
			#include "UnityStandardCoreForward.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Shadow rendering pass
		Pass {
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On ZTest LEqual

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------


			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma multi_compile_shadowcaster

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "UnityStandardShadow.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Deferred pass
		Pass
		{
			Name "DEFERRED"
			Tags { "LightMode" = "Deferred" }

			CGPROGRAM
			#pragma target 3.0
			#pragma exclude_renderers nomrt


			// -------------------------------------

			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2
			//NOT SUPPORED BY WIREFRAME SHADER #pragma shader_feature _PARALLAXMAP

			#pragma multi_compile ___ UNITY_HDR_ON
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
			#pragma multi_compile ___ DIRLIGHTMAP_COMBINED DIRLIGHTMAP_SEPARATE
			#pragma multi_compile DYNAMICLIGHTMAP_OFF DYNAMICLIGHTMAP_ON
			  
			//Wireframe  
			#define V_WIRE_PBR
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON	
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 

			#pragma vertex vertDeferred
			#pragma fragment fragDeferred

			#include "UnityStandardCore.cginc"

			ENDCG
		}  


		// ------------------------------------------------------------------
		// Extracts information for lightmapping, GI (emission, albedo, ...)
		// This pass it not used during regular rendering.
		Pass 
		{
			Name "META"   
			Tags { "LightMode"="Meta" }   
			  
			Cull Off 
			   
			CGPROGRAM  
			#pragma vertex vert_meta
			#pragma fragment frag_meta 
			#pragma target 3.0   
			    
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP    
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A 
			#pragma shader_feature ___ _DETAIL_MULX2	 
			    
			//Wireframe      
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON

			#define V_WIRE_PBR       
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON	 
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE  
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 

			#include "UnityStandardMeta.cginc"
			ENDCG
		} 
	}


	FallBack "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/Vertex Lit"
	CustomEditor "WireframeStandardShaderGUI"
}
