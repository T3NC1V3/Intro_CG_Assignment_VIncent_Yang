Shader "Custom/Specular"
{
	Properties
    {
        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0) // Base color
        _SpecColor ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0) // Specular color
        _Shininess ("Shininess", Float) = 10 // Shininess factor
        _MainTex ("Main Texture", 2D) = "white" {} // Main texture
        _NormalMap ("Normal Map", 2D) = "bump" {} // Normal map
    }

    SubShader
    {
        Pass
        {
            Tags 
            {
                "LightMode" = "ForwardBase"
            }
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            // User variables
            uniform float4 _Color;
            uniform float4 _SpecColor;
            uniform float _Shininess;
            uniform sampler2D _MainTex;      // Main texture
            uniform sampler2D _NormalMap;    // Normal map texture

            // Unity variables
            uniform float4 _LightColor0;

            // Structs
            struct vertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0; // UV coordinates for texturing
                float4 tangent : TANGENT; // Tangent for normal mapping
            };

            struct vertexOutput {
                float4 pos : SV_POSITION;
                float4 posWorld : TEXCOORD0;
                float4 normalDir : TEXCOORD1;
                float2 uv : TEXCOORD2; // Pass UV to fragment shader
                float3 tangentDir : TEXCOORD3; // Pass tangent to fragment shader
                float3 binormalDir : TEXCOORD4; // Pass binormal to fragment shader
            };

            // Vertex shader
            vertexOutput vert(vertexInput v) {
                vertexOutput o;

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject));
                o.uv = v.uv;

                // Calculate tangent and binormal
                float3 T = normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz));
                float3 N = o.normalDir.xyz; // Normal in world space
                float3 B = cross(N, T) * (v.tangent.w < 0.0 ? -1.0 : 1.0); // Compute binormal

                // Pass tangent and binormal to fragment shader
                o.tangentDir = T;
                o.binormalDir = B;

                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            // Fragment shader
            float4 frag(vertexOutput i) : COLOR
            {
                // Sample the main texture
                float4 baseColor = tex2D(_MainTex, i.uv) * _Color;

                // Sample the normal map and transform to [-1, 1]
                float3 tangentNormal = tex2D(_NormalMap, i.uv).xyz * 2.0 - 1.0;

                // Transform tangent space normal to world space
                float3 N = normalize(i.normalDir.xyz); // Normal in world space
                float3 T = normalize(i.tangentDir); // Tangent in world space
                float3 B = normalize(i.binormalDir); // Binormal in world space

                float3 normalWorldSpace = normalize(
                    tangentNormal.x * T +
                    tangentNormal.y * B +
                    tangentNormal.z * N
                );

                // Lighting calculations
                float atten = 1.0;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalWorldSpace, lightDirection));

                // Specular calculation
                float3 lightReflectDirection = reflect(-lightDirection, normalWorldSpace);
                float3 viewDirection = normalize(float3(float4(_WorldSpaceCameraPos.xyz, 1.0) - i.posWorld.xyz));
                float3 lightSeeDirection = max(0.0, dot(lightReflectDirection, viewDirection));
                float3 shininessPower = pow(lightSeeDirection, _Shininess);

                float3 specularReflection = atten * _SpecColor.rgb * shininessPower;
                float3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.rgb;

                return float4(lightFinal * baseColor.rgb, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}