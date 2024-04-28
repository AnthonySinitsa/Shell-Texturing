using UnityEngine;

public class ShellSpawner : MonoBehaviour
{
    public GameObject quadPrefab;

    [Range(1, 256)]
    public int shellCount = 10;

    [Range(1.0f, 1000.0f)]
    public float density = 10f;

    private float threshold = 0.6f;

    void Start()
    {
        // Destroy previously spawned quads
        foreach (Transform child in transform)
        {
            Destroy(child.gameObject);
        }

        // Spawn new quads
        for (int i = 0; i < shellCount; i++)
        {
            // Calculate position for the new quad
            Vector3 position = transform.position + Vector3.up * i * 0.01f;

            // Instantiate the quad as a child of the prefab with X rotation set to 90 degrees
            GameObject quad = Instantiate(quadPrefab, position, Quaternion.Euler(90f, 0f, 0f), transform);

            // Set the density value for the quad
            Renderer renderer = quad.GetComponent<Renderer>();
            renderer.material.SetFloat("_Density", density);
            renderer.material.SetFloat("_ShellCount", shellCount);
            renderer.material.SetFloat("_Threshold", threshold);

            threshold += 0.01f;
        }
    }
}
