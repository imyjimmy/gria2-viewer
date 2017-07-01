#ifndef VACUUM_WIREFRAME_PBR_SPECIAL_CGINC
#define VACUUM_WIREFRAME_PBR_SPECIAL_CGINC

  
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


//Variables//////////////////////////////////
fixed4 _Color;
float _V_WIRE_VertexColor;
sampler2D _MainTex;
half4 _MainTex_ST;
half2 _V_WIRE_MainTex_Scroll;

 


//Struct/////////////////////////////////////////////////////////
struct v2f_surf
{
	float4 pos : SV_POSITION;

	half3 worldPos : TEXCOORD0;

	float4 texcoord : TEXCOORD1; // xy - uv, zw - wireTex coord,
		
	half3 custompack2 : TEXCOORD2; //xyz - mass

	float3 worldNormal : TEXCOORD3;	//xyz - normal
	
	half4 color : COLOR;

	UNITY_FOG_COORDS(4)
};

//Vertex Shader///////////////////////////////////////////
v2f_surf vert_surf(appdata_full v) 
{
	v2f_surf o;
	UNITY_INITIALIZE_OUTPUT(v2f_surf,o);


//Curved World Compatibility
//V_CW_TransformPointAndNormal(v.vertex, v.normal, v.tangent);


	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

#ifdef V_WIRE_TRY_QUAD_ON
	o.worldPos = v.vertex.xyz;
#else
	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif

	o.texcoord.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
	o.texcoord.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;

	o.texcoord.zw = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
	o.texcoord.zw += _V_WIRE_WireTex_Scroll.xy * _Time.x;

	#ifdef V_WIRE_FRESNEL_ON
		o.worldNormal = UnityObjectToWorldNormal(v.normal);
	#endif


	o.color = v.color;


	o.custompack2 = ExtructWireframeFromVertexUV(v.texcoord);


	UNITY_TRANSFER_FOG(o, o.pos);

	return o;
}



//Pixel Shader///////////////////////////////////////////
fixed4 frag_surf(v2f_surf IN) : SV_Target
{	
	//Color
	#if defined(V_WIRE_NO_COLOR_BLACK)
		fixed4 retColor = 0;
	#elif defined(V_WIRE_NO_COLOR_WHITE)
		fixed4 retColor = 1;
	#else
		fixed4 retColor = _Color;
	#endif	

	//Main Texture
	#ifdef V_WIRE_HAS_TEXTURE
		half4 mainTex = tex2D(_MainTex, IN.texcoord.xy);

		#if defined(V_WIRE_HAS_TEXTURE) && !defined(V_WIRE_NO_COLOR_BLACK) && !defined(V_WIRE_NO_COLOR_WHITE)
			retColor *= mainTex;
		#endif		
	#endif 
	 
	//Vertex Color
	retColor.rgb *= lerp(1, IN.color.rgb, _V_WIRE_VertexColor);



	//Dynamic Mask
	half dynamicMask = 1;
	#ifdef V_WIRE_DYNAMIC_MASK_ON	
		dynamicMask = V_WIRE_DynamicMask(IN.worldPos);
				
		#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
			half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

			#ifdef V_WIRE_CUTOUT
				retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
			#else
				retColor.a *= maskMainTexA;
			#endif
		#endif
	#endif



	 
	//Wire
	fixed4 wireTexColor = tex2D(_V_WIRE_WireTex, IN.texcoord.zw);
	wireTexColor.rgb *= lerp(1, IN.color.rgb, _V_WIRE_WireVertexColor);

	
	#ifdef V_WIRE_TRANSPARENCY_ON
		half customAlpha = wireTexColor.a;

		customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);
				 
		customAlpha = saturate(customAlpha + _V_WIRE_TransparentTex_Alpha_Offset);


		_V_WIRE_Color.a *= customAlpha;
	#endif

	#ifdef V_WIRE_MULTIPLY
		retColor.rgb = lerp(1, retColor.rgb, retColor.a);
	#endif

	#ifdef V_WIRE_ADDATIVE
		retColor.rgb = lerp(0, retColor.rgb, retColor.a);
	#endif
			

	#ifdef V_WIRE_FRESNEL_ON		
		fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(IN.worldPos));
		
		half fresnel = saturate(dot (worldViewDir, IN.worldNormal));

		half wFresnel = saturate(fresnel + _V_WIRE_FresnelBias);
		wFresnel = lerp(wFresnel, 1 - wFresnel, _V_WIRE_FresnelInvert);
		
		wFresnel = pow(wFresnel, _V_WIRE_FresnelPow);

		_V_WIRE_Color.a *= wFresnel;
	#endif 

	float fixedSize = distance(_WorldSpaceCameraPos, IN.worldPos);
	float distanceFade = (_V_WIRE_DistanceFadeEnd - fixedSize) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);

				
	float3 wireEmission = 0;
	DoWire(wireTexColor, retColor, IN.custompack2, saturate(distanceFade), fixedSize, dynamicMask, wireEmission);

	//Emission
	retColor.rgb += wireEmission;

	
	//Fog
	#if defined(V_WIRE_ADDATIVE)
		UNITY_APPLY_FOG_COLOR(IN.fogCoord, retColor, fixed4(0,0,0,0)); // fog towards black due to our blend mode
	#elif defined(V_WIRE_MULTIPLY)
		UNITY_APPLY_FOG_COLOR(IN.fogCoord, retColor, fixed4(1,1,1,1)); // fog towards white due to our blend mode
	#else
		UNITY_APPLY_FOG(IN.fogCoord, retColor);
	#endif

	//Alpha
	UNITY_OPAQUE_ALPHA(retColor.a);


	return retColor;	
}


#endif
