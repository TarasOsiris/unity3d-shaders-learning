Shader "CookbookShaders/Textures/NormalMapping" 
{
	Properties 
	{
		_MainTint ("Main Tint", Color) = (1, 1, 1, 1)
		_NormalTex ("Normal Texure", 2D) = "bump" {}
		_NormalIntensity ("NormalIntensity", Range(0, 2)) = 1
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		float4 _MainTint;
		sampler2D _NormalTex;
		float _NormalIntensity;

		struct Input 
		{
			float2 uv_NormalTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			normalMap = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);

			o.Normal = normalMap.rgb;
			o.Albedo = _MainTint.rgb;
			o.Alpha = _MainTint.a;
		}
		ENDCG
	} 

	FallBack "Diffuse"
}
