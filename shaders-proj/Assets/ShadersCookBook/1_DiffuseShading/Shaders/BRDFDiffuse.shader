Shader "CookbookShaders/Diffuse/BRDFDiffuse" 
{
	Properties 
	{
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("My Slider Value", Range(0, 10)) = 5.0
		_RampTexture ("Ramp Texure", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicDiffuse

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;
		sampler2D _RampTexture;

		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diffLight = saturate(dot(s.Normal, lightDir));
			float rimLight = saturate(dot(s.Normal, viewDir));
			float hLambert = diffLight * 0.5 + 0.5;
			float3 ramp = tex2D(_RampTexture, float2(hLambert, rimLight)).rgb;

			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * ramp;
			col.a = s.Alpha;
			return col;
		}

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor), _MySliderValue);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	} 

	FallBack "Diffuse"
}
