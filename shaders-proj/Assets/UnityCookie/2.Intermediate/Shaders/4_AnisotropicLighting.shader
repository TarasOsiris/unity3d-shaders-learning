Shader "unitycookie/tut/intermediate/4 - Anisotropic Lighting" {

	Properties {
		_Color ("Color Tint", Color) = (1.0, 1.0, 1.0, 1.0)
	}

	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			
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
			};

			// vertex function
			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				// normal direction
				o.normalDir = normalize(mul(half4(v.normal, 0.0), _World2Object).xyz);

				// unity transform POSITION
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				// world position
				half4 worldPos = mul(_Object2World, v.vertex);
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
				// texture maps

				// Lighting
				// dot product
				fixed NdotL = saturate(dot(i.normalDir, i.lightDir.xyz));

				fixed3 lightFinal = UNITY_LIGHTMODEL_AMBIENT;
				return fixed4(lightFinal * _Color.rgb, 1.0);
			}

			ENDCG
		}
	}

	// Fallback "Diffuse"
}