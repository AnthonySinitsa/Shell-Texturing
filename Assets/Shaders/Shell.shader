Shader "Custom/Shell"
{
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }

        Pass
        {
            Cull Off
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            int _ShellIndex;
            int _ShellCount;
            float _ShellLength;
            float _Density;
            float _NoiseMin;
            float _NoiseMax;
            float _Attenuation;
            float3 _ShellColor;

            #include "HashFunction.cginc"


            v2f vert (appdata v)
            {
                v2f i;
                i.normal = normalize(UnityObjectToWorldNormal(v.normal));
                i.worldPos = mul(unity_ObjectToWorld, v.vertex);
                i.pos = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv;
                return i;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Display UV coordinates as colors
                // return fixed4(i.uv.x, i.uv.y, 0, 1);

                float2 uv = i.uv * _Density;

                uint2 tid = uv;
                uint seed = tid.x + 100 * tid.y + 100 * 10;

                float rng = lerp(_NoiseMin, _NoiseMax, hash(seed));

                // return fixed4(rng, rng, rng, 1);

                if (rng > 0.01) {
                    return fixed4(0, 1, 0, 1);
                } else {
                    return fixed4(0, 0, 0, 1);
                }
            }

            // v2f vert (appdata v)
            // {
            //     v2f i;
            //     i.normal = normalize(UnityObjectToWorldNormal(v.normal));
            //     i.worldPos = mul(unity_ObjectToWorld, v.vertex);
            //     i.pos = UnityObjectToClipPos(v.vertex);
            //     i.uv = v.uv * _Density;
            //     return i;
            // }

            // fixed4 frag (v2f i) : SV_Target
            // {
            //     float2 uv = floor(i.uv); // Round UV coordinates to the nearest integer

            //     uint2 tid = uv;
            //     uint seed = tid.x + 100 * tid.y;

            //     float hashValue = lerp(_NoiseMin, _NoiseMax, hash(seed));
                
            //     // threshold is being set to 0.1
            //     // 0.01 * 10.0 = 0.1
            //     float attenuation = pow(hashValue, _Attenuation);

            //     if (hashValue <= _ShellLength) {
            //         discard;
            //     }
            //     // return fixed4(hashValue, hashValue, hashValue, 1);
            //     return fixed4(_ShellColor, 1) * attenuation;
            // }
            ENDCG
        }
    }
}
