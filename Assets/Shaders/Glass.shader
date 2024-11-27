Shader "Custom/Glass"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {} // Main texture
        _NormalMap ("Normal Map", 2D) = "bump" {} // Normal map
        _Scale ("Scale", Range(1,20)) = 1
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
        }
        GrabPass{}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            // Base input struct
            struct vertexInput 
            {
                float4 vertex: POSITION;
                float4 uv : TEXCOORD0; // UV coordinates
            };

            struct vertexOutput {
                float4 vertex: SV_POSITION;
                float2 uv : TEXCOORD0; // Pass UV to fragment shader
                float4 uvgrab : TEXCOORD1; 
                float2 uvbump : TEXCOORD2; 
            };

            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _NormalMap;
            float4 _NormalMap_ST;
            float _Scale;

            // Vertex shader
            vertexOutput vert(vertexInput v) 
            {
                vertexOutput o;

                // Transform vertex position to clip space
                o.vertex = UnityObjectToClipPos(v.vertex);

                # if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0;
                # else
                float scale = 1.0f;
                # endif

                o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
                o.uvgrab.zw = o.vertex.zw;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvbump = TRANSFORM_TEX(v.uv, _NormalMap);

                return o;
            }

            // Fragment shader
            float4 frag(vertexOutput i) : SV_Target
            {
                half2 bump = UnpackNormal(tex2D(_NormalMap, i.uvbump)).rg;
                float2 offset = bump * _Scale * _GrabTexture_TexelSize.xy;
                i.uvgrab.xy = offset * i.uvgrab.z + i.uvgrab.xy;

                fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                fixed4 tint = tex2D(_MainTex, i.uv);
                col *= tint;
                return col;
            }
            ENDCG
        }
     //FallBack "Diffuse"   
    }
}