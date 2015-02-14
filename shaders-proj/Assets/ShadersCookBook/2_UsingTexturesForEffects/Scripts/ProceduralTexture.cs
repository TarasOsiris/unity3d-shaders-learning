using UnityEngine;

public class ProceduralTexture : MonoBehaviour
{
    public int widthHeight = 512;
    public Texture2D generatedTexture;

    private Material _currentMaterial;
    private Vector2 _centerPosition;

    void Start()
    {
        if (!_currentMaterial)
        {
            _currentMaterial = transform.renderer.sharedMaterial;
            if (!_currentMaterial)
            {
                Debug.LogWarning("Cannot find a material on: " + transform.name);
            }

            _centerPosition = new Vector2(0.5f, 0.5f);
            generatedTexture = GenerateDirectionView();

            _currentMaterial.SetTexture("_MainTex", generatedTexture);
        }
    }

    Texture2D GenerateParabola()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);

        Vector2 centerPixelPosition = _centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x, y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (widthHeight * 0.5f);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));

                Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }

    Texture2D GenerateRings()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);

        Vector2 centerPixelPosition = _centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x, y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (widthHeight * 0.5f);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0f, 1f));
                pixelDistance = (Mathf.Sin(pixelDistance*30.0f)*pixelDistance);

                Color pixelColor = new Color(pixelDistance, pixelDistance, pixelDistance, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }

    Texture2D GenerateDirectionView()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight, widthHeight);

        Vector2 centerPixelPosition = _centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x, y);
                Vector2 pixelDirection = centerPixelPosition - currentPosition;
                pixelDirection.Normalize();
                float rightDirection = Vector2.Dot(pixelDirection, Vector3.right);
                float leftDirection = Vector2.Dot(pixelDirection, Vector3.left);
                float upDirection = Vector2.Dot(pixelDirection, Vector3.up);

                Color pixelColor = new Color(rightDirection, leftDirection, upDirection, 1.0f);
                proceduralTexture.SetPixel(x, y, pixelColor);
            }
        }

        proceduralTexture.Apply();
        return proceduralTexture;
    }
}