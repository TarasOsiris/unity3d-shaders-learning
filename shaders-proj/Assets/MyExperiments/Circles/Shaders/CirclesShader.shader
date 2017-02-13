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
                float2 p = i.uv;

                float2 cell = floor(p * _Resolution);
                float2 center = (cell + 0.5) / _Resolution;

                float t = _Time.y + cell.x + cell.y;
                t *= 2;

                float l = distance(p, center);
                float r = (0.3 + sin(t) * 0.3) / _Resolution;

                float br1 = smoothstep(0.0, +0.005, l - r);
                float br2 = smoothstep(-0.005, 0.0, r - l);

                float res = br1 * br2 * 8.0;
                float3 rgb = float3(res, res, res);
                
                return float4(rgb, 1);
            }
            ENDCG
        }
    }
}