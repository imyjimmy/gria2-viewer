#ifndef VACUUM_WIREFRAME_SHADOW_CGINC
#define VACUUM_WIREFRAME_SHADOW_CGINC


//Variables//////////////////////////////////

#ifdef V_WIRE_CUTOUT
	half _Cutoff; 

	fixed4 _Color;
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_WIRE_MainTex_Scroll;
#endif

#include "UnityCG.cginc"
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


////////////////////////////////////////////////////////////////////////////
//																		  //
//Struct    															  //
//																		  //
////////////////////////////////////////////////////////////////////////////
struct v2f_surf
{ 
	V2F_SHADOW_CASTER;	
			
	half3 custompack2 : TEXCOORD1;

	#ifdef V_WIRE_CUTOUT
		float4 uv : TEXCOORD2;			

		float2 data : TEXCOORD3; //x - fadeCoord, y - fixedSizeCoord
		

		#ifdef V_WIRE_DYNAMIC_MASK_ON
			half3 maskPos : TEXCOORD4;
		#endif
	#endif

	float3 objectPos : TEXCOORD5;
};

 
////////////////////////////////////////////////////////////////////////////
//																		  //
//Vertex    															  //
//																		  //
////////////////////////////////////////////////////////////z////////////////
v2f_surf vert_surf( appdata_full v )
{
	v2f_surf o = (v2f_surf)0;
	

//Curved World Compatibility
//V_CW_TransformPointAndNormal(v.vertex, v.normal, v.tangent);


	o.objectPos = v.vertex.xyz;

	#ifdef V_WIRE_CUTOUT
		o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
		o.uv.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;

		o.uv.zw = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
		o.uv.zw += _V_WIRE_WireTex_Scroll.xy * _Time.x;

		o.custompack2 = ExtructWireframeFromVertexUV(v.texcoord);

		o.data.y = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));

		o.data.x = (_V_WIRE_DistanceFadeEnd - o.data.y) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);
		
		

		#ifdef V_WIRE_DYNAMIC_MASK_ON		
			o.maskPos = mul(unity_ObjectToWorld, half4(v.vertex.xyz, 1)).xyz;
		#endif
	#endif

	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
	return o;
}

////////////////////////////////////////////////////////////////////////////
//																		  //
//Fragment    															  //
//																		  //
////////////////////////////////////////////////////////////////////////////
float4 frag(v2f_surf i ) : SV_Target
{
	#ifdef V_WIRE_CUTOUT

		#if defined(V_WIRE_NO_COLOR_BLACK)
			fixed4 retColor = 0;
		#elif defined(V_WIRE_NO_COLOR_WHITE)
			fixed4 retColor = 1;
		#else
			fixed4 retColor = tex2D (_MainTex, i.uv.xy) * _Color;	
		#endif	

							
		//Dynamic Mask
		half dynamicMask = 1;
		#ifdef V_WIRE_DYNAMIC_MASK_ON	
			dynamicMask = V_WIRE_DynamicMask(i.maskPos);
					  
				 
			#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
				half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);
						 
				retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
			#endif  
		#endif  
					 
		half customAlpha = 1;
		#ifdef V_WIRE_TRANSPARENCY_ON
			customAlpha = tex2D(_V_WIRE_WireTex, i.uv.zw).a;
					
			customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);

			customAlpha = (customAlpha + _V_WIRE_TransparentTex_Alpha_Offset) < 0.01 ? 0 : 1;
		#endif

		fixed3 wireEmission = 0;
		half clipValue = DoWire(1, retColor, i.custompack2, saturate(i.data.x), i.data.y, dynamicMask, customAlpha, _Cutoff, wireEmission);


		#ifdef V_WIRE_CUTOUT_HALF
			clip(clipValue - 0.5);
		#else
			clip(clipValue); 
		#endif
	#endif

	SHADOW_CASTER_FRAGMENT(i)
}
#endif 
