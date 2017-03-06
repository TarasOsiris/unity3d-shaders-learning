Shader "MakinStuffLookGood/Default"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_OffsetTex ("Offset Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
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
			#pragma shader_feature ETC1_EXTERNAL_ALPHA
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
				float2 texcoord  : TEXCOORD0;
				float2 screenuv : TEXCOORD1;
				float4 vertex_raw : TEXCOORD2;
			};
			
			fixed4 _Color;

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = mul(UNITY_MATRIX_MVP, IN.vertex);
				OUT.vertex_raw = OUT.vertex;
				// OUT.screenuv = (IN.vertex.xy / IN.vertex.w) * 0.5 + 0.5;
				OUT.screenuv = (IN.vertex.xy / IN.vertex.w) * 0.5 + 0.5;
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			sampler2D _GlobalRefractionTex;
			sampler2D _OffsetTex;

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				color.a = tex2D (_AlphaTex, uv).r;
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}

			float2 map(float2 s, float2 a1, float2 a2, float2 b1, float2 b2)
			{
				return b1 + (s-a1)*(b2-b1)/(a2-a1);
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				float4 c = SampleSpriteTexture (IN.texcoord) * IN.color;
				c.rgb *= c.a;

				// screen scpace
				float2 uvscreen = (IN.vertex_raw / IN.vertex_raw.w) * 0.5 + 0.5;

				float2 offset = mul(_Object2World, tex2D(_OffsetTex, IN.texcoord).xy * 2 - 1);
				float4 boringRefl = tex2D(_GlobalRefractionTex, uvscreen.xy + offset * 0.04);

				c.rgb = c.rgb * (1.0 - boringRefl.a) + (boringRefl.rgb * boringRefl.a);

				return c;
				return float4(offset.r, 0, -offset.r, 1);
			}
		ENDCG
		}
	}
}
