Shader "Custom/SDCustomLambert"
{
    Properties
    {
        _Albedo("Color Albedo" , Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "Render" = "Opaque"
        }

        CGPROGRAM

            #pragma surface surf Lambert

            half4 LightingLambertWarp(SurfaceOutput s, half3 lightDir , half atten)
            {
                half NdotL = dot (s.Normal, lightDir);
                half diff = NdotL * 0.5 + 0.5;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten);
                c.a = s.Alpha;
                return c; 
            }

            half4 _Albedo;
            
            struct Input
            {
                float2 uv_MainTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                o.Albedo = _Albedo.rgb;
            }

        ENDCG
    }
}