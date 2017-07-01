#ifndef VACUUM_WIREFRAME_PBR_CGINC
#define VACUUM_WIREFRAME_PBR_CGINC

  
#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"

#ifdef UNITY_PASS_META
	#ifndef V_WIRE_LIGHT_ON
	#define V_WIRE_LIGHT_ON
	#endif
#endif

//Variables//////////////////////////////////
fixed4 _Color;
float _V_WIRE_VertexColor;
sampler2D _MainTex;
half4 _MainTex_ST;
half2 _V_WIRE_MainTex_Scroll;

half _Glossiness;
half _Metallic;

half _V_WIRE_Ao;
half _V_WIRE_AoStrength; 
sampler2D _V_WIRE_AoMap;

#ifdef _NORMALMAP
	half _V_WIRE_NormalScale;
	sampler2D _V_WIRE_NormalMap;
#endif


#ifdef V_WIRE_CUTOUT 
	half _Cutoff;
#endif
	 


//Struct/////////////////////////////////////////////////////////
struct Input 
{
	float4 texcoord; // xy - uv, zw - worldNormal.xy (worldNormal.z inside 'mass.w')
		
	float4 texcoord1;	//xy - wireTex coord, z - fadeCoord
	 
	half3 worldPos;

	half4 mass; //xyz - mass, w - worldNormal.z

	half4 color : COLOR;
};

//Vertex Shader///////////////////////////////////////////
void vert (inout appdata_full v, out Input o) 
{
	UNITY_INITIALIZE_OUTPUT(Input,o);	


//Curved World Compatibility
//V_CW_TransformPointAndNormal(v.vertex, v.normal, v.tangent);


	o.texcoord.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
	o.texcoord.xy += _V_WIRE_MainTex_Scroll.xy * _Time.x;

	o.texcoord1.xy = TRANSFORM_TEX(((_V_WIRE_WireTex_UVSet == 0) ? v.texcoord.xy : v.texcoord1.xy), _V_WIRE_WireTex);
	o.texcoord1.xy += _V_WIRE_WireTex_Scroll.xy * _Time.x;

	#ifdef V_WIRE_FRESNEL_ON
		fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
		o.texcoord.zw = worldNormal.xy;
		o.mass.w = worldNormal.z;
	#endif

	#ifndef V_WIRE_NO
		o.mass.xyz = ExtructWireframeFromVertexUV(v.texcoord);

		o.texcoord1.z = (_V_WIRE_DistanceFadeEnd - distance(_WorldSpaceCameraPos, mul(unity_ObjectToWorld, v.vertex))) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);
	#else
		o.mass.xyz = 0;
	#endif
}



//Pixel Shader///////////////////////////////////////////
void surf (Input IN, inout SurfaceOutputStandard o) 
{

#ifdef UNITY_PASS_META
	IN.worldPos += _V_WIRE_ObjectWorldPos;
#endif


	half4 mainTex = tex2D (_MainTex, IN.texcoord.xy);

	//Color
	#if defined(V_WIRE_NO_COLOR_BLACK)
		fixed4 retColor = 0;
	#elif defined(V_WIRE_NO_COLOR_WHITE)
		fixed4 retColor = 1;
	#else
		fixed4 retColor = mainTex * _Color;
	#endif	

	retColor.rgb *= lerp(1, IN.color.rgb, _V_WIRE_VertexColor);
	
	#if defined(_NORMALMAP)
		o.Normal = UnpackNormal(tex2D(_V_WIRE_NormalMap, IN.texcoord.xy));
		o.Normal = normalize(o.Normal * float3(_V_WIRE_NormalScale, _V_WIRE_NormalScale, 1));
	#elif defined(_NORMALMAP_FAKE)
		o.Normal = fixed3(0, 0, 1);
	#endif

	
	// Metallic and smoothness come from slider variables
	o.Metallic = _Metallic;
	o.Smoothness = _Glossiness;
	 
	o.Occlusion = lerp(1, LerpOneTo(tex2D (_V_WIRE_AoMap, IN.texcoord.xy).g, _V_WIRE_AoStrength), _V_WIRE_Ao);
	 
	
	#ifdef V_WIRE_FRESNEL_ON		
		fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(IN.worldPos));
		
		half fresnel = saturate(dot (worldViewDir, fixed3(IN.texcoord.zw, IN.mass.w)));

		half wFresnel = saturate(fresnel + _V_WIRE_FresnelBias);
		wFresnel = lerp(wFresnel, 1 - wFresnel, _V_WIRE_FresnelInvert);
		
		wFresnel = pow(wFresnel, _V_WIRE_FresnelPow);

		_V_WIRE_Color.a *= wFresnel;
	#endif 

	 
	 
	#ifdef V_WIRE_NO

		#if defined(V_WIRE_CUTOUT)
		
			#ifdef V_WIRE_DYNAMIC_MASK_ON
				half dynamicMask = V_WIRE_DynamicMask(IN.worldPos);

				#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
					half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

					retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
				#endif
			#endif

			clip(retColor.a - _Cutoff);

		//Mask
		#elif defined(V_WIRE_DYNAMIC_MASK_ON)
			half dynamicMask = V_WIRE_DynamicMask(IN.worldPos);

			#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
				half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

				#ifdef V_WIRE_CUTOUT
					retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
				#else
					retColor.a *= maskMainTexA;
				#endif
			#endif
		#endif 

	#else 
		#ifdef V_WIRE_LIGHT_ON

			fixed4 wireTexColor = tex2D(_V_WIRE_WireTex, IN.texcoord1.xy);
			wireTexColor.rgb *= lerp(1, IN.color.rgb, _V_WIRE_WireVertexColor);

			float3 wireEmission = 0;

			#ifdef V_WIRE_CUTOUT

				half customAlpha = 1;
				#ifdef V_WIRE_TRANSPARENCY_ON
					customAlpha = wireTexColor.a;

					customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);

					customAlpha = (customAlpha + _V_WIRE_TransparentTex_Alpha_Offset) < 0.01 ? 0 : 1;
				#endif
				 
				half dynamicMask = 1;
				#ifdef V_WIRE_DYNAMIC_MASK_ON
					dynamicMask = V_WIRE_DynamicMask(IN.worldPos);

					#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
						half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

						retColor.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
					#endif
				#endif 

				float fixedSize = distance(_WorldSpaceCameraPos, IN.worldPos);

				half clipValue = DoWire(wireTexColor, retColor, IN.mass, saturate(IN.texcoord1.z), fixedSize, dynamicMask, customAlpha, _Cutoff, wireEmission);


				#ifdef V_WIRE_CUTOUT_HALF
					clip(clipValue - 0.5);
				#else
					clip(clipValue);
				#endif

			#else //V_WIRE_CUTOUT

				#ifdef V_WIRE_TRANSPARENCY_ON 
					half customAlpha = wireTexColor.a;

					customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);

					customAlpha = saturate(customAlpha + _V_WIRE_TransparentTex_Alpha_Offset);

					_V_WIRE_Color.a *= customAlpha;
				#endif
			
				//Mask 
				half dynamicMask = 1;
				#ifdef V_WIRE_DYNAMIC_MASK_ON
					dynamicMask = V_WIRE_DynamicMask(IN.worldPos);

					#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
						half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

						retColor.a *= maskMainTexA;
					#endif
				#endif 

				float fixedSize = distance(_WorldSpaceCameraPos, IN.worldPos);

				half value = DoWire(wireTexColor, retColor, IN.mass, saturate(IN.texcoord1.z), fixedSize, dynamicMask, wireEmission);


				#ifdef V_WIRE_DYNAMIC_MASK_ON
					#ifdef _NORMALMAP
						half3 newNormal = half3(o.Normal.x * value, o.Normal.y * value, o.Normal.z);
						o.Normal = lerp(o.Normal, normalize(newNormal), _V_WIRE_Color.a);
					#endif

					#ifdef V_WIRE_REFLECTION_ON
						o.Emission = lerp(o.Emission, o.Emission * value, _V_WIRE_Color.a);
					#endif
			 
					#ifdef V_WIRE_GLOSS
						o.Gloss *= lerp(o.Gloss, o.Gloss * value, _V_WIRE_Color.a);
					#endif			
				#endif

			#endif //V_WIRE_CUTOUT

			//Emission
			o.Emission = wireEmission;

		#endif //V_WIRE_LIGHT_ON
	#endif


	o.Albedo = retColor.rgb;
	o.Alpha = retColor.a;  
}

void WireFinalColor (Input IN, SurfaceOutputStandard o, inout fixed4 color)
{	
	#if !defined(V_WIRE_LIGHT_ON) && !defined(V_WIRE_NO) 

		fixed4 wireTexColor = tex2D(_V_WIRE_WireTex, IN.texcoord1.xy);
		wireTexColor.rgb *= lerp(1, IN.color.rgb, _V_WIRE_WireVertexColor);

		float3 wireEmission = 0;

		#ifdef V_WIRE_CUTOUT
			
			half customAlpha = 1;
			#ifdef V_WIRE_TRANSPARENCY_ON
				customAlpha = wireTexColor.a;

				customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);

				customAlpha = (customAlpha + _V_WIRE_TransparentTex_Alpha_Offset) < 0.01 ? 0 : 1;
			#endif
				 
			half dynamicMask = 1;
			#ifdef V_WIRE_DYNAMIC_MASK_ON
				dynamicMask = V_WIRE_DynamicMask(IN.worldPos);

				#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
					half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

					color.a = _Cutoff > 0.01 ? color.a * maskMainTexA : maskMainTexA;
				#endif
			#endif 
			
			float fixedSize = distance(_WorldSpaceCameraPos, IN.worldPos);

			#ifdef UNITY_PASS_FORWARDBASE
				half clipValue = DoWire(wireTexColor, color, IN.mass, saturate(IN.texcoord1.z), fixedSize, dynamicMask, customAlpha, _Cutoff, wireEmission);
			#else
				half clipValue = DoWire(0, color, IN.mass, saturate(IN.texcoord1.z), fixedSize, dynamicMask, customAlpha, _Cutoff, wireEmission);
			#endif


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
			
			half dynamicMask = 1;
			#ifdef V_WIRE_DYNAMIC_MASK_ON
				dynamicMask = V_WIRE_DynamicMask(IN.worldPos);

				#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
					half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);

					#ifdef V_WIRE_CUTOUT
						color.a = _Cutoff > 0.01 ? retColor.a * maskMainTexA : maskMainTexA;
					#else
						color.a *= maskMainTexA;
					#endif
				#endif
			#endif

			float fixedSize = distance(_WorldSpaceCameraPos, IN.worldPos);
			#ifdef UNITY_PASS_FORWARDBASE
				DoWire(wireTexColor, color, IN.mass, saturate(IN.texcoord1.z), fixedSize, dynamicMask, wireEmission);
			#else 
				DoWire(0, color, IN.mass, saturate(IN.texcoord1.z), fixedSize, dynamicMask, wireEmission);
			#endif
		#endif

		color.rgb += wireEmission;
	#endif


	//Fog
#if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
	float fogCoord = mul(UNITY_MATRIX_VP, float4(IN.worldPos.xyz, 1)).z;
	UNITY_APPLY_FOG(fogCoord, color);
#endif
	
} 



#endif
