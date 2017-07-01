#ifndef VACUUM_WIREFRAME_FORWARDBASE_CGINC
#define VACUUM_WIREFRAME_FORWARDBASE_CGINC

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


#ifdef _NORMALMAP
	#define V_WIRE_LIGHTDIR i.lightDir
#else
	#define V_WIRE_LIGHTDIR _WorldSpaceLightPos0.xyz
#endif

#if defined(V_WIRE_REFLECTION_CUBE_SIMPLE) || defined(V_WIRE_REFLECTION_CUBE_ADVANED) || defined(V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES)
	#define V_WIRE_REFLECTION_ON
#endif

//not enough registers
#if defined(V_WIRE_REFLECTION_ON) && defined(_NORMALMAP) 
	#ifdef V_WIRE_SPECULAR
	#undef V_WIRE_SPECULAR
	#endif
#endif

//Variables//////////////////////////////////
fixed4 _Color;
float _V_WIRE_VertexColor;
#ifdef V_WIRE_HAS_TEXTURE
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_WIRE_MainTex_Scroll;
#endif

#ifdef _NORMALMAP
	sampler2D _V_WIRE_NormalMap;
#endif

#ifdef V_WIRE_SPECULAR
	sampler2D _V_WIRE_Specular_Lookup;
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

#ifdef V_WIRE_CUTOUT
	half _Cutoff; 
#endif

//Struct/////////////////////////////////////////////////////////
struct vInput
{
    float4 vertex : POSITION;

	half4 texcoord : TEXCOORD0;
	half4 texcoord1 : TEXCOORD1;

	half3 normal : NORMAL;
	half4 tangent : TANGENT;

	fixed4 color : COLOR;
};

struct vOutput
{
	float4 pos :SV_POSITION;

	half4 uv : TEXCOORD0;	//xy - mainTex, zw - wireTex

			
	half4 worldPos : TEXCOORD1;	//xyz - worldPos, w - fixedSizeCoord

			
	half4 normal : TEXCOORD2;	//xyz - normal, w - fresnel
	

	#ifdef V_WIRE_REFLECTION_ON
		half4 refl : TEXCOORD3; //xyz - reflection, w - fresnel	
	#endif

	fixed4 vColor : TEXCOORD4;

	
	float4 mass : TEXCOORD5;   //xyz - mass, w - fadeCoord


	UNITY_FOG_COORDS(6)	
		

	#ifndef LIGHTMAP_OFF
		half2 lm : TEXCOORD7;
	#else
		half4 vLight : TEXCOORD7;

		#ifdef V_WIRE_SPECULAR
			half4 viewDir : TEXCOORD8;	//xyz - viewdir, w - specular(nh)
		#endif

		#ifdef _NORMALMAP
			half3 lightDir : TEXCOORD9;
		#endif	

		SHADOW_COORDS(10)
	#endif
};

//Vertex Shader///////////////////////////////////////////
vOutput vert(vInput v)
{ 
	vOutput o = (vOutput)0;	
	

//Curved World Compatibility
#ifdef V_CURVEDWORLD_COMPATIBILITY_ON
	#ifndef LIGHTMAP_OFF
//V_CW_TransformPoint(v.vertex);
	#else
//V_CW_TransformPointAndNormal(v.vertex, v.normal, v.tangent);
	#endif
#endif


	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

	#ifdef V_WIRE_HAS_TEXTURE
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
		o.uv.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;
	#endif

	o.uv.zw = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
	o.uv.zw += _V_WIRE_WireTex_Scroll.xy * _Time.x;


	#if defined(V_WIRE_DYNAMIC_MASK_ON) || defined(V_WIRE_REFLECTION_ON)
		half3 worldPos = mul(unity_ObjectToWorld, half4(v.vertex.xyz, 1)).xyz;
	#endif

	float3 normal_WS = UnityObjectToWorldNormal(v.normal);

	#if defined(V_WIRE_REFLECTION_ON) || defined(V_WIRE_FRESNEL_ON)
		half fresnel = dot (normalize(ObjSpaceViewDir(v.vertex).xyz), v.normal);
	#endif


	#ifdef V_WIRE_DYNAMIC_MASK_ON		
		o.worldPos.xyz = worldPos;
	#endif

	#ifdef V_WIRE_FRESNEL_ON
		o.normal.w = saturate(fresnel + _V_WIRE_FresnelBias);

		o.normal.w = lerp(o.normal.w, 1 - o.normal.w, _V_WIRE_FresnelInvert);

		o.normal.w *= o.normal.w * o.normal.w;
		o.normal.w *= o.normal.w * o.normal.w;
	#endif


	#ifdef V_WIRE_REFLECTION_ON
		half3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
		o.refl.xyz = reflect( -worldViewDir, normal_WS );		
		
		o.refl.w = 1 - saturate(fresnel + _V_WIRE_Reflection_Fresnel_Bias);
		o.refl.w *= o.refl.w;
		o.refl.w *= o.refl.w;
	#endif


	o.vColor = v.color;


	//Fog
	UNITY_TRANSFER_FOG(o, o.pos);

	#ifndef V_WIRE_NO
		o.mass.xyz = ExtructWireframeFromVertexUV(v.texcoord);

		o.worldPos.w = distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex));

		o.mass.w = (_V_WIRE_DistanceFadeEnd - o.worldPos.w) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);
	#endif

	
	
	#ifndef LIGHTMAP_OFF
		o.lm = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	#else
		
		#ifdef UNITY_SHOULD_SAMPLE_SH
			o.vLight.rgb = ShadeSH9 (half4(normal_WS, 1.0));
				
			#ifdef VERTEXLIGHT_ON	
				float3 pos_WS = mul(unity_ObjectToWorld, v.vertex).xyz;
			
				o.vLight.rgb += Shade4PointLights ( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
				 								   unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
												   unity_4LightAtten0, pos_WS, normal_WS );
			#endif
		#endif


		#ifdef _NORMALMAP
			TANGENT_SPACE_ROTATION;

			o.lightDir = normalize(mul (rotation, ObjSpaceLightDir(v.vertex)));

			#ifdef V_WIRE_SPECULAR
				o.viewDir.xyz = mul (rotation, normalize(ObjSpaceViewDir(v.vertex)));
			#endif
		#else
			#ifdef V_WIRE_SPECULAR
				o.viewDir.xyz = WorldSpaceViewDir(v.vertex);
			#endif
		#endif
	#endif

	o.normal.xyz = normal_WS;

	#ifdef LIGHTMAP_OFF
		TRANSFER_VERTEX_TO_FRAGMENT(o);
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
	retColor.rgb *= lerp(1, i.vColor, _V_WIRE_VertexColor);


	//Dynamic Mask
	half dynamicMask = 1;
	#ifdef V_WIRE_DYNAMIC_MASK_ON	
		dynamicMask = V_WIRE_DynamicMask(i.worldPos.xyz);

					
		#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
			half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

			#ifdef V_WIRE_CUTOUT
				retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
			#else
				retColor.a *= maskMainTexA;
			#endif
		#endif
	#endif

	
	#ifdef _NORMALMAP
		fixed3 bumpNormal = UnpackNormal(tex2D(_V_WIRE_NormalMap, i.uv.xy));
	#endif
	
	#ifndef LIGHTMAP_OFF
		fixed3 diff = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lm));
		retColor.rgb *= diff;
	#else
		fixed atten = LIGHT_ATTENUATION(i);

		#ifdef _NORMALMAP
			half3 normal = bumpNormal;				
		#else
			half3 normal = normalize(i.normal.xyz);
		#endif
		
		fixed3 diff = _LightColor0.rgb * atten;

		#ifdef V_WIRE_USE_LIGHT_RAMP_TEXTURE
			fixed2 rampUV = fixed2(max(0, dot(normal, V_WIRE_LIGHTDIR)), 0.5);
			diff *= tex2D(_V_WIRE_LightRampTex, rampUV);
		#else
			diff *= max(0, dot(normal, V_WIRE_LIGHTDIR));
		#endif
				
		diff += i.vLight.rgb;

						

		retColor.rgb *= diff;


		#ifdef V_WIRE_SPECULAR
			half nh = max (0, dot (normal, normalize (V_WIRE_LIGHTDIR + normalize(i.viewDir.xyz))));
			fixed3 specular = tex2D(_V_WIRE_Specular_Lookup, half2(nh, 0.5)).rgb * retColor.a * _LightColor0.rgb * atten;

			retColor.rgb += specular;
		#endif
	#endif		
				



	#ifdef V_WIRE_LIGHT_ON
		_V_WIRE_Color.rgb = diff * _V_WIRE_Color.rgb; 
	#endif
				
	 
	//Reflection
	#ifdef V_WIRE_REFLECTION_ON

		#ifdef _NORMALMAP
			i.refl.xyz += bumpNormal * 0.25;
		#endif

		#if defined(V_WIRE_REFLECTION_CUBE_SIMPLE)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE( _Cube, i.refl.xyz ) * _ReflectColor;
		#elif defined(V_WIRE_REFLECTION_CUBE_ADVANED)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD( _Cube, i.refl.xyz, _V_WIRE_Reflection_Roughness * 10) * _ReflectColor;
		#elif defined(V_WIRE_REFLECTION_UNITY_REFLECTION_PROBES)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, i.refl.xyz, _V_WIRE_Reflection_Roughness * 10) * _ReflectColor;
			reflTex.xyz = DecodeHDR(reflTex, unity_SpecCube0_HDR);
		#else
			fixed4 reflTex = _ReflectColor;
		#endif
		

		#ifdef V_WIRE_HAS_TEXTURE
			retColor.rgb = lerp(retColor.rgb, retColor.rgb + reflTex.rgb, saturate(mainTex.a + _V_WIRE_Reflection_Strength * 2 - 1) *  i.refl.w);
		#else
			retColor.rgb = lerp(retColor.rgb, retColor.rgb + reflTex.rgb, _V_WIRE_Reflection_Strength *  i.refl.w);
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

			half clipValue = DoWire(wireTexColor, retColor, i.mass.xyz, saturate(i.mass.w), i.worldPos.w, dynamicMask, customAlpha, _Cutoff, wireEmission);


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

			

			#ifdef V_WIRE_FRESNEL_ON
				_V_WIRE_Color.a *= i.normal.w;  
			#endif	
							
			DoWire(wireTexColor, retColor, i.mass.xyz, saturate(i.mass.w), i.worldPos.w, dynamicMask, wireEmission);
			
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
