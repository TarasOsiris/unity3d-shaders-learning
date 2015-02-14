Shader "CookbookShaders/Textures/LevelsEffect" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}

		_InBlack ("Input Black", Range(0, 255)) = 0
		_InGamma ("Input Gamma", Range(0, 2)) = 1.61
		_InWhite ("Input White", Range(0, 255)) = 255

		_OutWhite ("Output White", Range(0, 255)) = 255
		_OutBlack ("Output Black", Range(0, 255)) = 0
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		float _InBlack;
		float _InGamma;
		float _InWhite;
		float _OutWhite;
		float _OutBlack;

		struct Input {
			float2 uv_MainTex;
		};

		float GetPixelLevel(float pixelColor)
		{
			float pixelResult;
			pixelResult = (pixelColor * 255.0);
			pixelResult = max(0, pixelResult - _InBlack);
			pixelResult = saturate(pow(pixelResult / (_InWhite - _InBlack), _InGamma));
			pixelResult = (pixelResult * (_OutWhite - _OutBlack) + _OutBlack)/255.0;	
			return pixelResult;
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			float outRPixel = GetPixelLevel(c.r);	
			float outGPixel = GetPixelLevel(c.g);	
			float outBPixel = GetPixelLevel(c.b);	

			o.Albedo = float3(outRPixel, outGPixel, outBPixel);
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
