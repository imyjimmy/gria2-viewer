#ifndef VACUUM_WIREFRAME_DEPTHNORMALS_CGINC
#define VACUUM_WIREFRAME_DEPTHNORMALS_CGINC

#include  "UnityCG.cginc"   
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


//Variables//////////////////////////////////
fixed4 _Color;
float _V_WIRE_VertexColor;
#ifdef V_WIRE_HAS_TEXTURE
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_WIRE_MainTex_Scroll;
#endif


#ifdef V_WIRE_CUTOUT
	half _Cutoff; 
#endif

struct v2f_surf
{
	float4 pos :SV_POSITION;

	half4 uv : TEXCOORD0;	//xy - mainTex, zw - wireTex
	
	float3 worldPos : TEXCOORD1;
		
	fixed3 custompack2 : TEXCOORD2; //mass

	fixed4 color : TEXCOORD3;


	float4 nz : TEXCOORD4;
}; 


//Vertex Shader///////////////////////////////////////////
v2f_surf vert_surf(appdata_full v)
{ 
	v2f_surf o = (v2f_surf)0;


//Curved World Compatibility
//V_CW_TransformPoint(v.vertex);
	

	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

	#ifdef V_WIRE_HAS_TEXTURE
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
		o.uv.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;
	#endif
	
	o.uv.zw = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
	o.uv.zw += _V_WIRE_WireTex_Scroll.xy * _Time.x;
	


	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

	o.custompack2 = ExtructWireframeFromVertexUV(v.texcoord);

	o.color = v.color;


	//DepthNormals
	o.nz.xyz = COMPUTE_VIEW_NORMAL;
	o.nz.w = COMPUTE_DEPTH_01;
	
	return o;				
}


//Pixel Shader///////////////////////////////////////////
fixed4 frag(v2f_surf i) : SV_Target
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



	//Dynamic Mask
	half dynamicMask = 1;
	#ifdef V_WIRE_DYNAMIC_MASK_ON	
		dynamicMask = V_WIRE_DynamicMask(i.worldPos);
				
		#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
			half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

			#ifdef V_WIRE_CUTOUT
				retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
			#else
				retColor.a *= maskMainTexA;
			#endif
		#endif
	#endif


	float fixedSize = distance(_WorldSpaceCameraPos, i.worldPos);
	float distanceFade = (_V_WIRE_DistanceFadeEnd - fixedSize) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);


	 
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

			half clipValue = DoWire(wireTexColor, retColor, i.custompack2, saturate(distanceFade), fixedSize, dynamicMask, customAlpha, _Cutoff, wireEmission);
			 

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

			#ifdef V_WIRE_MULTIPLY
				retColor.rgb = lerp(1, retColor.rgb, retColor.a);
			#endif

			#ifdef V_WIRE_ADDATIVE
				retColor.rgb = lerp(0, retColor.rgb, retColor.a);
			#endif
			
				
			DoWire(wireTexColor, retColor, i.custompack2, saturate(distanceFade), fixedSize, dynamicMask, wireEmission);
		#endif


	#else

		#ifdef V_WIRE_CUTOUT
			clip(retColor.a - _Cutoff);
		#endif

	#endif




	return EncodeDepthNormal(i.nz.w, i.nz.xyz);
} 


#endif
