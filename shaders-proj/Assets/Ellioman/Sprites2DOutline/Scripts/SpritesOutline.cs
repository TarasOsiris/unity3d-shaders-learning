using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SpritesOutline : MonoBehaviour
{
	[SerializeField] Color color = Color.white;
	[SerializeField] [Range(0, 16)] int outlineSize;

	SpriteRenderer _renderer;

	void OnEnable()
	{
		_renderer = GetComponent<SpriteRenderer>();
		UpdateOutline(true);
	}

	void OnDisable()
	{
		UpdateOutline(false);
	}

	void Update()
	{
		UpdateOutline(true);
	}

    void UpdateOutline(bool outline)
    {
        MaterialPropertyBlock mpb = new MaterialPropertyBlock();
		_renderer.GetPropertyBlock(mpb);
		mpb.SetFloat("_Outline", outline ? 1f : 0);
		mpb.SetColor("_OutlineColor", color);
		mpb.SetFloat("_OutlineSize", outlineSize);
		_renderer.SetPropertyBlock(mpb);
    }
}
