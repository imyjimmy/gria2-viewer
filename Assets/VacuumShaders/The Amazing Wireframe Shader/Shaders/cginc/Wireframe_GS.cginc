#ifndef VACUUM_WIREFRAME_GS_CGINC
#define VACUUM_WIREFRAME_GS_CGINC

[maxvertexcount(3)]
void geom(triangle v2f_surf input[3], inout TriangleStream<v2f_surf> triStream)
{
	
#ifdef V_WIRE_TRY_QUAD_ON

	#if defined(V_WIRE_ADDATIVE) || defined(V_WIRE_MULTIPLY)
		float e1 = length(input[0].worldPos - input[1].worldPos);
		float e2 = length(input[1].worldPos - input[2].worldPos);
		float e3 = length(input[2].worldPos - input[0].worldPos);

		input[0].worldPos = mul(UNITY_MATRIX_MVP, float4(input[0].worldPos, 1)).xyz;
		input[1].worldPos = mul(UNITY_MATRIX_MVP, float4(input[1].worldPos, 1)).xyz;
		input[2].worldPos = mul(UNITY_MATRIX_MVP, float4(input[2].worldPos, 1)).xyz;
	#else
		float e1 = length(input[0].objectPos - input[1].objectPos);
		float e2 = length(input[1].objectPos - input[2].objectPos);
		float e3 = length(input[2].objectPos - input[0].objectPos);
	#endif

	float3 quad = 0;
	if (e1 > e2 && e1 > e3)
		quad.y = 1.;
	else if (e2 > e3 && e2 > e1)
		quad.x = 1;
	else
		quad.z = 1;
	
	input[0].custompack2.xyz = fixed3(1, 0, 0) + quad;
	input[1].custompack2.xyz = fixed3(0, 0, 1) + quad;
	input[2].custompack2.xyz = fixed3(0, 1, 0) + quad;

#else
	
	input[0].custompack2.xyz = fixed3(1, 0, 0);
	input[1].custompack2.xyz = fixed3(0, 1, 0);
	input[2].custompack2.xyz = fixed3(0, 0, 1);

#endif
	
	triStream.Append(input[0]);
	triStream.Append(input[1]);
	triStream.Append(input[2]);

	triStream.RestartStrip();
}

#endif
