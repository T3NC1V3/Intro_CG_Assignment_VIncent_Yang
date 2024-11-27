Shader "Custom/ScrollingFloor"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {} // Main texture
        _NormalMap ("Normal Map", 2D) = "bump" {} // Normal map
        _ScrollX ("Xscroll", Range(-5,5)) = 1
        _ScrollY ("Yscroll", Range(-5,5)) = 1
    }
    SubShader
    {

        CGPROGRAM
        #pragma surface surf Lambert

        sampler2D _MainTex;
        sampler2D _NormalMap;
        float _ScrollX;
        float _ScrollY;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            _ScrollX *= _Time;
            _ScrollY *= _Time;
            float3 tex = (tex2D (_MainTex, IN.uv_MainTex + float2(_ScrollX, _ScrollY))).rgb;
            float3 normal = (tex2D (_NormalMap, IN.uv_MainTex + float2(_ScrollX, _ScrollY)));
            o.Albedo = (tex + normal)/2.0;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
