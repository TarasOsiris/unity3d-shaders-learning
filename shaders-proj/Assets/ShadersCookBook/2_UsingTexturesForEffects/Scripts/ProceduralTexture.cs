using UnityEngine;

public class ProceduralTexture : MonoBehaviour
{
    private Vector2 _centerPosition;
    private Material _currentMaterial;
    public Texture2D generatedTexture;
    public int widthHeight = 512;

    private void Start()
    {
        if (!_currentMaterial)
        {
            _currentMaterial = transform.GetComponent<Renderer>().sharedMaterial;
            if (!_currentMaterial)
            {
                Debug.LogWarning("Cannot find a material on: " + transform.name);
            }

            _centerPosition = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateDirectionView();

            _currentMaterial.SetTexture("_MainTex", generatedTexture);
        }
    }

    private Texture2D GenerateParabola()
    {
        var proceduralTexture = new Texture2D(widthHeight, widthHeight);

        var centerPixelPosition = _centerPosition*widthHeight;

        for (var x = 0; x < widthHeight; x++)
        {
            for (var y = 0; y < widthHeight; y++)
            {
                var currentPosition = new Vector2(x, y);
                var pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition)/(widthHeight*0.5f);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));

                var pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }

    private Texture2D GenerateRings()
    {
        var proceduralTexture = new Texture2D(widthHeight, widthHeight);

        var centerPixelPosition = _centerPosition*widthHeight;

        for (var x = 0; x < widthHeight; x++)
        {
            for (var y = 0; y < widthHeight; y++)
            {
                var currentPosition = new Vector2(x, y);
                var pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition)/(widthHeight*0.5f);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));
                pixelDistance = (Mathf.Sin(pixelDistance*30.0f)*pixelDistance);

                var pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }

    private Texture2D GenerateDirectionView()
    {
        var proceduralTexture = new Texture2D(widthHeight, widthHeight);

        var centerPixelPosition = _centerPosition*widthHeight;

        for (var x = 0; x < widthHeight; x++)
        {
            for (var y = 0; y < widthHeight; y++)
            {
                var currentPosition = new Vector2(x, y);
                var pixelDirection = centerPixelPosition - currentPosition;
                pixelDirection.Normalize();
                var rightDirection = Vector2.Dot(pixelDirection, Vector3.right);
                var leftDirection = Vector2.Dot(pixelDirection, Vector3.left);
                var upDirection = Vector2.Dot(pixelDirection, Vector3.up);

                var pixelColor = new Color(rightDirection, leftDirection, upDirection, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }
}