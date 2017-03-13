using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class GlowComposite : MonoBehaviour
{
	[Range(0, 10)]
	public float Intensity = 2;

	Material _compositeMat;

	void OnEnable()
	{
		_compositeMat = new Material(Shader.Find("MakinStuffLookGood/GlowComposite"));
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest)
	{
		_compositeMat.SetFloat("_Intensity", Intensity);
		Graphics.Blit(src, dest, _compositeMat, 0);
	}
}
