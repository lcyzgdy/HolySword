Shader "Custom/Test/Gouraud"
{
	Properties
    {
        _MainColor ("Color", Color) = (1, 1, 1, 1)
		_MainTex ("Main Tex", 2D) = "white"
    }
    SubShader
    {
        Tags 
		{ 
			"RenderType" = "Opaque" 
			"CanUseSpriteAtlas" = "True"
		}
        LOD 100

        Pass
        {
            Name "Gouraud"
			Tags
			{
				"LightMode" = "ForwardBase"
			}
			//Lighting Off

            CGPROGRAM
			#pragma target 3.0
			#pragma multi_compile_fwdbase
			#pragma multi_compile_instancing
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
            #include "UnityStandardBRDF.cginc"
			#include "UnityPBSLighting.cginc"
			//#include "UnityStandardCore.cginc"

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
				float3 col : COLOR0;
				SHADOW_COORDS(1)
            };

            float4 _MainColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
            
            //Gouraud Shading的重点就是光照是在vert函数中计算
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				TRANSFER_SHADOW(o);
				float3 worldPos = UnityObjectToClipPos(v.pos);
				float3 ambient0 = UNITY_LIGHTMODEL_AMBIENT.rag;
				float3 normalDir = normalize(mul(UNITY_MATRIX_M, v.normal));
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - worldPos);
				float3 diffuse0 = _LightColor0.rgb * max(dot(normalDir, lightDir), 0);
				float dist = distance(_WorldSpaceLightPos0, worldPos);
				float atten = 2 / pow(dist, 2);
				o.col = diffuse0 * ambient0;
				//o.col = v.normal;
				return o;
			}
            
            fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = _MainColor * tex2D(_MainTex, i.uv);
				UNITY_APPLY_FOG(i.fogCoord, col);
				col *= fixed4(i.col, 1);
				return col ;//* SHADOW_ATTENUATION(i);
            }
            ENDCG
        }

		Pass
		{
			Name "Forword Delta"
			Tags
			{
				"LightMode" = "ForwardAdd"
			}
			Blend One One
			ZWrite Off
			CGPROGRAM
			
				#pragma multi_compile_fwdadd_fullshadows
				#pragma multi_compile_fog

				#pragma vertex vertAdd
				#pragma fragment fragAdd
				#include "UnityStandardCoreForward.cginc"
			ENDCG
		}

		/*Pass
        {
            Name "ShadowCaster"
            Tags
            { 
                "LightMode" = "ShadowCaster" 
                //"IgnoreProjector" = "True"
            }

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
        }*/

		Pass
		{
			Name "META" 
			Tags { "LightMode"="Meta" }

			Cull Off

			CGPROGRAM
			#pragma vertex vert_meta
			#pragma fragment frag_meta

			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature EDITOR_VISUALIZATION

			#include "UnityStandardMeta.cginc"
			ENDCG
		}
    }
	FallBack "VertexLit"
}
