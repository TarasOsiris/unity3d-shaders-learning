Shader "AlanZucconi/VolumetricRendering2"
{
	Properties
	{
		_Centre ("Centre", Float) = 0
		_Radius ("Radius", Float) = 1
	}
	SubShader
	{
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off

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
			#define MIN_DISTANCE 0.01

			float sphereDistance(float3 p) 
			{
				return distance(p, _Centre) - _Radius;
			}

			fixed4 raymarch(float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++)
				{
					float distance = sphereDistance(position);
					if (distance < 0.0001) // inside the sphere
						return i / (float) STEPS;
			
					position += distance * direction;
				}

				return 1; // White
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
				return raymarch(worldPosition, viewDirection);
			}

			ENDCG
		}
	}
}
