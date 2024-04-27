Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 100
        _Threshold ("Threshold", Float) = 0.01
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

            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "AutoLight.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Density;
            float _Threshold;

            #include "HashFunction.cginc"

            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv * _Density;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = floor(i.uv); // Round UV coordinates to the nearest integer

                float hashValue = hash(uint(uv.x + 100) * uint(uv.y + 1000)); // Combine UV components and hash

                // return fixed4(hashValue, hashValue, hashValue, 1);

                _Threshold += 0.01;

                // Check if hashValue is greater than 0
                if (hashValue > _Threshold)
                {
                    return fixed4(0, 1, 0, 1); // Green color
                }
                else
                {
                    return fixed4(0, 0, 0, 1); // Black color
                }
            }
            ENDCG
        }
    }
}
