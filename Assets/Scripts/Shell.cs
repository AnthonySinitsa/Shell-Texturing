using UnityEngine;
using System;

public class Shell : MonoBehaviour
{
    public GameObject quadPrefab;

    [Range(1, 256)]
    public int shellCount = 16;


    [Range(1.0f, 1000.0f)]
    public float density = 10f;


    [Range(0.0f, 1.0f)]
    public float noiseMin = 0.0f;


    [Range(0.0f, 1.0f)]
    public float noiseMax = 1.0f;


    private float threshold = 0.01f;

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
            Vector3 position = 
                transform.position + Vector3.up * (float)Math.Round(i * 0.01f, 2);

            // Instantiate the quad as a child of the prefab with X rotation set to 90 degrees
            GameObject quad = 
                Instantiate(quadPrefab, position, Quaternion.Euler(90f, 0f, 0f), transform);

            // Set the density value for the quad
            Renderer renderer = quad.GetComponent<Renderer>();
            renderer.material.SetFloat("_Density", density);
            renderer.material.SetFloat("_ShellCount", shellCount);
            renderer.material.SetFloat("_Threshold", threshold);
            renderer.material.SetInt("_ShellIndex", i);
            renderer.material.SetFloat("_NoiseMin", noiseMin);
            renderer.material.SetFloat("_NoiseMax", noiseMax);

            threshold += 0.01f;
        }
    }
}
