using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ScreenSpaceRefractions : MonoBehaviour
{
	[SerializeField]
	// [HideInInspector]
	Camera _camera;

	int _downResFactor = 0;

	const string GlobalTextureName = "_GlobalRefractionTex";

	void Awake()
	{
		GenerateRT();
	}

	void GenerateRT()
	{
		_camera = GetComponent<Camera>();

		if (_camera.targetTexture != null)
		{
			RenderTexture temp = _camera.targetTexture;

			_camera.targetTexture = null;
			DestroyImmediate(temp);
		}

		_camera.targetTexture = new RenderTexture(_camera.pixelWidth >> _downResFactor, _camera.pixelHeight >> _downResFactor, 16);
		_camera.targetTexture.filterMode = FilterMode.Bilinear;

		Shader.SetGlobalTexture(GlobalTextureName, _camera.targetTexture);
	} 
}
