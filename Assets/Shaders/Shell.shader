Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 100
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
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            int _ShellIndex
            int _ShellCount;
            float _ShellLength
            float _Density;
            float _NoiseMin;
            float _NoiseMax;
            float _Attenuation;
            float3 _ShellColor;

            // include Hash function
            #include "HashFunction.cginc"

            v2f vert (appdata v)
            {
                v2f i;

                float shellHeight = (float)_ShellIndex / (float)_ShellCount;

                v.vertex.xyz += v.normal.xyz * _ShellLength * shellHeight;

                i.normal = normalize(UnityObjectToWorldNormal(v.normal));

                
                i.worldPos = mul(unity_ObjectToWorld, v.vertex);
                i.pos = UnityObjectToClipPos(v.vertex);

                i.uv = v.uv;

                return i;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv * _Density; // Round UV coordinates to the nearest integer

                uint2 tid = uv;
                uint seed = tid.x + 100 * tid.y;

                float shellIndex = _ShellIndex;
                float shellCount = _ShellCount;

                float hashValue = lerp(_NoiseMin, _NoiseMax, hash(seed));
                
                float h = shellIndex / shellCount;

                float attenuation = pow(h, _Attenuation);

                if (hashValue <= h) {
                    discard;
                }
                // return fixed4(hashValue, hashValue, hashValue, 1);
                return fixed4(_ShellColor, 1) * attenuation;
            }
            ENDCG
        }
    }
}
