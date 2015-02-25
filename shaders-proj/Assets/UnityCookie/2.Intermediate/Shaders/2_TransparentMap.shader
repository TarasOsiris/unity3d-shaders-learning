Shader "unitycookie/tut/intermediate/2 - TransparentMap" {
	Properties {
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_TransMap ("Transparency (A))", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue" = "Transparent" }
		Blend srcAlpha OneMinusSrcAlpha

		Pass {
			Cull Off
			zWrite Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			// user defined variables
			uniform float4 _Color;
			uniform sampler2D _TransMap;
			uniform float4 _TransMap_ST;

			// base input structs
			struct vertexInput {
				float4 vertex : Position;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD1;
			};

			// vertex function 
			vertexOutput vert(vertexInput v) {
				vertexOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.tex = v.texcoord;
				return o;
			}

			float4 frag(vertexOutput i) : COLOR {
				float4 tex = tex2D(_TransMap, _TransMap_ST.xy * i.tex.xy + _TransMap_ST.zw);
				float alpha = tex.a * _Color.a;
				return float4(_Color.xyz,  alpha);
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}