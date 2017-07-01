// VacuumShaders 2015
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/The Amazing Wireframe/Tessellation/Opaque/Bumped"
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

		//Vertex Color
		[V_WIRE_Toggle] _V_WIRE_VertexColor("Vertex Color", float) = 0

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_MainTex("Base (RGB)", 2D) = "white"{}			 
		[V_WIRE_UVScroll] _V_WIRE_MainTex_Scroll("    ", vector) = (0, 0, 0, 0)

		//Bump 
	    [V_WIRE_BumpPBR]  _V_WIRE_BumpEnumID ("", Float) = 0	
		[HideInInspector] _V_WIRE_NormalScale ("", Float) = 1
		[HideInInspector] _V_WIRE_NormalMap ("", 2D) = "bump" {}
		  
		//AO    
		[V_WIRE_AoPBR]    _V_WIRE_Ao("", Float) = 0
		[HideInInspector] _V_WIRE_AoStrength("", Range(0, 1)) = 1
		[HideInInspector] _V_WIRE_AoMap("", 2D) = "white" {}

		 
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
		[V_WIRE_PositiveFloat] _V_WIRE_EmissionStrength("Emission Strength", float) = 0
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
		LOD 200
		Cull[_Cull]


		// ------------------------------------------------------------
		// Surface shader code generated out of a CGPROGRAM block:


		// ---- forward rendering base pass:
		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardBase" }

		CGPROGRAM
		// compile directives
#pragma vertex tessvert_surf
#pragma hull hs_surf
#pragma domain ds_surf
#pragma geometry geom
#pragma fragment frag_surf
#pragma target 5.0 
#pragma multi_compile_fog
#pragma multi_compile_fwdbase nolightmap nodynlightmap
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
		// Surface shader code generated based on:
		// vertex modifier: 'vert'
		// writes to per-pixel normal: YES
		// writes to emission: no
		// needs world space reflection vector: no
		// needs world space normal vector: no
		// needs screen space position: no
		// needs world space position: YES
		// needs view direction: no
		// needs world space view direction: no
		// needs world space position for lighting: YES
		// needs world space view direction for lighting: YES
		// needs world space view direction for lightmaps: no
		// needs vertex color: YES
		// needs VFACE: no
		// passes tangent-to-world matrix to pixel shader: YES
		// reads from normal: no
		// 0 texcoords actually used
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"


		#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
		#ifdef UNITY_PASS_DEFERRED
		#ifndef V_WIRE_LIGHT_ON
		#define V_WIRE_LIGHT_ON
		#endif
		#endif

		#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
		#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON

		#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE
		

#define V_WIRE_PBR
#define _NORMALMAP 

#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_PBR.cginc" 


		// vertex-to-fragment interpolation data
		// no lightmaps:
#ifdef LIGHTMAP_OFF
		struct v2f_surf {
		float4 pos : SV_POSITION;
		float4 tSpace0 : TEXCOORD0;
		float4 tSpace1 : TEXCOORD1;
		float4 tSpace2 : TEXCOORD2;
		fixed4 color : COLOR0;
		float4 custompack0 : TEXCOORD3; // texcoord
		float4 custompack1 : TEXCOORD4; // texcoord1
		half4 custompack2 : TEXCOORD5; // mass
#if UNITY_SHOULD_SAMPLE_SH
		half3 sh : TEXCOORD6; // SH
#endif
		SHADOW_COORDS(7)
#if SHADER_TARGET >= 30
			float4 lmap : TEXCOORD8;
#endif
		 
		float3 worldPos : TEXCOORD9;
	};
#endif 
	// with lightmaps:
#ifndef LIGHTMAP_OFF
	struct v2f_surf {
		float4 pos : SV_POSITION;
		float4 tSpace0 : TEXCOORD0;
		float4 tSpace1 : TEXCOORD1;
		float4 tSpace2 : TEXCOORD2;
		fixed4 color : COLOR0;
		float4 custompack0 : TEXCOORD3; // texcoord
		float4 custompack1 : TEXCOORD4; // texcoord1
		half4 custompack2 : TEXCOORD5; // mass
		float4 lmap : TEXCOORD6;
		SHADOW_COORDS(7)

		float3 worldPos : TEXCOORD8;
	};
#endif

#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS.cginc"


	// vertex shader
	v2f_surf vert_surf(appdata_full v) {
		v2f_surf o;
		UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
		Input customInputData;
		vert(v, customInputData);
		o.custompack0.xyzw = customInputData.texcoord;
		o.custompack1.xyzw = customInputData.texcoord1;
		o.custompack2.xyzw = customInputData.mass;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
		fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
		o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
		o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
		o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
		o.worldPos = worldPos;
		o.color = v.color;
#ifndef DYNAMICLIGHTMAP_OFF
		o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif
#ifndef LIGHTMAP_OFF
		o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif

		// SH/ambient and vertex lights
#ifdef LIGHTMAP_OFF
#if UNITY_SHOULD_SAMPLE_SH
		o.sh = 0;
		// Approximated illumination from non-important point lights
#ifdef VERTEXLIGHT_ON
		o.sh += Shade4PointLights(
			unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
			unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
			unity_4LightAtten0, worldPos, worldNormal);
#endif
		o.sh = ShadeSHPerVertex(worldNormal, o.sh);
#endif
#endif // LIGHTMAP_OFF

		TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
		return o;
	}


#pragma shader_feature _ V_WIRE_TESSELLATION_DISTANCE_BASED V_WIRE_TESSELLATION_EDGE_LENGTH
#pragma shader_feature _ V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Tessellation.cginc"


	// fragment shader
	fixed4 frag_surf(v2f_surf IN) : SV_Target{
		// prepare and unpack data
		Input surfIN;
	UNITY_INITIALIZE_OUTPUT(Input,surfIN);
	surfIN.texcoord.x = 1.0;
	surfIN.texcoord1.x = 1.0;
	surfIN.worldPos.x = 1.0;
	surfIN.mass.x = 1.0;
	surfIN.color.x = 1.0;
	surfIN.texcoord = IN.custompack0.xyzw;
	surfIN.texcoord1 = IN.custompack1.xyzw;
	surfIN.mass = IN.custompack2.xyzw;
	float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
#ifndef USING_DIRECTIONAL_LIGHT
	fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
#else
	fixed3 lightDir = _WorldSpaceLightPos0.xyz;
#endif
	fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
	surfIN.worldPos = worldPos;
	surfIN.color = IN.color;
#ifdef UNITY_COMPILER_HLSL
	SurfaceOutputStandard o = (SurfaceOutputStandard)0;
#else
	SurfaceOutputStandard o;
#endif
	o.Albedo = 0.0;
	o.Emission = 0.0;
	o.Alpha = 0.0;
	o.Occlusion = 1.0;
	fixed3 normalWorldVertex = fixed3(0,0,1);

	// call surface function
	surf(surfIN, o);

	// compute lighting & shadowing factor
	UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
		fixed4 c = 0;
	fixed3 worldN;
	worldN.x = dot(IN.tSpace0.xyz, o.Normal);
	worldN.y = dot(IN.tSpace1.xyz, o.Normal);
	worldN.z = dot(IN.tSpace2.xyz, o.Normal);
	o.Normal = worldN;

	// Setup lighting environment
	UnityGI gi;
	UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
	gi.indirect.diffuse = 0;
	gi.indirect.specular = 0;
#if !defined(LIGHTMAP_ON)
	gi.light.color = _LightColor0.rgb;
	gi.light.dir = lightDir;
	gi.light.ndotl = LambertTerm(o.Normal, gi.light.dir);
#endif
	// Call GI (lightmaps/SH/reflections) lighting function
	UnityGIInput giInput;
	UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
	giInput.light = gi.light;
	giInput.worldPos = worldPos;
	giInput.worldViewDir = worldViewDir;
	giInput.atten = atten;
#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
	giInput.lightmapUV = IN.lmap;
#else
	giInput.lightmapUV = 0.0;
#endif
#if UNITY_SHOULD_SAMPLE_SH
	giInput.ambient = IN.sh;
#else
	giInput.ambient.rgb = 0.0;
#endif
	giInput.probeHDR[0] = unity_SpecCube0_HDR;
	giInput.probeHDR[1] = unity_SpecCube1_HDR;
#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
	giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
#endif
#if UNITY_SPECCUBE_BOX_PROJECTION
	giInput.boxMax[0] = unity_SpecCube0_BoxMax;
	giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
	giInput.boxMax[1] = unity_SpecCube1_BoxMax;
	giInput.boxMin[1] = unity_SpecCube1_BoxMin;
	giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
#endif
	LightingStandard_GI(o, giInput, gi);

	// realtime lighting: call lighting function
	c += LightingStandard(o, worldViewDir, gi);
	
	#ifdef V_WIRE_LIGHT_ON
		c.rgb += o.Emission;

		#if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
			float fogCoord = mul(UNITY_MATRIX_VP, float4(worldPos, 1)).z;
			UNITY_APPLY_FOG(fogCoord, c);
		#endif
	#else
		WireFinalColor(surfIN, o, c);
	#endif

	UNITY_OPAQUE_ALPHA(c.a);
	return c;
	}

		ENDCG

	}

		// ---- forward rendering additive lights pass:
		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One

		CGPROGRAM
		// compile directives
#pragma vertex tessvert_surf
#pragma hull hs_surf
#pragma domain ds_surf
#pragma geometry geom
#pragma fragment frag_surf
#pragma target 5.0 
#pragma multi_compile_fog
#pragma multi_compile_fwdadd_fullshadows nodynlightmap nolightmap
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
		// Surface shader code generated based on:
		// vertex modifier: 'vert'
		// writes to per-pixel normal: YES
		// writes to emission: no
		// needs world space reflection vector: no
		// needs world space normal vector: no
		// needs screen space position: no
		// needs world space position: YES
		// needs view direction: no
		// needs world space view direction: no
		// needs world space position for lighting: YES
		// needs world space view direction for lighting: YES
		// needs world space view direction for lightmaps: no
		// needs vertex color: YES
		// needs VFACE: no
		// passes tangent-to-world matrix to pixel shader: YES
		// reads from normal: no
		// 0 texcoords actually used
#define UNITY_PASS_FORWARDADD
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

		// Original surface shader snippet:
#line 81 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert finalcolor:WireFinalColor

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0





		#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
		#ifdef UNITY_PASS_DEFERRED
		#ifndef V_WIRE_LIGHT_ON
		#define V_WIRE_LIGHT_ON
		#endif
		#endif

		#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
		#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON

		#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE
		

#define V_WIRE_PBR
#define _NORMALMAP 

#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_PBR.cginc" 


		// vertex-to-fragment interpolation data
		struct v2f_surf {
		float4 pos : SV_POSITION;
		fixed3 tSpace0 : TEXCOORD0;
		fixed3 tSpace1 : TEXCOORD1;
		fixed3 tSpace2 : TEXCOORD2;
		float3 worldPos : TEXCOORD3;
		fixed4 color : COLOR0;
		float4 custompack0 : TEXCOORD4; // texcoord
		float4 custompack1 : TEXCOORD5; // texcoord1
		half4 custompack2 : TEXCOORD6; // mass
		SHADOW_COORDS(7)
	};


#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS.cginc"


	// vertex shader
	v2f_surf vert_surf(appdata_full v) {
		v2f_surf o;
		UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
		Input customInputData;
		vert(v, customInputData);
		o.custompack0.xyzw = customInputData.texcoord;
		o.custompack1.xyzw = customInputData.texcoord1;
		o.custompack2.xyzw = customInputData.mass;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
		fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
		o.tSpace0 = fixed3(worldTangent.x, worldBinormal.x, worldNormal.x);
		o.tSpace1 = fixed3(worldTangent.y, worldBinormal.y, worldNormal.y);
		o.tSpace2 = fixed3(worldTangent.z, worldBinormal.z, worldNormal.z);
		o.worldPos = worldPos;
		o.color = v.color;

		TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
		return o;
	}


#pragma shader_feature _ V_WIRE_TESSELLATION_DISTANCE_BASED V_WIRE_TESSELLATION_EDGE_LENGTH
#pragma shader_feature _ V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Tessellation.cginc"


	// fragment shader
	fixed4 frag_surf(v2f_surf IN) : SV_Target{
		// prepare and unpack data
		Input surfIN;
	UNITY_INITIALIZE_OUTPUT(Input,surfIN);
	surfIN.texcoord.x = 1.0;
	surfIN.texcoord1.x = 1.0;
	surfIN.worldPos.x = 1.0;
	surfIN.mass.x = 1.0;
	surfIN.color.x = 1.0;
	surfIN.texcoord = IN.custompack0.xyzw;
	surfIN.texcoord1 = IN.custompack1.xyzw;
	surfIN.mass = IN.custompack2.xyzw;
	float3 worldPos = IN.worldPos;
#ifndef USING_DIRECTIONAL_LIGHT
	fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
#else
	fixed3 lightDir = _WorldSpaceLightPos0.xyz;
#endif
	fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
	surfIN.worldPos = worldPos;
	surfIN.color = IN.color;
#ifdef UNITY_COMPILER_HLSL
	SurfaceOutputStandard o = (SurfaceOutputStandard)0;
#else
	SurfaceOutputStandard o;
#endif
	o.Albedo = 0.0;
	o.Emission = 0.0;
	o.Alpha = 0.0;
	o.Occlusion = 1.0;
	fixed3 normalWorldVertex = fixed3(0,0,1);

	// call surface function
	surf(surfIN, o);
	UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
		fixed4 c = 0;
	fixed3 worldN;
	worldN.x = dot(IN.tSpace0.xyz, o.Normal);
	worldN.y = dot(IN.tSpace1.xyz, o.Normal);
	worldN.z = dot(IN.tSpace2.xyz, o.Normal);
	o.Normal = worldN;

	// Setup lighting environment
	UnityGI gi;
	UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
	gi.indirect.diffuse = 0;
	gi.indirect.specular = 0;
#if !defined(LIGHTMAP_ON)
	gi.light.color = _LightColor0.rgb;
	gi.light.dir = lightDir;
	gi.light.ndotl = LambertTerm(o.Normal, gi.light.dir);
#endif
	gi.light.color *= atten;
	c += LightingStandard(o, worldViewDir, gi);
	c.a = 0.0;
	WireFinalColor(surfIN, o, c);
	UNITY_OPAQUE_ALPHA(c.a);
	return c;
	}

		ENDCG

	}

		// ---- deferred shading pass:
		Pass{
		Name "DEFERRED"
		Tags{ "LightMode" = "Deferred" }

		CGPROGRAM
		// compile directives
#pragma vertex tessvert_surf
#pragma hull hs_surf
#pragma domain ds_surf
#pragma geometry geom
#pragma fragment frag_surf
#pragma target 5.0 
#pragma exclude_renderers nomrt
#pragma multi_compile_prepassfinal nodynlightmap nolightmap
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
		// Surface shader code generated based on:
		// vertex modifier: 'vert'
		// writes to per-pixel normal: YES
		// writes to emission: no
		// needs world space reflection vector: no
		// needs world space normal vector: no
		// needs screen space position: no
		// needs world space position: YES
		// needs view direction: no
		// needs world space view direction: no
		// needs world space position for lighting: YES
		// needs world space view direction for lighting: YES
		// needs world space view direction for lightmaps: no
		// needs vertex color: YES
		// needs VFACE: no
		// passes tangent-to-world matrix to pixel shader: YES
		// reads from normal: no
		// 0 texcoords actually used
#define UNITY_PASS_DEFERRED
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

		// Original surface shader snippet:
#line 81 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert finalcolor:WireFinalColor

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0





		#pragma shader_feature V_WIRE_LIGHT_OFF V_WIRE_LIGHT_ON
		#ifdef UNITY_PASS_DEFERRED
		#ifndef V_WIRE_LIGHT_ON
		#define V_WIRE_LIGHT_ON
		#endif
		#endif

		#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
		#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON

		#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE
		

#define V_WIRE_PBR
#define _NORMALMAP 

#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_PBR.cginc" 


		// vertex-to-fragment interpolation data
		struct v2f_surf {
		float4 pos : SV_POSITION;
		float4 tSpace0 : TEXCOORD0;
		float4 tSpace1 : TEXCOORD1;
		float4 tSpace2 : TEXCOORD2;
		fixed4 color : COLOR0;
		float4 custompack0 : TEXCOORD3; // texcoord
		float4 custompack1 : TEXCOORD4; // texcoord1
		half4 custompack2 : TEXCOORD5; // mass
#ifndef DIRLIGHTMAP_OFF
		half3 viewDir : TEXCOORD6;
#endif
		float4 lmap : TEXCOORD7;
#ifdef LIGHTMAP_OFF
#if UNITY_SHOULD_SAMPLE_SH
		half3 sh : TEXCOORD8; // SH
#endif
#else
#ifdef DIRLIGHTMAP_OFF
		float4 lmapFadePos : TEXCOORD8;
#endif
#endif
	};


#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS.cginc"


	// vertex shader
	v2f_surf vert_surf(appdata_full v) {
		v2f_surf o;
		UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
		Input customInputData;
		vert(v, customInputData);
		o.custompack0.xyzw = customInputData.texcoord;
		o.custompack1.xyzw = customInputData.texcoord1;
		o.custompack2.xyzw = customInputData.mass;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
		fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
		o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
		o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
		o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
		float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
#ifndef DIRLIGHTMAP_OFF
		o.viewDir.x = dot(viewDirForLight, worldTangent);
		o.viewDir.y = dot(viewDirForLight, worldBinormal);
		o.viewDir.z = dot(viewDirForLight, worldNormal);
#endif
		o.color = v.color;
#ifndef DYNAMICLIGHTMAP_OFF
		o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#else
		o.lmap.zw = 0;
#endif
#ifndef LIGHTMAP_OFF
		o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#ifdef DIRLIGHTMAP_OFF
		o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
		o.lmapFadePos.w = (-mul(UNITY_MATRIX_MV, v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
#endif
#else
		o.lmap.xy = 0;
#if UNITY_SHOULD_SAMPLE_SH
		o.sh = 0;
		o.sh = ShadeSHPerVertex(worldNormal, o.sh);
#endif
#endif
		return o;
	}
#ifdef LIGHTMAP_ON
	float4 unity_LightmapFade;
#endif
	fixed4 unity_Ambient;


#pragma shader_feature _ V_WIRE_TESSELLATION_DISTANCE_BASED V_WIRE_TESSELLATION_EDGE_LENGTH
#pragma shader_feature _ V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Tessellation.cginc"


	// fragment shader
	void frag_surf(v2f_surf IN,
		out half4 outDiffuse : SV_Target0,
		out half4 outSpecSmoothness : SV_Target1,
		out half4 outNormal : SV_Target2,
		out half4 outEmission : SV_Target3) {
		// prepare and unpack data
		Input surfIN;
		UNITY_INITIALIZE_OUTPUT(Input,surfIN);
		surfIN.texcoord.x = 1.0;
		surfIN.texcoord1.x = 1.0;
		surfIN.worldPos.x = 1.0;
		surfIN.mass.x = 1.0;
		surfIN.color.x = 1.0;
		surfIN.texcoord = IN.custompack0.xyzw;
		surfIN.texcoord1 = IN.custompack1.xyzw;
		surfIN.mass = IN.custompack2.xyzw;
		float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
#ifndef USING_DIRECTIONAL_LIGHT
		fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
#else
		fixed3 lightDir = _WorldSpaceLightPos0.xyz;
#endif
		fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
		surfIN.worldPos = worldPos;
		surfIN.color = IN.color;
#ifdef UNITY_COMPILER_HLSL
		SurfaceOutputStandard o = (SurfaceOutputStandard)0;
#else
		SurfaceOutputStandard o;
#endif
		o.Albedo = 0.0;
		o.Emission = 0.0;
		o.Alpha = 0.0;
		o.Occlusion = 1.0;
		fixed3 normalWorldVertex = fixed3(0,0,1);

		// call surface function
		surf(surfIN, o);
		fixed3 originalNormal = o.Normal;
		fixed3 worldN;
		worldN.x = dot(IN.tSpace0.xyz, o.Normal);
		worldN.y = dot(IN.tSpace1.xyz, o.Normal);
		worldN.z = dot(IN.tSpace2.xyz, o.Normal);
		o.Normal = worldN;
		half atten = 1;

		// Setup lighting environment
		UnityGI gi;
		UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
		gi.indirect.diffuse = 0;
		gi.indirect.specular = 0;
		gi.light.color = 0;
		gi.light.dir = half3(0,1,0);
		gi.light.ndotl = LambertTerm(o.Normal, gi.light.dir);
		// Call GI (lightmaps/SH/reflections) lighting function
		UnityGIInput giInput;
		UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
		giInput.light = gi.light;
		giInput.worldPos = worldPos;
		giInput.worldViewDir = worldViewDir;
		giInput.atten = atten;
#if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
		giInput.lightmapUV = IN.lmap;
#else
		giInput.lightmapUV = 0.0;
#endif
#if UNITY_SHOULD_SAMPLE_SH
		giInput.ambient = IN.sh;
#else
		giInput.ambient.rgb = 0.0;
#endif
		giInput.probeHDR[0] = unity_SpecCube0_HDR;
		giInput.probeHDR[1] = unity_SpecCube1_HDR;
#if UNITY_SPECCUBE_BLENDING || UNITY_SPECCUBE_BOX_PROJECTION
		giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
#endif
#if UNITY_SPECCUBE_BOX_PROJECTION
		giInput.boxMax[0] = unity_SpecCube0_BoxMax;
		giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
		giInput.boxMax[1] = unity_SpecCube1_BoxMax;
		giInput.boxMin[1] = unity_SpecCube1_BoxMin;
		giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
#endif
		LightingStandard_GI(o, giInput, gi);

		// call lighting function to output g-buffer
		outEmission = LightingStandard_Deferred(o, worldViewDir, gi, outDiffuse, outSpecSmoothness, outNormal);
#ifndef UNITY_HDR_ON
		outEmission.rgb = exp2(-outEmission.rgb);
#endif
		UNITY_OPAQUE_ALPHA(outDiffuse.a);
	}

	ENDCG

	}


			// ---- meta information extraction pass:
	Pass {
		Name "Meta"
		Tags { "LightMode" = "Meta" }
		Cull Off

CGPROGRAM
// compile directives
#pragma vertex tessvert_surf
#pragma hull hs_surf
#pragma domain ds_surf
#pragma geometry geom
#pragma fragment frag_surf
#pragma target 5.0 
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#pragma skip_variants INSTANCING_ON
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: YES
// writes to emission: no
// writes to occlusion: YES
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: YES
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: YES
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: YES
// reads from normal: no
// 0 texcoords actually used
#define UNITY_PASS_META
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

// Original surface shader snippet:
#line 105 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
    
		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert finalcolor:WireFinalColor

		// Use shader model 3.0 target, to get nicer looking lighting
		//#pragma target 3.0

			 
		
		     
		#pragma shader_feature V_WIRE_SOURCE_BAKED V_WIRE_SOURCE_TEXTURE
			 
		#pragma shader_feature V_WIRE_FRESNEL_OFF V_WIRE_FRESNEL_ON
		#pragma shader_feature V_WIRE_TRANSPARENCY_OFF V_WIRE_TRANSPARENCY_ON		

		#pragma shader_feature V_WIRE_DYNAMIC_MASK_OFF V_WIRE_DYNAMI_MASK_PLANE V_WIRE_DYNAMIC_MASK_SPHERE 
		

		#define V_WIRE_PBR
		#define _NORMALMAP 
		   		   
		#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_PBR.cginc" 
		
#include "UnityMetaPass.cginc"

// vertex-to-fragment interpolation data
struct v2f_surf {
  float4 pos : SV_POSITION;
  float4 tSpace0 : TEXCOORD0;
  float4 tSpace1 : TEXCOORD1;
  float4 tSpace2 : TEXCOORD2;
  fixed4 color : COLOR0;
  float4 custompack0 : TEXCOORD3; // texcoord
  float4 custompack1 : TEXCOORD4; // texcoord1
  half4 custompack2 : TEXCOORD5; // mass
};


#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS.cginc"


// vertex shader
v2f_surf vert_surf (appdata_full v) {
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  Input customInputData;
  vert (v, customInputData);
  o.custompack0.xyzw = customInputData.texcoord;
  o.custompack1.xyzw = customInputData.texcoord1;
  o.custompack2.xyzw = customInputData.mass;
  o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
  o.color = v.color;
  return o;
}


#pragma shader_feature _ V_WIRE_TESSELLATION_DISTANCE_BASED V_WIRE_TESSELLATION_EDGE_LENGTH
#pragma shader_feature _ V_WIRE_TESSELLATION_NORMAL_RECONSTRUCT
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Tessellation.cginc"


// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  // prepare and unpack data
  Input surfIN;
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.texcoord.x = 1.0;
  surfIN.texcoord1.x = 1.0;
  surfIN.worldPos.x = 1.0;
  surfIN.mass.x = 1.0;
  surfIN.color.x = 1.0;
  surfIN.texcoord = IN.custompack0.xyzw;
  surfIN.texcoord1 = IN.custompack1.xyzw;
  surfIN.mass = IN.custompack2.xyzw;
  float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  surfIN.worldPos = worldPos;
  surfIN.color = IN.color;
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);
  UnityMetaInput metaIN;
  UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
  metaIN.Albedo = o.Albedo;
  metaIN.Emission = o.Emission;
  return UnityMetaFragment(metaIN);
}

ENDCG

}



	UsePass "Hidden/VacuumShaders/The Amazing Wireframe/Tessellation/Shadow/Opaque/SHADOWCASTER"

	}

	FallBack "Hidden/VacuumShaders/The Amazing Wireframe/Physically Based/Opaque/Bumped"
}
