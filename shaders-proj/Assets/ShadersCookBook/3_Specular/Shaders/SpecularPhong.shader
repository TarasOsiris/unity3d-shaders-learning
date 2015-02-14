Shader "CookbookShaders/Specular/Phong" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint ("Main Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecularColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecPower ("SpecularPower", Range(0, 30)) = 1
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Phong

		sampler2D _MainTex;
		float4 _MainTint;
		float4 _SpecularColor;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
		};

		inline fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diff = dot(s.Normal, lightDir);
			float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);

			float spec = pow(max(0, dot(reflectionVector, viewDir)), _SpecPower);
			float3 finalSpec = _SpecularColor.rgb * spec;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = 1.0;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
