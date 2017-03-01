Shader "AlanZucconi/VolumetricRendering1"
{
	Properties
	{
		_Centre ("Centre", Float) = 0
		_Radius ("Radius", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			float _Centre;
			float _Radius;

			struct v2f
			{
				float3 worldPos : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			#define STEPS 64
			#define STEP_SIZE 0.01

			bool sphereHit(float3 p) {
				return distance(p, _Centre) < _Radius;
			}

			bool raymarchHit(float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++) {
					if (sphereHit(position)) {
						return true;
					}

					position += direction * STEP_SIZE;
				}
				return false;
			}

			v2f vert (appdata_full v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float3 worldPosition = i.worldPos;
				float3 viewDirection = normalize(worldPosition - _WorldSpaceCameraPos);
				if (raymarchHit(worldPosition, viewDirection))
					return fixed4(1,0,0,1); // red if hit the ball
				else
					return fixed4(1,1,1,1); // white otherwise
			}

			ENDCG
		}
	}
}
