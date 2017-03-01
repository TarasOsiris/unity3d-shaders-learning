// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "unitycookie/tut/intermediate/4 - Anisotropic Lighting" {

	Properties {
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
		_SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_AniX ("Anisotropic X", Range(0.0, 2.0)) = 1.0
		_AniY ("Anisotropic Y", Range(0.0, 2.0)) = 1.0
		_Shininess ("Shininess", Float) = 1.0
	}

	SubShader {
		Pass {
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform fixed4 _Color;
			uniform fixed4 _SpecColor;
			uniform fixed _AniX;
			uniform fixed _AniY;
			uniform half _Shininess;
			uniform fixed4 _LightColor0;
			
			// base input structs
			struct vertexInput {
				half4 vertex : POSITION;
				half3 normal : NORMAL;
				half4 tangent : TANGENT;
			};

			struct vertexOutput {
				half4 pos : SV_POSITION;
				fixed3 normalDir : TEXCOORD0;
				fixed4 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				fixed3 tangenDir : TEXCOORD3;
			};

			// vertex function
			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				// normal direction
				o.normalDir = normalize(mul(half4(v.normal, 0.0), unity_WorldToObject).xyz);

				// tangent direction
				o.tangenDir = normalize( mul(unity_ObjectToWorld, half4(v.tangent.xyz, 0.0) ) );

				// unity transform POSITION
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				// world position
				half4 worldPos = mul(unity_ObjectToWorld, v.vertex);
				// view direction
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);

				// light direction
				half3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - worldPos.xyz;
				o.lightDir = fixed4(
					normalize( lerp(_WorldSpaceLightPos0.xyz , fragmentToLightSource, _WorldSpaceLightPos0.w) ),
					lerp(1.0 , 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
				);

				return o;
			}

			// fragmet function
			float4 frag(vertexOutput i) : COLOR {
				// Lighting
				fixed h = normalize(i.lightDir.xyz + i.viewDir);
				half3 binormalDir = cross(i.normalDir, i.tangenDir);

				// dot product
				fixed NdotL = dot(i.normalDir, i.lightDir.xyz);
				fixed NdotH = dot(i.normalDir, h);
				fixed NdotV = dot(i.normalDir, i.viewDir);
				fixed TdotHX = dot(i.tangenDir, h) / _AniX;
				fixed BdotHY = dot(binormalDir, h) / _AniY;

				fixed3 diffuseReflection = i.lightDir.w * _Color * _LightColor0.xyz * saturate(NdotL);
				fixed3 specularReflection = diffuseReflection * _SpecColor.rgb * exp( -(TdotHX * TdotHX + BdotHY * BdotHY) ) * _Shininess;

				fixed3 lightFinal = specularReflection + diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz ;

				return fixed4(lightFinal, 1.0);
			}

			ENDCG
		}
	}

	// Fallback "Diffuse"
}