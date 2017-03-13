using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class GlowPrePass : MonoBehaviour
{
	static RenderTexture PrePass;
	static RenderTexture Blurred;

	Material _blurMat;

	void OnEnable()
	{
		PrePass = new RenderTexture(Screen.width, Screen.height, 24);
		// PrePass.antiAliasing = QualitySettings.antiAliasing;
		Blurred = new RenderTexture(Screen.width >> 1, Screen.height >> 1, 0);

		var camera = GetComponent<Camera>();
		var glowShader = Shader.Find("MakinStuffLookGood/GlowReplace");
		camera.targetTexture = PrePass;
		camera.SetReplacementShader(glowShader, "Glowable");

		Shader.SetGlobalTexture("_GlowPrePassTex", PrePass);
		Shader.SetGlobalTexture("_GlowBlurredTex", Blurred);

		_blurMat = new Material(Shader.Find("MakinStuffLookGood/Blur"));
		_blurMat.SetVector("_BlurSize", new Vector2(Blurred.texelSize.x * 1.5f, Blurred.texelSize.y * 1.5f));
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		Graphics.Blit(src, dest);

		Graphics.SetRenderTarget(Blurred);
		GL.Clear(false, true, Color.clear);

		Graphics.Blit(src, Blurred);

		for (int i = 0; i < 4; i++)
		{
			var temp = RenderTexture.GetTemporary(Blurred.width, Blurred.height);
			Graphics.Blit(Blurred, temp, _blurMat, 0);
			Graphics.Blit(temp, Blurred, _blurMat, 1);
			RenderTexture.ReleaseTemporary(temp);
		}
	}
}
