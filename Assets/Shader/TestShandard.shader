// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Custom/MyStandard"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1) //主颜色
		_MainTex("Albedo", 2D) = "white" {} //主纹理
		_Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5 //Alpha剔除值
		_Glossiness("Smoothness", Range(0.0, 1.0)) = 0.2 //平滑、光泽度

		_GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0 
		[Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

		[Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0 //金属性
		_MetallicGlossMap("Metallic", 2D) = "white" {} //金属光泽纹理图

		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0

		_BumpScale("Scale", Float) = 1.0 //凹凸的尺度
		_BumpMap("Normal Map", 2D) = "bump" {} //法线贴图

		_Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02 //高度缩放尺度
		_ParallaxMap ("Height Map", 2D) = "black" {} //高度纹理图

		_OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0 //遮挡强度
		_OcclusionMap("Occlusion", 2D) = "white" {} //遮挡纹理图
		
		_EmissionColor("Color", Color) = (0,0,0) //自发光颜色
		_EmissionMap("Emission", 2D) = "white" {} //自发光纹理图
		
		_DetailMask("Detail Mask", 2D) = "white" {} //细节掩膜图

		_DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {} //细节纹理图
		_DetailNormalMapScale("Scale", Float) = 1.0 //细节法线贴图尺度
		_DetailNormalMap("Normal Map", 2D) = "bump" {} //细节法线贴图

		[Enum(UV0, 0, UV1, 1)] _UVSec ("UV Set for secondary textures", Float) = 0 //二级纹理的UV设置


		// 混合状态
		[HideInInspector] _Mode ("__mode", Float) = 0.0
		[HideInInspector] _SrcBlend ("__src", Float) = 1.0
		[HideInInspector] _DstBlend ("__dst", Float) = 0.0
		[HideInInspector] _ZWrite ("__zw", Float) = 1.0
	}

	CGINCLUDE
		// BRDF(双向反射分布函数)有关的一个宏
		#define UNITY_SETUP_BRDF_INPUT MetallicSetup 
	ENDCG

	SubShader
	{
		// 渲染类型设置：不透明
		Tags 
		{
			"RenderType"="Opaque"
			"PerformanceChecks"="False" 
		}
		LOD 300
		Cull Off

		// ------------------------------------------------------------------
		//  Base forward pass (directional light, emission, lightmaps, ...)
		Pass
		{
			Name "FORWARD" 
			Tags 
			{ 
				"LightMode" = "ForwardBase" 
			}

			Blend [_SrcBlend] [_DstBlend]
			ZWrite [_ZWrite]
			//ZTest Always
			//ZWrite Always

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------

			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#pragma multi_compile_instancing

			#pragma vertex vertBase
			#pragma fragment fragBase
			#include "UnityStandardCoreForward.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Additive forward pass (one light per pass)
		Pass
		{
			Name "FORWARD_DELTA"
			Tags { "LightMode" = "ForwardAdd" }
			Blend [_SrcBlend] One
			Fog { Color (0,0,0,0) } // in additive pass fog should be black
			ZWrite Off
			ZTest LEqual

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------


			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_fwdadd_fullshadows
			#pragma multi_compile_fog

			#pragma vertex vertAdd
			#pragma fragment fragAdd
			#include "UnityStandardCoreForward.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Shadow rendering pass
		Pass {
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On ZTest LEqual

			CGPROGRAM
			#pragma target 3.0

			// -------------------------------------


			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _PARALLAXMAP
			#pragma multi_compile_shadowcaster
			#pragma multi_compile_instancing

			#pragma vertex vertShadowCaster
			#pragma fragment fragShadowCaster

			#include "UnityStandardShadow.cginc"

			ENDCG
		}
		// ------------------------------------------------------------------
		//  Deferred pass
		Pass
		{
			Name "DEFERRED"
			Tags { "LightMode" = "Deferred" }

			CGPROGRAM
			#pragma target 3.0
			#pragma exclude_renderers nomrt


			// -------------------------------------

			#pragma shader_feature _NORMALMAP
			#pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
			#pragma shader_feature _EMISSION
			#pragma shader_feature _METALLICGLOSSMAP
			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
			#pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature ___ _DETAIL_MULX2
			#pragma shader_feature _PARALLAXMAP

			#pragma multi_compile_prepassfinal
			#pragma multi_compile_instancing

			#pragma vertex vertDeferred
			#pragma fragment fragDeferred

			#include "UnityStandardCore.cginc"

			ENDCG
		}

		// ------------------------------------------------------------------
		// Extracts information for lightmapping, GI (emission, albedo, ...)
		// This pass it not used during regular rendering.
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
	//CustomEditor "StandardShaderGUI"
}
