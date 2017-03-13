Shader "MakinStuffLookGood/GlowReplace"
{
	Properties
	{
		_GlowColor ("Glow Color", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags 
		{
			"RenderType"="Opaque"
			"Glowable"="True"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			fixed4 _GlowColor;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _GlowColor;
			}
			ENDCG
		}
	}
}
