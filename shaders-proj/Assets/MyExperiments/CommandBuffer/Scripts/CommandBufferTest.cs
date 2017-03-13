using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

[ExecuteInEditMode]
public class CommandBufferTest : MonoBehaviour
{
	public MeshFilter meshFilter;

	CommandBuffer _commandBuffer;

	Material _mat;

	void OnEnable()
	{
		_mat = new Material(Shader.Find("MakinStuffLookGood/GlowCmdShader"));
		_mat.SetColor("_GlowColor", Color.red);

		_commandBuffer = new CommandBuffer();
		_commandBuffer.name = "My Custom CommandBuffer";

		GetComponent<Camera>().AddCommandBuffer(CameraEvent.BeforeImageEffects, _commandBuffer);
	}

	void OnDisable()
	{
		GetComponent<Camera>().RemoveAllCommandBuffers();
	}

	void Update()
	{
		_commandBuffer.ClearRenderTarget(true, true, Color.green);
		_commandBuffer.DrawMesh(meshFilter.sharedMesh, meshFilter.transform.localToWorldMatrix, _mat);
	}
}
