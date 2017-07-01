#ifndef VACUUM_WIREFRAME_VERTEXLIT_CGINC
#define VACUUM_WIREFRAME_VERTEXLIT_CGINC


//Variables//////////////////////////////////
fixed4 _Color;
float _V_WIRE_VertexColor;
sampler2D _MainTex;
half4 _MainTex_ST;
half2 _V_WIRE_MainTex_Scroll;

#ifdef V_WIRE_CUTOUT
	half _Cutoff; 
#endif

#include "UnityCG.cginc"
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"

////////////////////////////////////////////////////////////////////////////
//																		  //
//Struct    															  //
//																		  //
////////////////////////////////////////////////////////////z////////////////
struct v2f  
{  
	float4 pos : SV_POSITION;
	float4 uv : TEXCOORD0;	

	#ifdef V_WIRE_LIGHTMAP_ON
		half2 lm : TEXCOORD1;
	#else
		half4 vLight : TEXCOORD1;
	#endif		
	
	fixed4 color : TEXCOORD2;
	
	#ifdef V_WIRE_DYNAMIC_MASK_ON
		half3 maskPos : TEXCOORD3;
	#endif
	
	
	half3 mass : TEXCOORD4;

	float2 data : TEXCOORD6;	//x - fadeCoord, y - fixedSizeCoord

	//FOG
	UNITY_FOG_COORDS(5)	
};

 
////////////////////////////////////////////////////////////////////////////
//																		  //
//Vertex    															  //
//																		  //
////////////////////////////////////////////////////////////////////////////
v2f vert (appdata_full v) 
{   
	v2f o;
	UNITY_INITIALIZE_OUTPUT(v2f,o); 


//Curved World Compatibility
#ifdef V_CURVEDWORLD_COMPATIBILITY_ON
	#ifndef LIGHTMAP_OFF
//V_CW_TransformPoint(v.vertex);
	#else
//V_CW_TransformPointAndNormal(v.vertex, v.normal, v.tangent);
	#endif
#endif 


	o.pos = mul(UNITY_MATRIX_MVP, v.vertex); 
	o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
	o.uv.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;

	o.uv.zw = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
	o.uv.zw += _V_WIRE_WireTex_Scroll.xy * _Time.x;
			 

	#ifdef V_WIRE_LIGHTMAP_ON
		o.lm = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	#else
		float4 lighting = float4(ShadeVertexLightsFull(v.vertex, v.normal, 4, true), 1);
		o.vLight = lighting;
	#endif

	
	o.color = v.color;

	#ifdef V_WIRE_DYNAMIC_MASK_ON		
		o.maskPos = mul(unity_ObjectToWorld, half4(v.vertex.xyz, 1)).xyz;
	#endif


	//FOG
	UNITY_TRANSFER_FOG(o, o.pos);

	#ifndef V_WIRE_NO
		o.mass = ExtructWireframeFromVertexUV(v.texcoord);

		o.data.y = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));

		o.data.x = (_V_WIRE_DistanceFadeEnd - o.data.y) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);
	
	#endif

	return o; 
}


////////////////////////////////////////////////////////////////////////////
//																		  //
//Fragment    															  //
//																		  //
////////////////////////////////////////////////////////////////////////////
fixed4 frag (v2f i) : SV_Target 
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
		half4 mainTex = tex2D(_MainTex, i.uv.xy);

		#if defined(V_WIRE_HAS_TEXTURE) && !defined(V_WIRE_NO_COLOR_BLACK) && !defined(V_WIRE_NO_COLOR_WHITE)
			retColor *= mainTex;
		#endif		
	#endif

	//Vertex Color
	retColor.rgb *= lerp(1, i.color.rgb, _V_WIRE_VertexColor);


	#ifdef V_WIRE_LIGHTMAP_ON
		half3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lm));

		retColor.rgb *= lm.rgb;

		#ifdef V_WIRE_LIGHT_ON
			_V_WIRE_Color.rgb *= lm.rgb;	
		#endif
	#else 
		retColor *= i.vLight;

		#ifdef V_WIRE_LIGHT_ON
			_V_WIRE_Color.rgb *= i.vLight.rgb;
		#endif
	#endif
	

	//Dynamic Mask
	half dynamicMask = 1;
	#ifdef V_WIRE_DYNAMIC_MASK_ON	 
		dynamicMask = V_WIRE_DynamicMask(i.maskPos);

					
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
	#ifndef V_WIRE_NO

		fixed4 wireTexColor = tex2D(_V_WIRE_WireTex, i.uv.zw);
		wireTexColor.rgb *= lerp(1, i.color.rgb, _V_WIRE_WireVertexColor);

		float3 wireEmission = 0;

		#ifdef V_WIRE_CUTOUT
		
			half customAlpha = 1;
			#ifdef V_WIRE_TRANSPARENCY_ON
				customAlpha = wireTexColor.a;

				customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);
				
				customAlpha = (customAlpha + _V_WIRE_TransparentTex_Alpha_Offset) < 0.01 ? 0 : 1;
			#endif
							
			half clipValue = DoWire(wireTexColor, retColor, i.mass, saturate(i.data.x), i.data.y, dynamicMask, customAlpha, _Cutoff, wireEmission);


			#ifdef V_WIRE_CUTOUT_HALF
				clip(clipValue - 0.5);
			#else
				clip(clipValue);
			#endif 

		#else 			

			#ifdef V_WIRE_TRANSPARENCY_ON
				half customAlpha = wireTexColor.a;

				customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);

				customAlpha = saturate(customAlpha + _V_WIRE_TransparentTex_Alpha_Offset);


				_V_WIRE_Color.a *= customAlpha;
			#endif
				
			DoWire(wireTexColor, retColor, i.mass, saturate(i.data.x), i.data.y, dynamicMask, wireEmission);

		#endif

		//Emission
		retColor.rgb += wireEmission;

	#else

		#ifdef V_WIRE_CUTOUT
			clip(retColor.a - _Cutoff);
		#endif

	#endif

	
	//Fog
	UNITY_APPLY_FOG(i.fogCoord, retColor);

	//Alpha
	#if !defined(V_WIRE_CUTOUT) && !defined(V_WIRE_TRANSPARENT)
		UNITY_OPAQUE_ALPHA(retColor.a);
	#endif

	return retColor;
} 

#endif 
