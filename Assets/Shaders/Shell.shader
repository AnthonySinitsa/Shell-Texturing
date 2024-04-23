Shader "Custom/Shell"
{
    Properties
    {
        _Density ("Density", Float) = 10
    }

    #include "HashFunction.cginc"

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float density = _Density;
                float2 uv = floor(i.uv * density) / density; // Calculate UV based on density
                float hashValue = hash(uvec2(uv * 1000)); // Adjust hash input based on your needs
                if (hashValue > 0)
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
