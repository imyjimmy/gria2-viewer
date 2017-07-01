// VacuumShaders 2015
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/Unlit/Transparent/ZWrite/Full Improved"
{
    Properties 
    {
		//Tag         
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0 
		 
		//Rendering Options
		[V_WIRE_RenderingOptions] _V_WIRE_RenderingOptions_UnlitEnumID("", float) = 0

		[MaterialEnum(Off,0,Front,1,Back,2)] _Cull ("Cull", Int) = 2

		//Visual Options
		[V_WIRE_Title] _V_WIRE_Title_V_Options("Default Visual Options", float) = 0  
		
		//Base 
		_Color("Color (RGB) Trans (A)", color) = (1, 1, 1, 1)

		//Vertex Color
		[V_WIRE_Toggle] _V_WIRE_VertexColor("Vertex Color", float) = 0

		_MainTex("Base (RGB) Trans (A)", 2D) = "white"{}			
		[V_WIRE_UVScroll] _V_WIRE_MainTex_Scroll("    ", vector) = (0, 0, 0, 0)
		 		   
		//IBL
		[V_WIRE_IBL]      _V_WIRE_IBLEnumID("", float) = 0
		[HideInInspector] _V_WIRE_IBL_Cube_Intensity("", float) = 1
		[HideInInspector] _V_WIRE_IBL_Cube_Contrast("", float) = 1 
		[HideInInspector] _V_WIRE_IBL_Cube("", cube) = ""{}
		[HideInInspector] _V_WIRE_IBL_Light_Strength("", Range(-1, 1)) = 0	 
		[HideInInspector] _V_WIRE_IBL_Roughness("", Range(-1, 1)) = 0	   
		
		//Reflection
		[V_WIRE_Reflection] _V_WIRE_ReflectionEnumID("", float) = 0
		[HideInInspector]	_Cube("", Cube) = ""{}  
		[HideInInspector]	_ReflectColor("", Color) = (0.5, 0.5, 0.5, 1)
		[HideInInspector]	_V_WIRE_Reflection_Strength("", Range(0, 1)) = 0.5
		[HideInInspector]	_V_WIRE_Reflection_Fresnel_Bias("", Range(-1, 1)) = -1
		[HideInInspector]	_V_WIRE_Reflection_Roughness("", Range(0, 1)) = 0.3
		
	     
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

		//Improved Transparent Blend
		[V_WIRE_ImprovedBlend] _V_WIRE_ImprovedBlendEnumID ("", int) = 0

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
		Tags { "Queue"="Transparent+1" 
		       "IgnoreProjector"="True" 
			   "RenderType"="Transparent" 
			 }
		Cull [_Cull]
		
		Blend SrcAlpha OneMinusSrcAlpha 
		 

		UsePass "Hidden/VacuumShaders/The Amazing Wireframe/ColorMask0/BASE"


		Pass 
	    {			

            CGPROGRAM
		    #pragma vertex vert
	    	#pragma fragment frag
			#pragma target 3.0


			#pragma multi_compile_fog

			#pragma shader_feature V_WIRE_IBL_OFF V_WIRE_IBL_ON 
			#pragma shader_feature V_WIRE_REFLECTION_OFF V_WIRE_REFLECTION_CUBE_SIMPLE V_WIRE_REFLECTION_CUBE_ADVANED V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES
			

			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
			#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 


			#define V_WIRE_NO
			#define V_WIRE_HAS_TEXTURE
			#define V_WIRE_TRANSPARENT 
			
			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Unlit.cginc"
	    	ENDCG

    	} //Pass

		Pass 
	    {			

            CGPROGRAM
		    #pragma vertex vert
	    	#pragma fragment frag
			#pragma target 3.0

			#pragma multi_compile_fog

			#pragma shader_feature V_WIRE_SOURCE_BAKED V_WIRE_SOURCE_TEXTURE

			#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON
			#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON

			#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 


			#define V_WIRE_TRANSPARENT
			#define V_WIRE_NO_COLOR_BLACK
			#define V_WIRE_SAME_COLOR
			
			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Unlit.cginc"

	    	ENDCG

    	} //Pass
        
    } //SubShader

} //Shader
