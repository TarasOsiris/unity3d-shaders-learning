using UnityEngine;

public class AnimateTexture : MonoBehaviour
{
    private float _timeValue = 0.0f;

    void FixedUpdate()
    {
        _timeValue = Mathf.Ceil(Time.time * 10);
        transform.renderer.material.SetFloat("_TimeValue", _timeValue);
    }
}