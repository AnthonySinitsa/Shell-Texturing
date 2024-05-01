Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 100
        _Threshold ("Threshold", Float) = 0.01
        _Attenuation ("Attenuation", Float) = 1.0
        _ShellIndex ("Shell Index", Int) = 0
        _NoiseMin ("NoiseMin", Float) = 0
        _NoiseMax ("NoiseMax", Float) = 0
    }
    
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
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Density;
            float _Threshold;
            float _Attenuation;
            int _ShellIndex;
            float _NoiseMin;
            float _NoiseMax;

            #include "HashFunction.cginc"

            v2f vert (appdata v)
            {
                v2f o;
                o.normal = normalize(UnityObjectToWorldNormal(v.normal));
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _Density;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = floor(i.uv); // Round UV coordinates to the nearest integer

                uint2 tid = uv;
                uint seed = tid.x + 100 * tid.y;

                float hashValue = lerp(_NoiseMin, _NoiseMax, hash(seed));

                float threshold = _Threshold * 10.0;
                float attenuation = pow(threshold, _Attenuation);

                // max is 0.99996
                if (hashValue <= threshold) {
                    discard;
                }
                return fixed4(0, 1, 0, 1) * attenuation;
                // return fixed4(hashValue, hashValue, hashValue, 1);
            }
            ENDCG
        }
    }
}
