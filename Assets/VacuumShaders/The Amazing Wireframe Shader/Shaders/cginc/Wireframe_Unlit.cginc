#ifndef VACUUM_WIREFRAME_UNLIT_CGINC
#define VACUUM_WIREFRAME_UNLIT_CGINC

#include  "UnityCG.cginc"   
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"

 
#if defined(V_WIRE_REFLECTION_CUBE_SIMPLE) || defined(V_WIRE_REFLECTION_CUBE_ADVANED) || defined(V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES)
	#define V_WIRE_REFLECTION_ON
#endif

//Variables//////////////////////////////////
fixed4 _Color;
float _V_WIRE_VertexColor;
#ifdef V_WIRE_HAS_TEXTURE
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_WIRE_MainTex_Scroll;
#endif

#ifdef V_WIRE_REFLECTION_ON

	fixed4 _ReflectColor;
	half _V_WIRE_Reflection_Strength;
	half _V_WIRE_Reflection_Fresnel_Bias;

	#if defined(V_WIRE_REFLECTION_CUBE_SIMPLE) || defined(V_WIRE_REFLECTION_CUBE_ADVANED)
		UNITY_DECLARE_TEXCUBE(_Cube);
	#endif

	#if defined(V_WIRE_REFLECTION_CUBE_ADVANED) || defined(V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES)
		half _V_WIRE_Reflection_Roughness;
	#endif
#endif

#ifdef V_WIRE_IBL_ON
	samplerCUBE _V_WIRE_IBL_Cube;
	fixed _V_WIRE_IBL_Cube_Intensity;
	fixed _V_WIRE_IBL_Cube_Contrast;		
	fixed _V_WIRE_IBL_Light_Strength;
#endif

#ifdef V_WIRE_CUTOUT
	half _Cutoff; 
#endif

//Struct/////////////////////////////////////////////////////////
struct vInput
{
    float4 vertex : POSITION;

	half4 texcoord : TEXCOORD0;
	half4 texcoord1 : TEXCOORD1;

	#if defined(V_WIRE_REFLECTION_ON) || defined(V_WIRE_IBL_ON) || defined(V_WIRE_FRESNEL_ON)
		half3 normal : NORMAL;
	#endif	

	fixed4 color : COLOR;
};

struct vOutput
{
	float4 pos :SV_POSITION;

	half4 uv : TEXCOORD0;	//xy - mainTex, zw - wireTex

			
	#ifdef V_WIRE_DYNAMIC_MASK_ON
		half3 maskPos : TEXCOORD1;
	#endif
		
	
	#if defined(V_WIRE_IBL_ON) || defined(V_WIRE_FRESNEL_ON)
		half4 normal : TEXCOORD2;	//xyz - normal, w - fresnel
	#endif
	

	#ifdef V_WIRE_REFLECTION_ON
		half4 refl : TEXCOORD3; //xyz - reflection, w - fresnel	
	#endif

	fixed4 vColor : TEXCOORD4;

	 
	fixed3 mass : TEXCOORD5;   

	float2 data : TEXCOORD6;	//x - fadeCoord, y - fixedSizeCoord

	UNITY_FOG_COORDS(7)	
}; 


//Vertex Shader///////////////////////////////////////////
vOutput vert(vInput v)
{ 
	vOutput o = (vOutput)0;	


//Curved World Compatibility
//V_CW_TransformPoint(v.vertex);
	

	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

	#ifdef V_WIRE_HAS_TEXTURE
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
		o.uv.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;
	#endif
	
	o.uv.zw = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
	o.uv.zw += _V_WIRE_WireTex_Scroll.xy * _Time.x;
	


	half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

	#if defined(V_WIRE_IBL_ON) || defined(V_WIRE_REFLECTION_ON)
		half3 worldNormal = UnityObjectToWorldNormal(v.normal);
	#endif

	#if defined(V_WIRE_REFLECTION_ON) || defined(V_WIRE_FRESNEL_ON)
		half fresnel = dot (normalize(ObjSpaceViewDir(v.vertex).xyz), v.normal);
	#endif


	#ifdef V_WIRE_DYNAMIC_MASK_ON		
		o.maskPos = worldPos;
	#endif

	#if defined(V_WIRE_IBL_ON)
		o.normal.xyz = worldNormal;
	#endif

	#ifdef V_WIRE_FRESNEL_ON
		o.normal.w = saturate(fresnel + _V_WIRE_FresnelBias);

		o.normal.w = lerp(o.normal.w, 1 - o.normal.w, _V_WIRE_FresnelInvert);

		o.normal.w *= o.normal.w * o.normal.w;
		o.normal.w *= o.normal.w * o.normal.w;
	#endif


	#ifdef V_WIRE_REFLECTION_ON
		half3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
		o.refl.xyz = reflect( -worldViewDir, worldNormal );		
		
		o.refl.w = 1 - saturate(fresnel + _V_WIRE_Reflection_Fresnel_Bias);
		o.refl.w *= o.refl.w;
		o.refl.w *= o.refl.w;
	#endif 
		  

	o.vColor = v.color;
	
	//Fog
	UNITY_TRANSFER_FOG(o, o.pos);

	#ifndef V_WIRE_NO
		o.mass = ExtructWireframeFromVertexUV(v.texcoord);

		o.data.y = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));

		o.data.x = (_V_WIRE_DistanceFadeEnd - o.data.y) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);
	#endif
	
	return o;				
}


//Pixel Shader///////////////////////////////////////////
fixed4 frag(vOutput i) : SV_Target 
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
	retColor.rgb *= lerp(1, i.vColor.rgb, _V_WIRE_VertexColor);



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



	//IBL
	#ifdef V_WIRE_IBL_ON
		fixed3 ibl = ((texCUBE(_V_WIRE_IBL_Cube, i.normal.xyz).rgb - 0.5) * _V_WIRE_IBL_Cube_Contrast + 0.5) * _V_WIRE_IBL_Cube_Intensity;
					
		retColor.rgb *= (_V_WIRE_IBL_Light_Strength + ibl);

		retColor.rgb = saturate(retColor.rgb);
	#endif
			
	 
	//Reflection
	#ifdef V_WIRE_REFLECTION_ON
		#if defined(V_WIRE_REFLECTION_CUBE_SIMPLE)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE( _Cube, i.refl.xyz ) * _ReflectColor;
		#elif defined(V_WIRE_REFLECTION_CUBE_ADVANED)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD( _Cube, i.refl.xyz, _V_WIRE_Reflection_Roughness * 10) * _ReflectColor;
		#elif defined(V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, i.refl.xyz, _V_WIRE_Reflection_Roughness * 10) * _ReflectColor;
		#else
			fixed4 reflTex = _ReflectColor;
		#endif
		

		#ifdef V_WIRE_HAS_TEXTURE
			retColor.rgb = lerp(retColor.rgb, reflTex.rgb, saturate(mainTex.a + _V_WIRE_Reflection_Strength * 2 - 1) *  i.refl.w);
		#else
			retColor.rgb = lerp(retColor.rgb, reflTex.rgb, _V_WIRE_Reflection_Strength *  i.refl.w);
		#endif
	#endif

	 
	//Wire
	#ifndef V_WIRE_NO
		
		fixed4 wireTexColor = tex2D(_V_WIRE_WireTex, i.uv.zw);
		wireTexColor.rgb *= lerp(1, i.vColor.rgb, _V_WIRE_WireVertexColor);

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

			#ifdef V_WIRE_MULTIPLY
				retColor.rgb = lerp(1, retColor.rgb, retColor.a);
			#endif

			#ifdef V_WIRE_ADDATIVE
				retColor.rgb = lerp(0, retColor.rgb, retColor.a);
			#endif
			

			#ifdef V_WIRE_FRESNEL_ON
				_V_WIRE_Color.a *= i.normal.w;
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
	#if defined(V_WIRE_ADDATIVE)
		UNITY_APPLY_FOG_COLOR(i.fogCoord, retColor, fixed4(0,0,0,0)); // fog towards black due to our blend mode
	#elif defined(V_WIRE_MULTIPLY)
		UNITY_APPLY_FOG_COLOR(i.fogCoord, retColor, fixed4(1,1,1,1)); // fog towards white due to our blend mode
	#else
		UNITY_APPLY_FOG(i.fogCoord, retColor);
	#endif

	//Alpha
	#if !defined(V_WIRE_CUTOUT) && !defined(V_WIRE_TRANSPARENT)
		UNITY_OPAQUE_ALPHA(retColor.a);
	#endif

	return retColor;
} 


#endif
