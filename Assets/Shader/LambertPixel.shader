// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Lighting/LambertPixel"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor ("Color", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : TEXCOORD1;
				UNITY_FOG_COORDS(1)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.pos);
				o.normal = mul(float4(v.normal, 0), unity_WorldToObject).xyz;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed3 normal = normalize(i.normal);
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 lambert = max(0, dot(normal, lightDir));
				fixed3 diffuseReflection = lambert * _LightColor0.xyz;
				fixed3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				col *= _MainColor;
				col *= fixed4(lightFinal, 1);
				return col;
			}
			ENDCG
		}

		Pass
        {
            Name "ShadowCaster"
            Tags
            { 
                "LightMode" = "ShadowCaster" 
                "IgnoreProjector" = "True"
            }
			Blend One One

            ZWrite On

            CGPROGRAM
                #pragma target 3.0
				
				#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
				#pragma shader_feature _METALLICGLOSSMAP
				#pragma shader_feature _PARALLAXMAP
				#pragma multi_compile_instancing
                #pragma multi_compile_shadowcaster

                #pragma vertex vertShadowCaster
                #pragma fragment fragShadowCaster

                #include "UnityStandardShadow.cginc"

            ENDCG
        }
	}
	FallBack "VertexLit"
}
