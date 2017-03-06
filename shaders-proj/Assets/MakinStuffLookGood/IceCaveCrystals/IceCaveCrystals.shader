Shader "MakinStuffLookGood/IceCaveCrystals"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags 
		{ 
			"Queue"="Transparent" 
			"PreviewType" = "Plane"
		}

		Pass
		{
			ZWrite Off
			Cull Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			uniform sampler2D _GlobalRefractionTex;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				half4 color : COLOR;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				half4 color : COLOR;
				float2 screenuv : TEXCOORD1;
			};

			// sampler2D _MainTex;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				o.screenuv = ((o.vertex.xy / o.vertex.w) + 1) * 0.5f;
				o.color = v.color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// fixed4 col = tex2D(_MainTex, i.uv) * i.color;
				// return tex2D(_GlobalRefractionTex, i.screenuv);
				return float4(1, 1, 1, 1);
			}
			ENDCG
		}
	}
}
