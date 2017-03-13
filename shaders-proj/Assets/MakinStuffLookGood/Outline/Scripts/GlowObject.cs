using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GlowObject : MonoBehaviour
{
    public Color GlowColor;

    public float LerpFactor = 10;


    Color _currentColor;
    Color _targetColor;

    List<Material> _materials = new List<Material>();

    public Renderer[] Renderers
    {
        get;
        private set;
    }

    void Start()
    {
        Renderers = GetComponentsInChildren<Renderer>();
        foreach (var renderer in Renderers)
        {
            _materials.AddRange(renderer.materials);
        }

        for (int i = 0; i < _materials.Count; i++)
        {
            _materials[i].SetColor("_GlowColor", GlowColor);
        }
    }

    private void OnMouseEnter()
    {
        _targetColor = GlowColor;
        enabled = true;
    }

    private void OnMouseExit()
    {
        _targetColor = Color.black;
        enabled = true;
    }

    void Update()
    {
        // _currentColor = Color.Lerp(_currentColor, _targetColor, Time.deltaTime * LerpFactor);
        // for (int i = 0; i < _materials.Count; i++)
        // {
        //     _materials[i].SetColor("_GlowColor", _currentColor);
        // }

        // if (_currentColor.Equals(_targetColor))
        // {
        //     enabled = false;
        // }
    }
}
