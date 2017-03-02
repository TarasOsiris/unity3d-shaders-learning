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

			fixed4 raymarch(float3 wPos, float3 viewDir)
			{
				
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
