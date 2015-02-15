using UnityEditor;
using UnityEngine;

public class GenerateStaticCubemap : ScriptableWizard
{
    public Cubemap cubemap;
    public Transform renderPosition;

    [MenuItem("CookBook/Render Cubemap")]
    private static void RenderCubemap()
    {
        DisplayWizard("Render CubeMap", typeof (GenerateStaticCubemap), "Render");
    }

    private void OnWizardCreate()
    {
        var go = new GameObject("CubeCam", typeof (Camera));
        go.transform.position = renderPosition.position;
        go.transform.rotation = Quaternion.identity;
        go.camera.RenderToCubemap(cubemap);
        DestroyImmediate(go);
    }

    private void OnWizardUpdate()
    {
        helpString = "Select transform to render from and cubemap to render into";
        if (renderPosition != null && cubemap != null)
        {
            isValid = true;
        }
        else
        {
            isValid = false;
        }
    }
}