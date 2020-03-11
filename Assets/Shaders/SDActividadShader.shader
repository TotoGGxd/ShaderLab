Shader "Custom/SDActividadShader"
{
    Properties
    {
        _Albedo("Albedo" , Color) = (1,1,1,1)
       
        [HDR] _RimColor("Rim Color" , Color) = (1,0,0,1)
        _RimPower("Rim Power" , Range(0.0 , 8.0)) = 1.0
       
        _MainTex("Main Texture" , 2D) = "white"{}
        _NormalTex("Normal Texture", 2D) = "bump"{}

        _RampTex("Ramp Textur", 2D) = "white"{}


    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }
        
        CGPROGRAM
        #pragma surface surf Ramp

        half3 _Albedo;

        half3 _RimColor;
        float _RimPower;

        sampler2D _MainTex;
        sampler2D _NormalTex;
        sampler2D _RampTex;

        half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten)
        {
            half NdotL = dot(s.Normal, lightDir);
            half diff = NdotL * 0.5 + 0.5;
            float2 uv_RampTex = float2(diff, 0);
            half3 rampColor = tex2D(_RampTex, uv_RampTex).rgb;                
            half4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * atten * rampColor;
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float a;

            float2 uv_MainTex;
            float uv_NormalTex;

            float3 viewDir;
        };

        void surf(Input IN , inout SurfaceOutput o)
        {
            o.Albedo = _Albedo.rgb;
            
            float3 nVD = normalize(IN.viewDir);
            float3 NdotV = dot(nVD, o.Normal);
            half rim = 1 - saturate(NdotV);
            o.Emission = _RimColor.rgb * rim * pow(rim, _RimPower);

            half4 texColor = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = texColor.rgb;
            half4 normalColor = tex2D(_NormalTex,IN.uv_NormalTex);
            half3 normal = UnpackNormal(normalColor);
            o.Normal = normal;

        }
        ENDCG
    }
}