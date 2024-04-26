using UnityEngine;

public class Shell : MonoBehaviour
{
    public GameObject quadPrefab;
    public int shellCount = 10;
    public float density = 10f;

    void Start()
    {
        for (int i = 0; i < shellCount; i++)
        {
            // Calculate position for the new quad
            Vector3 position = transform.position + Vector3.up * i * 0.1f;

            // Instantiate the quad as a child of the prefab
            GameObject quad = 
                Instantiate(quadPrefab, position, Quaternion.Euler(90f, 0f, 0f), transform);

            // Set the density value for the quad
            Renderer renderer = quad.GetComponent<Renderer>();
            renderer.material.SetFloat("_Density", density);
        }
    }
}
