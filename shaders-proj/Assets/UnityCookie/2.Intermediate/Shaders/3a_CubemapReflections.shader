// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "unitycookie/tut/intermediate/3a - Cubemap Reflections" {
	Properties {
		_Cube ("Cubemap", Cube) = "" {}
	}

	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform samplerCUBE _Cube;

			struct vertexInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float3 normalDir : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				o.viewDir = float3(mul(unity_ObjectToWorld, v.vertex) - _WorldSpaceCameraPos).xyz;

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				return o;
			}

			float4 frag(vertexOutput i) : COLOR {

				// reflect the ray based on the normals to get the cube coordinates
				float3 reflectDir = reflect(i.viewDir, i.normalDir);

				// texture maps
				float4 texC = texCUBE(_Cube, reflectDir);

				return texC;
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}