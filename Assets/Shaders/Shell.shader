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
            float _ShellDistanceAttenuation;
            float3 _ShellColor;

            #include "HashFunction.cginc"


            v2f vert (appdata v)
            {
                v2f i;

                // Caluclate normalized height of shell
                float shellHeight = (float)_ShellIndex / (float)_ShellCount;

                // Apply attentuation based on shell height
                shellHeight = pow(shellHeight, _ShellDistanceAttenuation);

                // Move vertex position along normal direction to create shell effect
                v.vertex.xyz += v.normal.xyz * _ShellLength * shellHeight;

                // Calculate normal and world position
                i.normal = normalize(UnityObjectToWorldNormal(v.normal));
                i.worldPos = mul(unity_ObjectToWorld, v.vertex);

                // Calculate screen space position
                i.pos = UnityObjectToClipPos(v.vertex);

                // Pass UV coords
                i.uv = v.uv;
                
                return i;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Display UV coordinates as colors
                // return fixed4(i.uv.x, i.uv.y, 0, 1);

                // Map UV coords to density
                float2 uv = i.uv * _Density;

                // Hash function seed
                uint2 tid = uv;
                uint seed = tid.x + 100 * tid.y + 100 * 10;

                // Calculate noise value
                float rng = lerp(_NoiseMin, _NoiseMax, hash(seed));

                // Calculate normalized height of shell
                float shellIndex = _ShellIndex;
                float shellCount = _ShellCount;
                float height = shellIndex / shellCount;

                // Apply attenuation based on height and attenuation
                float attenuation = pow(height, _Attenuation);

                // If noise value is below normalized height, discard
                if (rng <= height) discard;

                // Return color with attenuation applied
                return fixed4(_ShellColor * attenuation, 1);
            }
            ENDCG
        }
    }
}
