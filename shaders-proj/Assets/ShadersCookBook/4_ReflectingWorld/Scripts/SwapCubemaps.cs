using UnityEngine;

[ExecuteInEditMode]
public class SwapCubemaps : MonoBehaviour
{
    public Cubemap cubeA;
    public Cubemap cubeB;

    public Transform posA;
    public Transform posB;

    private Material curMat;
    private Cubemap curCubemap;

    void Update()
    {
        curMat = GetComponent<Renderer>().sharedMaterial;
        if (curMat)
        {
            curCubemap = CheckProbeDistance();
            curMat.SetTexture("_Cubemap", curCubemap);
        }
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.green;
        if (posA)
        {
            Gizmos.DrawWireSphere(posA.position, 0.5f);
        }

        if (posB)
        {
            Gizmos.DrawWireSphere(posB.position, 0.5f);
        }
    }


    private Cubemap CheckProbeDistance()
    {
        float distA = Vector3.Distance(transform.position, posA.position);
        float distB = Vector3.Distance(transform.position, posB.position);

        if (distA < distB)
        {
            return cubeA;
        }
        
        return cubeB;
    }
    
}