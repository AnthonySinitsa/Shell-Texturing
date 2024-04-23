Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 10
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
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _Density;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv; // Use unscaled UV coordinates
                float hashValue = hash(uint(uv.x * 1000) ^ uint(uv.y * 1000)); // Combine UV components and hash
                
                // Map hash value to color range (grayscale)
                float grayValue = hashValue * 0.5 + 0.5; // Map range [-1, 1] to [0, 1]
                
                return fixed4(grayValue, grayValue, grayValue, 1); // Output grayscale color
            }
            ENDCG
        }
    }
}
