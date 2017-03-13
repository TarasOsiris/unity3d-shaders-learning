using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class GlowController : MonoBehaviour
{
    static GlowController _instance;

    static CommandBuffer _commandBuffer;

    List<GlowObjectCmd> _glowableObjects = new List<GlowObjectCmd>();
    Material _glowMat;
    Material _blurMat;
    Vector2 _blurTexelSize;

    int _prePassRenderTexId;
    int _blurPassRenderTexId;
    int _tempRenderTexId;
    int _blurSizeId;
    int _glowColorId;

    void Awake()
    {
        _instance = this;

        _glowMat = new Material(Shader.Find("MakinStuffLookGood/GlowCmdShader"));
        _blurMat = new Material(Shader.Find("MakinStuffLookGood/Blur"));

        _prePassRenderTexId = Shader.PropertyToID("_GlowPrePassTex");
        _blurPassRenderTexId = Shader.PropertyToID("_GlowBlurredTex");
        _tempRenderTexId = Shader.PropertyToID("_TempTex0");
        _blurSizeId = Shader.PropertyToID("_BlurSize");
        _glowColorId = Shader.PropertyToID("_GlowColor");

        _commandBuffer = new CommandBuffer();
        _commandBuffer.name = "Glowing Objects Buffer"; // This name is visible in the Frame Debugger, so make it a descriptive!
        GetComponent<Camera>().AddCommandBuffer(CameraEvent.BeforeImageEffects, _commandBuffer);
    }

    public static void RegisterObject(GlowObjectCmd glowObj)
    {
        if (_instance != null)
        {
            _instance._glowableObjects.Add(glowObj);
        }
    }

    void RebuildCommandBuffer()
    {
        _commandBuffer.Clear();

        _commandBuffer.GetTemporaryRT(_prePassRenderTexId, Screen.width, Screen.height, 0, FilterMode.Bilinear, RenderTextureFormat.Default, RenderTextureReadWrite.Default, 2);
        _commandBuffer.SetRenderTarget(_prePassRenderTexId);
        _commandBuffer.ClearRenderTarget(true, true, Color.clear);

        for (int i = 0; i < _glowableObjects.Count; i++)
        {
            _commandBuffer.SetGlobalColor(_glowColorId, _glowableObjects[i].GlowColor);

            for (int j = 0; j < _glowableObjects[i].Renderers.Length; j++)
            {
                _commandBuffer.DrawRenderer(_glowableObjects[i].Renderers[j], _glowMat);
            }
        }

        _commandBuffer.GetTemporaryRT(_blurPassRenderTexId, Screen.width >> 1, Screen.height >> 1, 0, FilterMode.Bilinear);
        _commandBuffer.GetTemporaryRT(_tempRenderTexId, Screen.width >> 1, Screen.height >> 1, 0, FilterMode.Bilinear);
        _commandBuffer.Blit(_prePassRenderTexId, _blurPassRenderTexId);

        _blurTexelSize = new Vector2(1.5f / (Screen.width >> 1), 1.5f / (Screen.height >> 1));
        _commandBuffer.SetGlobalVector(_blurSizeId, _blurTexelSize);

        for (int i = 0; i < 4; i++)
        {
            _commandBuffer.Blit(_blurPassRenderTexId, _tempRenderTexId, _blurMat, 0);
            _commandBuffer.Blit(_tempRenderTexId, _blurPassRenderTexId, _blurMat, 1);
        }
    }

    void Update()
    {
        RebuildCommandBuffer();
    }
}
