using UnityEngine;

public class DrawRays : MonoBehaviour
{
    private MeshFilter curFilter;
    public float gizmosSize = 1.0f;

    private void OnDrawGizmos()
    {
        Gizmos.matrix = transform.localToWorldMatrix;
        var camPosition = Camera.main.transform.position;

        if (!curFilter)
        {
            curFilter = transform.GetComponent<MeshFilter>();
            if (!curFilter)
            {
                Debug.LogWarning("No mesh filter found!!");
            }
        }
        else
        {
            var curMesh = curFilter.sharedMesh;
            if (curMesh)
            {
                for (var i = 0; i < curMesh.vertices.Length; i++)
                {
                    var viewDir = (curMesh.vertices[i] - camPosition).normalized;
                    var curReflVector = Reflect(viewDir, curMesh.normals[i]);

                    Gizmos.color = new Color(curReflVector.x, curReflVector.y, curReflVector.z, 1.0f);
                    Gizmos.DrawRay(curMesh.vertices[i], curReflVector*gizmosSize);
                }
            }
        }
    }

    private Vector3 Reflect(Vector3 viewDir, Vector3 normal)
    {
        var reflection = viewDir - 2.0f*normal*Vector3.Dot(normal, viewDir);
        return reflection;
    }
}