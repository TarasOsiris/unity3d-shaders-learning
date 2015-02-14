Shader "CookbookShaders/Specular/BlinnPhong" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Main Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularPower ("SpecularPower", Range(0, 1)) = 0.5
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		float _SpecularPower;
		float4 _MainTint;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Specular = _SpecularPower;
			o.Gloss = c.r;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 

	FallBack "Diffuse"
}
