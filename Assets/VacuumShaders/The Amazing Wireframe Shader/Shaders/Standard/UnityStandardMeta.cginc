#ifndef UNITY_STANDARD_META_INCLUDED
#define UNITY_STANDARD_META_INCLUDED

// Functionality for Standard shader "meta" pass
// (extracts albedo/emission for lightmapper etc.)

// define meta pass before including other files; they have conditions
// on that in some places
#define UNITY_PASS_META 1

#include "UnityCG.cginc"
#include "UnityStandardInput.cginc"
#include "UnityMetaPass.cginc"
#include "UnityStandardCore.cginc"


//wireframe
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Standard.cginc"

struct v2f_meta
{
	float4 uv		: TEXCOORD0;
	float4 pos		: SV_POSITION;

	float3 mass : TEXCOORD1; //Wireframe
	float2 wireUV : TEXCOORD2;
	float3 worldPos : TEXCOORD3;
	float3 worldNormal : TEXCOORD5;
};

v2f_meta vert_meta (VertexInput v)
{
	v2f_meta o;	
	
	o.pos = UnityMetaVertexPosition(v.vertex, v.uv1.xy, v.uv2.xy, unity_LightmapST, unity_DynamicLightmapST);
	o.uv = TexCoords(v);
	

	o.mass.xyz = ExtructWireframeFromVertexUV(v.uv0);	//Wireframe
	o.wireUV = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet > 0.5) ? v.uv1.xy : v.uv0.xy), _V_WIRE_WireTex);	
	
	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	o.worldNormal = UnityObjectToWorldNormal(v.normal);

	return o;
}

// Albedo for lightmapping should basically be diffuse color.
// But rough metals (black diffuse) still scatter quite a lot of light around, so
// we want to take some of that into account too.
half3 UnityLightmappingAlbedo (half3 diffuse, half3 specular, half oneMinusRoughness)
{
	half roughness = 1 - oneMinusRoughness;
	half3 res = diffuse;
	res += specular * roughness * roughness * 0.5;
	return res;
}

float4 frag_meta (v2f_meta i) : SV_Target
{
	// we're interested in diffuse & specular colors,
	// and surface roughness to produce final albedo.
	FragmentCommonData data = UNITY_SETUP_BRDF_INPUT (i.uv);

	UnityMetaInput o;
	UNITY_INITIALIZE_OUTPUT(UnityMetaInput, o);

	o.Albedo = UnityLightmappingAlbedo (data.diffColor, data.specColor, data.oneMinusRoughness);
	o.Emission = Emission(i.uv.xy);


	//Wireframe
	float3 wireEmission = 0;
	float alpha = 0;

	SetupWireframe(i.mass.xyz, i.wireUV, i.worldPos.xyz, i.worldNormal, o.Albedo, alpha, wireEmission);
#ifdef _ALPHATEST_ON
	wireEmission *= saturate(Alpha(i.uv.xy) - _Cutoff);
#endif
	o.Emission += wireEmission;




	return UnityMetaFragment(o);
}

#endif // UNITY_STANDARD_META_INCLUDED
