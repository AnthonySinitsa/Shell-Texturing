using System;
using UnityEngine;

public class Shell : MonoBehaviour
{
    public GameObject quadPrefab;


    [Range(1, 256)]
    public int shellCount = 16;


    [Range(0.0f, 1.0f)]
    public float shellLength = 0.15f;


    [Range(1.0f, 1000.0f)]
    public float density = 10f;


    [Range(0.0f, 1.0f)]
    public float noiseMin = 0.0f;


    [Range(0.0f, 1.0f)]
    public float noiseMax = 1.0f;


    public Color shellColor;


    void OnEnable()
    {

        // Destroy any existing quads
        foreach (Transform child in transform)
        {
            Destroy(child.gameObject);
        }

        // Calculate the step size for positioning the quads evenly between 0.0 and 0.1
        float step = 0.1f / shellCount;

        // Spawn new quads
        for (int i = 0; i < shellCount; i++)
        {

            // Calculate the y-position for the new quad
            float yPos = step * i;

            // Instantiate the quad as a child of the prefab with X rotation set to 90 degrees
            GameObject quad = Instantiate(quadPrefab, transform);
            quad.transform.localPosition = new Vector3(0f, yPos, 0f);
            quad.transform.localRotation = Quaternion.Euler(90f, 0f, 0f);

            Renderer renderer = quad.GetComponent<Renderer>();
            renderer.material.SetInt("_ShellCount", shellCount);
            renderer.material.SetInt("_ShellIndex", i);
            renderer.material.SetFloat("_ShellLength", shellLength);
            renderer.material.SetFloat("_Density", density);
            renderer.material.SetFloat("_Threshold", yPos); 
            renderer.material.SetFloat("_NoiseMin", noiseMin);
            renderer.material.SetFloat("_NoiseMax", noiseMax);
            renderer.material.SetVector("_ShellColor", shellColor);
        }
    }
}
