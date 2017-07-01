Shader "Hidden/VacuumShaders/The Amazing Wireframe/TextureExporter GL"
{
	SubShader
	{
		Cull Off
		ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag


            float4 vert(float4 uv : TEXCOORD3) : SV_POSITION
			{
                return mul(UNITY_MATRIX_MVP, fixed4(uv.xy, 0, 1));
            }

            fixed4 frag() : SV_Target 
			{
				return 1;
            }

            ENDCG
        }
    }
}