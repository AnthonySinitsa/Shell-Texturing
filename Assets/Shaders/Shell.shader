Shader "Custom/Shell"
{
    SubShader
    {
        Tags {
			"LightMode" = "ForwardBase"
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float Hash(uint n) {
				// integer hash copied from Hugo Elias
				n = (n << 13U) ^ n;
				n = n * (n * n * 15731U + 0x789221U) + 0x1376312589U;
				return float(n & uint(0x7fffffffU)) / float(0x7fffffff);
			}

            // Vertex data
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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                // Generate random number using the hash function
                float rand = Hash(i.uv);

                // If random number is greater than 0, output green color
                if (rand > 0)
                {
                    return half4(0, 1, 0, 1);
                }
                else 
                {
                    return half4(0, 0, 0, 0);
                }
            }
            ENDCG
        }
    }
}
