Shader "Hidden/VacuumShaders/The Amazing Wireframe/TextureExporter"
{
	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		Cull Off
		ZWrite Off
		//Blend SrcAlpha One
		Blend SrcAlpha OneMinusSrcAlpha
		

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma target 3.0
			#include "UnityCG.cginc"

			#include "Assets/VacuumShaders/The Amazing Wireframe Shader/Shaders/cginc/Wireframe_Core.cginc"


            struct vertOut 
			{ 
                float4 pos : SV_POSITION;
                
				fixed3 mass : TEXCOORD0;
            };

            vertOut vert(appdata_full v)
			{
                vertOut o;
                o.pos = mul(UNITY_MATRIX_MVP, fixed4(clamp(v.texcoord.xy, 0, 1), 0, 1));
                
				o.mass = ExtructWireframeFromVertexUV(v.texcoord);

                return o;
            }

            fixed4 frag(vertOut i) : SV_Target 
			{
				_V_WIRE_FixedSize = 0;

				return 1 - ExtructWireframeFromMass(i.mass, 1);
            }

            ENDCG
        }
    }
}