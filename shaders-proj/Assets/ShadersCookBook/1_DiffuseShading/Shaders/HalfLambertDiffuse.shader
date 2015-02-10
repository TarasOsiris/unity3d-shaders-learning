Shader "CookbookShaders/Diffuse/HalfLambertDiffuse" {

	Properties 	
	{
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", Range(0,10)) = 2.5
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf HalfLambertDiffuse
		#pragma target 3.0

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		inline float4 LightingHalfLambertDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten) 
		{
			float diffLight = max(0, dot(s.Normal, lightDir));
			float hLambert = diffLight * 0.5 + 0.5;

			float4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (hLambert * atten * 2);
			color.a = s.Alpha;
			return color;
		}

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			float4 color;
			color = pow((_EmissiveColor + _AmbientColor), _MySliderValue);

			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}

		ENDCG
	}

	Fallback "Diffuse"
}