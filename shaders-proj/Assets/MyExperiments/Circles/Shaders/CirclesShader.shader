Shader "MyExperiments/Circles"
{
    Properties
    {
        _Resolution ("Resolution", Float) = 1.0
    }

    SubShader
    {
        Pass 
        {
            CGPROGRAM
            
            #include "UnityCG.cginc"

            #pragma vertex vert
            #pragma fragment frag

            float _Resolution;

            struct appdata {
                float4 position : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float4 position : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.position = mul(UNITY_MATRIX_MVP, v.position);
                o.uv = v.uv;
                return o;
            }

            float4 frag(v2f i) : SV_TARGET
            {
                float2 cell = floor(i.uv * _Resolution);
                float2 center = (cell + 0.5) / _Resolution;
                
                return float4(center, 0, 0);
            }
            ENDCG
        }
    }
}