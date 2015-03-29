using UnityEngine;

public class AnimateTexture : MonoBehaviour
{
    private float _timeValue;

    private void FixedUpdate()
    {
        _timeValue = Mathf.Ceil(Time.time*10);
        transform.GetComponent<Renderer>().material.SetFloat("_TimeValue", _timeValue);
    }
}