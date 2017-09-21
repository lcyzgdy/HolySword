// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Lighting/LambertVertex"
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
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 pos : SV_POSITION;
				float4 col : COLOR;
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

				float3 normalDir = normalize(mul(float4(v.normal, 0), unity_WorldToObject).xyz);
				//float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 lightDir = normalize(WorldSpaceLightDir(v.pos));
				float atten = 1.0;
				float3 diffuseReflection = atten * _LightColor0.xyz * max(0.0, dot(normalDir, lightDir));
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				o.col = float4(lightFinal, 1.0);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				col *= i.col * _MainColor;
				return col;
			}
			ENDCG
		}
	}
	FallBack "VertexLit"
}
