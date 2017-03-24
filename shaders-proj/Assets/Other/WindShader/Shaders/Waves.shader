Shader "Taras/Waves"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_WaveLength ("Wave Length", Float) = 1
		_Amplitude ("Amplitude", Float) = 1
		_Speed ("Speed", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float _WaveLength;
			float _Amplitude;
			float _Speed;

			v2f vert (appdata v)
			{
				v2f o;

				float4 wPos = mul(unity_ObjectToWorld, v.vertex);
				float factor = sin(_Time.y * _Speed
				 		 + v.uv.x * _WaveLength
				 		 + v.uv.y * _WaveLength);

				v.vertex = float4(
					v.vertex.x, //+ (v.normal.x * factor * _Amplitude),
					v.vertex.y + (factor * _Amplitude),
					v.vertex.z, //+ (v.normal.z * factor * _Amplitude),
					v.vertex.a);

				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}
