// VacuumShaders 2015
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/The Amazing Wireframe/Geometry Shader/Transparent/2 Sided/Bumped"
{
	Properties
	{
		//Tag         
		[V_WIRE_Tag] _V_WIRE_Tag("", float) = 0

		//Rendering Options
		[V_WIRE_RenderingOptions] _V_WIRE_RenderingOptions_PBREnumID("", float) = 0


		//Visual Options
		[V_WIRE_Title] _V_WIRE_Title_V_Options("Default Visual Options", float) = 0

		//Base
		_Color("Color (RGB) Trans (A)", color) = (1, 1, 1, 1)

		//Vertex Color
		[V_WIRE_Toggle] _V_WIRE_VertexColor("Vertex Color", float) = 0

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0

		_MainTex("Base (RGB) Trans (A)", 2D) = "white"{}
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
		[Toggle(V_WIRE_TRY_QUAD_ON)] _V_WIRE_TryQuad("Try Quad", Float) = 0

		//Wire Options  
		[V_WIRE_Title] _V_WIRE_Title_W_Options("Wire Visual Options", float) = 0  	

		_V_WIRE_Color("Color", color) = (0, 0, 0, 1)
		_V_WIRE_WireTex("Color Texture (RGBA)", 2D) = "white"{}
		[V_WIRE_UVScroll] _V_WIRE_WireTex_Scroll("    ", vector) = (0, 0, 0, 0)
		[Enum(UV0,0,UV1,1)] _V_WIRE_WireTex_UVSet("    UV Set", float) = 0

		//Emission
		[V_WIRE_PositiveFloat] _V_WIRE_EmissionStrength("Emission Strength", float) = 0

		//Vertex Color
		[V_WIRE_Toggle] _V_WIRE_WireVertexColor("Vertex Color", Float) = 0

		//Light
		[V_WIRE_IncludeLight] _V_WIRE_IncludeLightEnumID ("", float) = 0

		//Improved Transparent Blend
		[V_WIRE_ImprovedBlend] _V_WIRE_ImprovedBlendEnumID("", int) = 0

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
		Tags{ "Queue" = "Transparent"
		"IgnoreProjector" = "True"
		"RenderType" = "Transparent"
	}
		LOD 200

		ZWrite Off
		Cull Front


		// ------------------------------------------------------------
		// Surface shader code generated out of a CGPROGRAM block:
		ZWrite Off ColorMask RGB


		// ---- forward rendering base pass:
		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		// compile directives
#pragma vertex vert_surf
#pragma geometry geom
#pragma fragment frag_surf
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS_Platform.cginc"
#pragma multi_compile_fog
#pragma multi_compile_fwdbasealpha noshadow
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
#define _ALPHABLEND_ON 1
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

		// Original surface shader snippet:
#line 88 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade finalcolor:WireFinalColor

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
		#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 	

		#pragma shader_feature	V_WIRE_TRY_QUAD_OFF V_WIRE_TRY_QUAD_ON

#define V_WIRE_PBR
#define V_WIRE_TRANSPARENT
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
#if SHADER_TARGET >= 30
		float4 lmap : TEXCOORD7;
#endif

		float3 objectPos : TEXCOORD8;
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

		float3 objectPos : TEXCOORD7;
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
		o.objectPos = v.vertex.xyz;

		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
		fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
		o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
		o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
		o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
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

		return o;
	}

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

	return c;
	}

		ENDCG

	}

		// ---- forward rendering additive lights pass:
		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One
		Blend SrcAlpha One

		CGPROGRAM
		// compile directives
#pragma vertex vert_surf
#pragma geometry geom
#pragma fragment frag_surf
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS_Platform.cginc"
#pragma multi_compile_fog
#pragma multi_compile_fwdadd_fullshadows noshadow
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
#define _ALPHABLEND_ON 1
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

		// Original surface shader snippet:
#line 88 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade finalcolor:WireFinalColor

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
		#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON 	

		#pragma shader_feature	V_WIRE_TRY_QUAD_OFF V_WIRE_TRY_QUAD_ON

#define V_WIRE_PBR
#define V_WIRE_TRANSPARENT
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

		float3 objectPos : TEXCOORD7;
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
		o.objectPos = v.vertex.xyz;

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

		return o;
	}

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
	WireFinalColor(surfIN, o, c);
	return c;
	}

		ENDCG

	}

		ZWrite On
		Cull Back


		// ------------------------------------------------------------
		// Surface shader code generated out of a CGPROGRAM block:
		ZWrite Off ColorMask RGB


		// ---- forward rendering base pass:
		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		// compile directives
#pragma vertex vert_surf
#pragma geometry geom
#pragma fragment frag_surf
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS_Platform.cginc"
#pragma multi_compile_fog
#pragma multi_compile_fwdbasealpha noshadow
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
#define _ALPHABLEND_ON 1
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

		// Original surface shader snippet:
#line 122 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade finalcolor:WireFinalColor

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
		#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON

		#pragma shader_feature	V_WIRE_TRY_QUAD_OFF V_WIRE_TRY_QUAD_ON

#define V_WIRE_PBR
#define V_WIRE_TRANSPARENT
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
#if SHADER_TARGET >= 30
		float4 lmap : TEXCOORD7;
#endif

		float3 objectPos : TEXCOORD8;
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

		float3 objectPos : TEXCOORD7;
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
		o.objectPos = v.vertex.xyz;

		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
		float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
		fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
		fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
		fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
		o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
		o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
		o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
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

		return o;
	}

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

	return c;
	}

		ENDCG

	}

		// ---- forward rendering additive lights pass:
		Pass{
		Name "FORWARD"
		Tags{ "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One
		Blend SrcAlpha One

		CGPROGRAM
		// compile directives
#pragma vertex vert_surf
#pragma geometry geom
#pragma fragment frag_surf
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_GS_Platform.cginc"
#pragma multi_compile_fog
#pragma multi_compile_fwdadd_fullshadows noshadow
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
#define _ALPHABLEND_ON 1
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

		// Original surface shader snippet:
#line 122 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif

		// Physically based Standard lighting model, and enable shadows on all light types
		//#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade finalcolor:WireFinalColor

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
		#pragma shader_feature V_WIRE_DYNAMIC_MASK_BASE_TEX_OFF V_WIRE_DYNAMIC_MASK_BASE_TEX_ON

		#pragma shader_feature	V_WIRE_TRY_QUAD_OFF V_WIRE_TRY_QUAD_ON

#define V_WIRE_PBR
#define V_WIRE_TRANSPARENT
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

		float3 objectPos : TEXCOORD7;
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
		o.objectPos = v.vertex.xyz;

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

		return o;
	}

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
	WireFinalColor(surfIN, o, c);
	return c;
	}

		ENDCG

	}

	}

		FallBack "Hidden/VacuumShaders/The Amazing Wireframe/Mobile/Vertex Lit/Transparent/Full"
}
