Shader "Custom/Flow Map"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		// Flow
		_FlowMap ("Flow Map", 2D) = "white" {}
		_FlowSpeed ("Flow Speed", float) = 0.05

		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _ PIXELSNAP_ON
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
			};
			
			fixed4 _Color;

			v2f vert(appdata_t IN)
			{
				v2f OUT;

				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _FlowMap;
			float _FlowSpeed;

			fixed4 frag(v2f IN) : SV_Target
			{
				float3 flowDir = tex2D(_FlowMap, IN.texcoord) * 2.0f - 1.0f;
				flowDir *= _FlowSpeed;

				float phase0 = frac(_Time[1] * 0.5f + 0.5f);
				float phase1 = frac(_Time[1] * 0.5f + 1.0f);

				half3 tex0 = tex2D(_MainTex, IN.texcoord + flowDir.xy * phase0);
				half3 tex1 = tex2D(_MainTex, IN.texcoord + flowDir.xy * phase1);

				float flowLerp = abs((0.5f - phase0) / 0.5f);
				half3 finalColor = lerp(tex0, tex1, flowLerp);

				fixed4 c = float4(finalColor, 1.0f) * IN.color;
				c.rgb *= c.a;
				return c;
			}
			ENDCG
		}
	}
}
