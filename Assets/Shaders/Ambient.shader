Shader "Custom/Ambient"
{
	Properties
    {
        _Color ("Color", Color) = (1.0,1.0,1.0,1.0)
        _myNormal ("Normal Map", 2D) = "bump" {}  // Normal map texture
         _MainTex ("Main Texture", 2D) = "white" {} // Main texture
        _mySlider ("Height", Range(0,10)) = 1     // Intensity slider for effect
    }

    SubShader
    {
        Tags 
        { 
            "LightMode" = "ForwardBase"
            "RenderType" = "Opaque"
        }

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // Properties and uniforms
            uniform float4 _Color;
            uniform sampler2D _myNormal;
            uniform float4 _LightColor0;

            // Structs
            struct vertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;           // UV for texture
                float4 tangent : TANGENT;        // Tangent for normal mapping
            };

            struct vertexOutput {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
                float3 worldTangent : TEXCOORD2;
                float3 worldBinormal : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
            };

            // Vertex shader
            vertexOutput vert(vertexInput v)
            {
                vertexOutput o;

                // Transform vertex position to clip space
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // Transform normal, tangent, and binormal to world space
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.worldTangent = normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz));
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            // Fragment shader
            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample the normal map and transform from [0,1] to [-1,1]
                float3 tangentNormal = tex2D(_myNormal, i.uv).xyz * 2.0 - 1.0;

                // Transform tangent space normal to world space
                float3 worldNormal = normalize(
                    tangentNormal.x * i.worldTangent +
                    tangentNormal.y * i.worldBinormal +
                    tangentNormal.z * i.worldNormal
                );

                // Light direction and attenuation
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                float NdotL = max(0.0, dot(worldNormal, lightDir));

                // Diffuse and ambient lighting
                float3 diffuse = _LightColor0.rgb * NdotL;
                float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.rgb;
                float3 finalColor = (_Color.rgb * diffuse) + ambient;

                return float4(finalColor, 1.0);
            }

            ENDCG
		}
		// Fallback "Diffuse"
	}
}