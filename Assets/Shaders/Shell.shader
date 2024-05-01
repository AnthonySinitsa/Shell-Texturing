Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 100
        _Threshold ("Threshold", Float) = 0.01
        _Attenuation ("Attenuation", Float) = 1.0
        _ShellIndex ("Shell Index", Int) = 0
        _NoiseMin ("NoiseMin", Float) = 0
        _NoiseMax ("NoiseMax", Float) = 1
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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
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
                v2f i;
                i.normal = normalize(UnityObjectToWorldNormal(v.normal));
                i.worldPos = mul(unity_ObjectToWorld, v.vertex);
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv * _Density;
                return i;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = floor(i.uv); // Round UV coordinates to the nearest integer

                uint2 tid = uv;
                uint seed = tid.x + 100 * tid.y;

                float hashValue = lerp(_NoiseMin, _NoiseMax, hash(seed));
                
                // threshold is being set to 0.1
                // 0.01 * 10.0 = 0.1
                float threshold = _Threshold * 10.0;
                float attenuation = pow(threshold, _Attenuation);

                if (hashValue <= threshold) {
                    discard;
                }
                // return fixed4(hashValue, hashValue, hashValue, 1);
                return fixed4(0, 1, 0, 1) * attenuation;
            }
            ENDCG
        }
    }
}
