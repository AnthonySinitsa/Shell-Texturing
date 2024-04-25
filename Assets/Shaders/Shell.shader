Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 100
    }
    
    SubShader
    {
        Tags {
            "LightMode" = "ForwardBase"
        }

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

            #include "HashFunction.cginc"

            v2f vert (appdata v)
            {
                v2f o;
                // Scale and translate UV coordinates to show only a 10x10 set of pixels
                o.uv = v.uv * _Density;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv; // Use scaled UV coordinates
                
                // Map UV coordinates to a 10x10 grid
                uv = floor(uv * _Density) / _Density;

                float hashValue = hash(uint(uv.x + 100) * uint(uv.y + 1000)); // Combine UV components and hash
                
                // Map hash value to color range (e.g., grayscale)
                float grayValue = hashValue * 0.5 + 0.5; // Map range [-1, 1] to [0, 1]
                
                // return fixed4(grayValue, grayValue, grayValue, 1); // Output grayscale color
                
                // Check if grayValue is greater than 0
                if (grayValue > 0)
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
