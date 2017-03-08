Shader "MakinStuffLookGood/OverDraw"
{
	Properties
	{
		_OverDrawColor ("Color", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags 
		{
			 "RenderType"="Transparent"
			 "Queue" = "Transparent"
		}
		ZWrite Off
		ZTest Always
		Blend One One

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			float4 _OverDrawColor;

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _OverDrawColor;
			}
			ENDCG
		}
	}
}
