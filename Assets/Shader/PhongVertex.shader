Shader "Custom/Lighting/PhongVertex"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MainColor ("Color", Color) = (1, 1, 1, 1)
		_Shininess ("Shininess", Range(0.1, 20)) = 1
	}
	SubShader
	{
		Tags 
		{
			"RenderType"="Opaque" 
		}
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
				UNITY_FOG_COORDS(1)
				float4 col : COLOR;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainColor;
			float _Shininess;

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				//o.col = UNITY_LIGHTMODEL_AMBIENT;
				float3 normalDir = normalize(UnityObjectToWorldNormal(v.normal).xyz);
				float3 lightDir = normalize(WorldSpaceLightDir(v.pos));
				float3 viewDir = normalize(WorldSpaceViewDir(v.pos));
				float3 reflectDir = normalize(reflect(-lightDir, normalDir));
				//float3 reflectDir = normalize(2 * dot(normalDir, lightDir) * normalDir - lightDir);

				float3 lambert = _LightColor0.rgb * max(0, dot(normalDir, lightDir));
				o.col = UNITY_LIGHTMODEL_AMBIENT + float4(lambert + _LightColor0.rgb * pow(max(0, dot(reflectDir, viewDir)), _Shininess), 1);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col *= i.col;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;// * _MainColor;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
