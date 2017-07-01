// VacuumShaders 2015
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/One Directional Light/Transparent/2 Sided/Wire Only"
{
	Properties     
	{                   
		//Tag            
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0  
		
		//Rendering Options
		[V_WIRE_RenderingOptions] _V_WIRE_RenderingOptions_ODLEnumID("", float) = 0
		 

		//Base
		[HideInInspector] _Color("", color) = (1, 1, 1, 1)
		[HideInInspector] _MainTex("", 2D) = "white"{}		
		  		 				 				 	

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


	SubShader 
	{
		Tags { "Queue"="Transparent" 
		       "IgnoreProjector"="True" 
			   "RenderType"="Transparent"
			 }
		LOD 200		
		
		Blend SrcAlpha OneMinusSrcAlpha 		      


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
			

			#pragma shader_feature V_WIRE_SOURCE_BAKED V_WIRE_SOURCE_TEXTURE

			#ifdef UNITY_PASS_DEFERRED
				#define V_WIRE_LIGHT_ON
			#else
				#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
			#endif
			

			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON

			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
		   
			 
			#define V_WIRE_TRANSPARENT
			#define V_WIRE_NO_COLOR_BLACK
			#define V_WIRE_SAME_COLOR

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
			

			#pragma shader_feature V_WIRE_SOURCE_BAKED V_WIRE_SOURCE_TEXTURE

			#ifdef UNITY_PASS_DEFERRED
				#define V_WIRE_LIGHT_ON
			#else
				#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
			#endif
			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON

			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
		   
			 
			#define V_WIRE_TRANSPARENT
			#define V_WIRE_NO_COLOR_BLACK
			#define V_WIRE_SAME_COLOR

			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_ForwardBase.cginc"
			ENDCG   			 
		} //Pass   	
			 
	} //SubShader

	FallBack "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/Vertex Lit/Transparent/Wire Only"
} //Shader
