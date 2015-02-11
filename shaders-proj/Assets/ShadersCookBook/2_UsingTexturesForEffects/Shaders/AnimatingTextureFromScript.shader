Shader "CookbookShaders/Textures/AnimatingTextureFromScript" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}

		_TexWidth ("Sheet Width", float) = 0.0
		_CellAmount ("Cell Amount", float) = 0.0
		_Speed ("Speed", Range(0.1, 32)) = 12

		_TimeValue ("Time Value", float) = 0.0
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;

		float _TexWidth;
		float _CellAmount;
		float _Speed;

		float _TimeValue;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float2 spriteUV = IN.uv_MainTex;

			float cellPixelWidth = _TexWidth / _CellAmount;
			float cellUVPercentage = cellPixelWidth / _TexWidth;

			float xValue = spriteUV.x;
			xValue += _TimeValue;
			xValue *= cellUVPercentage;

			spriteUV = float2(xValue, spriteUV.y);

			half4 c = tex2D (_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
