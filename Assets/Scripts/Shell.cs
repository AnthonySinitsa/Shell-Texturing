using System;
using UnityEngine;

public class Shell : MonoBehaviour
{
    public Mesh shellMesh;
    public Shader shellShader;

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

    private Material shellMaterial;
    private GameObject[] shells;


    void OnEnable()
    {
        shellMaterial = new Material(shellShader);

        shells = new GameObject[shellCount];

        for (int i = 0; i < shellCount; i++)
        {
            shells[i] = new GameObject("Shell " + i.ToString());
            shells[i].AddComponent<MeshFilter>();
            shells[i].AddComponent<MeshRenderer>();

            shells[i].GetComponent<MeshFilter>().mesh = shellMesh;
            shells[i].GetComponent<MeshRenderer>().material = shellMaterial;
            shells[i].transform.SetParent(this.transform, false);

            // shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
            GetComponent<Renderer>().material.SetInt("_ShellCount", shellCount);
            GetComponent<Renderer>().material.SetInt("_ShellIndex", i);
            GetComponent<Renderer>().material.SetFloat("_ShellLength", shellLength);
            GetComponent<Renderer>().material.SetFloat("_Density", density);
            GetComponent<Renderer>().material.SetFloat("_NoiseMin", noiseMin);
            GetComponent<Renderer>().material.SetFloat("_NoiseMax", noiseMax);
            GetComponent<Renderer>().material.SetVector("_ShellColor", shellColor);
        }
    }

    void OnDisable(){
        for (int i = 0; i < shells.Length; ++i) {
            Destroy(shells[i]);
        }
    }
}
