Shader "MakinStuffLookGood/Barrier" {
    Properties {
        _Color ("Surface Color", Color) = (1, 1, 1, 1)
    }
    
    Subshader {
        Pass {
            CGPROGRAM

            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            struct app_data {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 screenuv : TEXCOORD1;
                float depth : TEXCOORD2;
            };

            fixed4 _Color;

            v2f vert(app_data v) {
                v2f o;

                // clip space coords are from (-1, -1, -1) to (1, 1, 1)
                o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

                // screen coords from clip space coordinates
                o.screenuv = ((o.vertex.xy / o.vertex.w) + 1) / 2; // from (-1, 1) to (0, 0)
                o.screenuv.y = 1 - o.screenuv.y;

                // After the the VIEW (V) matrix is applied to each vertex, but before the PROJECTION (P) matrix is applied, 
                // the Z element of each vertex represents the distance away from the camera. 
                float distanceFromCamera = mul(UNITY_MATRIX_MV, v.vertex).z;
                o.depth = -distanceFromCamera * _ProjectionParams.w; // _ProjectionParams.w is 1/FarPlane.

                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET {
                return _Color;
            }

            ENDCG
        }
    }
}