#ifndef VACUUM_WIREFRAME_STANDRAD_CGINC
#define VACUUM_WIREFRAME_STANDRAD_CGINC


#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


inline void SetupWireframe(float3 mass, float2 wireTexUV, float3 worldPos, float3 worldNormal, inout float3 dstColor, inout float alpha, out float3 emission)
{
	fixed4 wireTexColor = tex2D(_V_WIRE_WireTex, wireTexUV);

	
	
	//Transparency
	#ifdef V_WIRE_TRANSPARENCY_ON 
		half customAlpha = wireTexColor.a;

		customAlpha = lerp(customAlpha, 1 - customAlpha, _V_WIRE_TransparentTex_Invert);

		customAlpha = saturate(customAlpha + _V_WIRE_TransparentTex_Alpha_Offset);

		_V_WIRE_Color.a *= customAlpha;
	#endif

	//Fresnel
	#ifdef V_WIRE_FRESNEL_ON

		fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));

		half fresnel = saturate(dot(worldViewDir, worldNormal));

		half wFresnel = saturate(fresnel + _V_WIRE_FresnelBias);
		wFresnel = lerp(wFresnel, 1 - wFresnel, _V_WIRE_FresnelInvert);

		wFresnel = pow(wFresnel, _V_WIRE_FresnelPow);

		_V_WIRE_Color.a *= wFresnel;
	#endif 

	//Dynamic Mask
	half dynamicMask = 1;
	#ifdef V_WIRE_DYNAMIC_MASK_ON
		dynamicMask = V_WIRE_DynamicMask(worldPos);

		#ifdef V_WIRE_DYNAMIC_MASK_BASE_TEX_ON
			
			#ifdef _ALPHATEST_ON
				half maskMainTexA = lerp(1 - 2 * dynamicMask, 2 * dynamicMask - 1, _V_WIRE_DynamicMaskEffectsBaseTexInvert);
		
				clip(maskMainTexA);
			#endif

			#ifdef _ALPHABLEND_ON
				alpha *= lerp(1 - dynamicMask, dynamicMask, _V_WIRE_DynamicMaskEffectsBaseTexInvert);
			#endif  
			
		#endif
	#endif  
		


	float fixedSize = distance(_WorldSpaceCameraPos, worldPos);
	half4 retColor = dstColor.rgbb; 

	float distanceFade = (_V_WIRE_DistanceFadeEnd - distance(_WorldSpaceCameraPos, worldPos)) / (_V_WIRE_DistanceFadeEnd - _V_WIRE_DistanceFadeStart);
	
	WireOpaque(wireTexColor, retColor, mass, max(0, distanceFade), fixedSize, dynamicMask, emission);
	dstColor = retColor.rgb;
}


#endif
