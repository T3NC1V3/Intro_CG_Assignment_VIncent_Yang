Shader "Custom/Diffuse"
{
	Properties // PAINNNNNN
    {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0) // Color property
        _MainTex ("Main Texture", 2D) = "white" {} // Main texture
        _NormalMap ("Normal Map", 2D) = "bump" {} // Normal map texture
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

            // User variables
            uniform float4 _Color;
            uniform sampler2D _MainTex;      // Main texture
            uniform sampler2D _NormalMap;    // Normal map texture
            
            // Unity variables
            uniform float4 _LightColor0;

            // Base input struct
            struct vertexInput {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float2 uv : TEXCOORD0; // UV coordinates
                float4 tangent : TANGENT; // Tangent for normal mapping
            };

            struct vertexOutput {
                float4 pos: SV_POSITION;
                float4 col: COLOR;
                float2 uv : TEXCOORD0; // Pass UV to fragment shader
                float3 worldNormal : TEXCOORD1; // World space normal
                float3 worldTangent : TEXCOORD2; // World space tangent
                float3 worldBinormal : TEXCOORD3; // World space binormal
                float3 worldPos : TEXCOORD4; // World space position
            };

            // Vertex shader
            vertexOutput vert(vertexInput v) {
                vertexOutput o;

                // Transform vertex position to clip space
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                // Convert normals and tangents to world space
                o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
                o.worldTangent = normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz));
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w; // Calculate the binormal
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz; // World position

                return o;
            }

            // Fragment shader
            float4 frag(vertexOutput i) : SV_Target
            {
                // Sample the main texture
                float4 baseColor = tex2D(_MainTex, i.uv) * _Color; // Combine with color

                // Sample and transform the normal map from [0,1] to [-1,1]
                float3 tangentNormal = tex2D(_NormalMap, i.uv).xyz * 2.0 - 1.0;

                // Transform tangent space normal to world space
                float3 normalWorldSpace = normalize(
                    tangentNormal.x * i.worldTangent +
                    tangentNormal.y * i.worldBinormal +
                    tangentNormal.z * i.worldNormal
                );

                // Light direction and attenuation
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
                float NdotL = max(0.0, dot(normalWorldSpace, lightDir));
                float3 diffuseReflection = _LightColor0.rgb * baseColor.rgb * NdotL;

                // Final color output
                return float4(diffuseReflection, baseColor.a);
            }
            ENDCG
        }
		// Fallback "Diffuse"
	}
}
