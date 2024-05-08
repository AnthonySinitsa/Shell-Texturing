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
            
            int _EnableThickness;
            int _ShellIndex;
            int _ShellCount;
            float _ShellLength;
            float _Density;
            float _NoiseMin;
            float _NoiseMax;
            float _Thickness;
            float _Attenuation;
            float _ShellDistanceAttenuation;
            float _OcclusionBias;
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
                // This here extrudes the shells along the base vertex normal
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
                // Map UV coords to density
                // This multiplies uv coords to create more strands
                float2 uv = i.uv * _Density;
                
                // To work in local space after expanding them to wider range, we take fractional component. 
                // Since uv coords by default range from 0 to 1 so then fractional part is in 0 to 1. 
                // We multiply by 2 and subtract 1 to convert from 0 to 1 to -1 to 1 in order to shift origin of these local uv coords to center
                float2 localUV = frac(uv) * 2 - 1;
                
                // Local distance from local center
                float localDistanceFromCenter = length(localUV);
                
                // Hash function seed
                uint2 tid = uv;
                uint seed = tid.x + 100 * tid.y;
                
                // Calculate noise value
                float rng = lerp(_NoiseMin, _NoiseMax, hash(seed));
                
                // Calculate normalized height of shell
                float height = (float)_ShellIndex / (float)_ShellCount;
                
                // This is condition for discarding pixels, if distance from local center is greater than thickness parameter, discard it.
                // This also modifies thickenss and makes it thinner the higher it goes.
                // If strange cutoff happens because of tappering, try replacing rng with 1 or some other value.
                int outsideThickness = 
                (localDistanceFromCenter) > (_Thickness * (rng - height));
                
                // This culls pixel if it is outside the thickenss of strand.
                // EnableThickenss allows the option to switch between squares and strands
                if (_EnableThickness == 1 && outsideThickness && _ShellIndex > 0) discard;
                
                // Calculate Lambertian diffuse lighting
                // Assume the light direction is (0, 1, 1) for simplicity
                float3 lightDir = float3(0, 1, 1);
                float3 normal = normalize(i.normal);
                float diffuseIntensity = max(dot(normal, lightDir), 0.0);
                
                // This is Valve's half lamber lighting. It's not physically based.
                // Made dark areas feel less dark. This fixes my issue with a pitch black center
                // Valve's half lambert squares the ndotl output, which brings values down.
                float ndotl = DotClamped(i.normal, _WorldSpaceLightPos0) * 0.5f + 0.5f;
                ndotl = ndotl * ndotl;
                
                // Apply attenuation based on height and attenuation
                // This is fake ambient occlusion
                float ambientOcclusion = pow(height, _Attenuation);
                ambientOcclusion += _OcclusionBias;
                
                // If noise value is below normalized height, discard
                if (rng <= height) discard;

                return fixed4(_ShellColor * ambientOcclusion * diffuseIntensity, 1);
            }
            ENDCG
        }
    }
}
