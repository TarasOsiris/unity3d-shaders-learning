Shader "unitycookie/tut/intermediate/1 - TransparentCutaway" {
	Properties {
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Height ("Height", Range(-1.0, 1.0)) = 1.0
	}

	SubShader {
		Tags { "Queue" = "Transparent" }
		Cull Off

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// user defined variables
			uniform float4 _Color;
			uniform float _Height;

			// base input structs
			struct vertexInput {
				float4 vertex : Position;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 vertPos : TEXCOORD0;
			};

			// vertex function 
			vertexOutput vert(vertexInput v) {
				vertexOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.vertPos = v.vertex;
				return o;
			}

			float4 frag(vertexOutput i) : COLOR {
				if (i.vertPos.y	> _Height) {
					discard;
				}
				return _Color;
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}