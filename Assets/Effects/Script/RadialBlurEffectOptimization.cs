﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadialBlurEffectOptimization : PostEffectBase
{
	//模糊程度，不能过高
	[Range(0, 1f)]
	public float blurFactor = 1.0f;
	//清晰图像与原图插值
	[Range(0.0f, 2.0f)]
	public float lerpFactor = 0.5f;
	//降低分辨率
	public int downSampleFactor = 2;
	//模糊中心（0-1）屏幕空间，默认为中心点
	public Vector2 blurCenter = new Vector2(0.5f, 0.5f);

	void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (MyMaterial)
		{
			//申请两块降低了分辨率的RT
			RenderTexture rt1 = RenderTexture.GetTemporary(source.width >> downSampleFactor, source.height >> downSampleFactor, 0, source.format);
			RenderTexture rt2 = RenderTexture.GetTemporary(source.width >> downSampleFactor, source.height >> downSampleFactor, 0, source.format);
			Graphics.Blit(source, rt1);

			//使用降低分辨率的rt进行模糊:pass0
			MyMaterial.SetFloat("_BlurFactor", blurFactor);
			MyMaterial.SetVector("_BlurCenter", blurCenter);
			Graphics.Blit(rt1, rt2, MyMaterial, 0);

			//使用rt2和原始图像lerp:pass1
			MyMaterial.SetTexture("_BlurTex", rt2);
			MyMaterial.SetFloat("_LerpFactor", lerpFactor);
			Graphics.Blit(source, destination, MyMaterial, 1);

			//释放RTs
			RenderTexture.ReleaseTemporary(rt1);
			RenderTexture.ReleaseTemporary(rt2);
		}
		else
		{
			Graphics.Blit(source, destination);
		}

	}
}