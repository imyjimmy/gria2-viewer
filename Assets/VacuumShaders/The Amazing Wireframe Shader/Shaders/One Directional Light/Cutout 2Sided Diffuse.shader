// VacuumShaders 2015
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/One Directional Light/Cutout/2 Sided/Diffuse"
{
	Properties     
	{                     
		//Tag            
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0  
		
		//Rendering Options
		[V_WIRE_RenderingOptions] _V_WIRE_RenderingOptions_ODLEnumID("", float) = 0
		 
		 		 		
		//Visual Options	 
		[V_WIRE_Title] _V_WIRE_Title_V_Options("Default Visual Options", float) = 0  
		
		//Base 
		_Color("Color (RGB) Trans (A)", color) = (1, 1, 1, 1)

		//Vertex Color
		[V_WIRE_Toggle] _V_WIRE_VertexColor("Vertex Color", float) = 0

		_MainTex("Base (RGB) Trans(A)", 2D) = "white"{}			
		[V_WIRE_UVScroll] _V_WIRE_MainTex_Scroll("    ", vector) = (0, 0, 0, 0)
		
		_Cutoff("    Alpha cutoff", range(0, 1)) = 0.5

		//Bump
	    [V_WIRE_BumpODL]  _V_WIRE_BumpEnumID ("", Float) = 0	
		[HideInInspector] _V_WIRE_NormalMap ("", 2D) = "bump" {}

		//Specular
	    [V_WIRE_Specular] _V_WIRE_SpecularEnumID ("", Float) = 0
		[HideInInspector] _V_WIRE_Specular_Lookup("", 2D) = "black"{}

		//Reflection
		[V_WIRE_Reflection] _V_WIRE_ReflectionEnumID("", float) = 0
		[HideInInspector]   _Cube("", Cube) = ""{}  
		[HideInInspector]   _ReflectColor("", Color) = (0.5, 0.5, 0.5, 1)
		[HideInInspector]   _V_WIRE_Reflection_Strength("", Range(0, 1)) = 0.5
		[HideInInspector]   _V_WIRE_Reflection_Fresnel_Bias("", Range(-1, 1)) = -1
		[HideInInspector]   _V_WIRE_Reflection_Roughness("", Range(0, 1)) = 0.3

	
			

		     
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


	SubShader 
	{
		Tags { "Queue"="AlphaTest" 
		       "IgnoreProjector"="True" 
			   "RenderType"="Wireframe_Full_TransparentCutout" 
			 }  
		LOD 200		
		
		//PassName "FORWARD" 
		Pass
	    { 			
			Name "FORWARD" 
			Tags { "LightMode" = "ForwardBase" } 
			  
			ZWrite Off
			Cull Front


			CGPROGRAM            
			#pragma vertex vert   
	    	#pragma fragment frag  		  
			#pragma multi_compile_fwdbase nodirlightmap nodynlightmap
			#pragma target 3.0
			       
			#pragma multi_compile_fog   
			

			#pragma shader_feature V_WIRE_REFLECTION_OFF V_WIRE_REFLECTION_CUBE_SIMPLE V_WIRE_REFLECTION_CUBE_ADVANED V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES
			
			
			#pragma shader_feature V_WIRE_SOURCE_BAKED V_WIRE_SOURCE_TEXTURE

			#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON

			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
		    #pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 

			 
			#define V_WIRE_HAS_TEXTURE
			#define V_WIRE_CUTOUT

			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_ForwardBase.cginc"
			ENDCG   			 
		} //Pass   
		
		
		Pass
	    { 
			Name "FORWARD" 
			Tags { "LightMode" = "ForwardBase" } 

			ZWrite On
			Cull Back

			  
			CGPROGRAM            
			#pragma vertex vert   
	    	#pragma fragment frag  		  
			#pragma multi_compile_fwdbase nodirlightmap nodynlightmap
			#pragma target 3.0
			       
			#pragma multi_compile_fog   
			

			#pragma shader_feature V_WIRE_REFLECTION_OFF V_WIRE_REFLECTION_CUBE_SIMPLE V_WIRE_REFLECTION_CUBE_ADVANED V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES
			
			
			#pragma shader_feature V_WIRE_SOURCE_BAKED V_WIRE_SOURCE_TEXTURE

			#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON

			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
		    #pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 

			 
			#define V_WIRE_HAS_TEXTURE
			#define V_WIRE_CUTOUT

			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_ForwardBase.cginc"
			ENDCG   			 
		} //Pass   	

	} //SubShader

	FallBack "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/Vertex Lit/Cutout/Full"
} //Shader
