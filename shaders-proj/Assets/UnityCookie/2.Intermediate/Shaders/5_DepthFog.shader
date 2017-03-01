// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "unitycookie/tut/intermediate/5 - Depth Fog"{
	Properties {
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_FogColor ("Fog Color", Color) = (1.0,1.0,1.0,1.0)
		_RangeStart ("Fog Close Distance", Float) = 25
		_RangeEnd ("Fog Far Distance", Float) = 25
	}

	SubShader {
		Pass {
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//user defined variables
			uniform fixed4 _Color;
			uniform fixed4 _FogColor;
			uniform half _RangeStart;
			uniform half _RangeEnd;
			
			//unity defined variables
			uniform half4 _LightColor0;
			
			//base input structs
			struct vertexInput{
				half4 vertex : POSITION;
			};
			struct vertexOutput{
				half4 pos : SV_POSITION;
				half4 posWorld : TEXCOORD0;
			};
			
			//vertex Function
			vertexOutput vert(vertexInput v){
				vertexOutput o;
				
				//unity transform position
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

				// world position
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);

				
				return o;
			}
			
			//fragment function
			fixed4 frag(vertexOutput i) : COLOR
			{
				// calculate z-depth
				half dist = distance(i.posWorld, _WorldSpaceCameraPos.xyz);

				// clamp z-depth to range
				fixed distClamp = saturate( (dist - _RangeStart) / _RangeEnd ); 

				// limit z-depth to 0-1

				// return color
				
				return fixed4(distClamp * _FogColor.xyz + _Color.xyz, 1.0);
			}
			
			ENDCG
			
		}
	}
	//Fallback "Specular"
}