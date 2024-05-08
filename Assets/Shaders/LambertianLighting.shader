Shader "Custom/LambertianLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _LightDirection ("Light Direction", Vector) = (0, 1, 0)
        _LightColor ("Light Color", Color) = (1, 1, 1, 1)
    }
    
    SubShader
    {
        Tags { "LightMode" = "ForwardBase" }
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed3 _LightDirection;
            fixed4 _LightColor;

            v2f vert (appdata v)
            {
                v2f i;
                i.pos = UnityObjectToClipPos(v.vertex);
                i.normal = normalize(UnityObjectToWorldNormal(v.normal));
                return i;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Lambertian diffuse lighting calculation
                float diffuse = max(0, dot(i.normal, _LightDirection));
                fixed4 texColor = tex2D(_MainTex, i.uv);
                return texColor * _Color * _LightColor * diffuse;
            }
            ENDCG
        }
    }
}
