using System;
using UnityEngine;

public class Shell : MonoBehaviour
{
    public Mesh shellMesh;
    public Shader shellShader;


    public bool updateStatics = true;
    public bool enableThickness = true;
    public bool useHalfLambert = false;


    [Range(1, 256)]
    public int shellCount = 16;


    [Range(0.0f, 1.0f)]
    public float shellLength = 0.15f;


    [Range(0.01f, 3.0f)]
    public float distanceAttenuation = 1.0f;


    [Range(1.0f, 1000.0f)]
    public float density = 10f;


    [Range(0.0f, 1.0f)]
    public float noiseMin = 0.0f;


    [Range(0.0f, 1.0f)]
    public float noiseMax = 1.0f;


    [Range(0.0f, 10.0f)]
    public float thickness = 1.0f;


    [Range(0.0f, 10.0f)]
    public float curvature = 1.0f;


    [Range(0.0f, 1.0f)]
    public float displacementStrength = 0.1f;


    public Color shellColor;


    [Range(0.0f, 5.0f)]
    public float occlusionAttenuation = 1.0f;


    [Range(0.0f, 1.0f)]
    public float occlusionBias = 0.0f;

    [Range(0.0f, 1.0f)]
    public float windStrength = 0.1f;


    public Vector3 windDirection = new Vector3(0, 0, 1);


    private Material shellMaterial;
    private GameObject[] shells;

    private Vector3 displacementDirection = new Vector3(0, 0, 0);


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

            shells[i].GetComponent<MeshRenderer>().material.SetInt("_EnableThickness", enableThickness ? 1 : 0);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_UseHalfLambert", useHalfLambert ? 1 : 0);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
            shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellIndex", i);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_ShellLength", shellLength);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Density", density);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Thickness", thickness);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Attenuation", occlusionAttenuation);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_ShellDistanceAttenuation", distanceAttenuation);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Curvature", curvature);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_DisplacementStrength", displacementStrength);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_OcclusionBias", occlusionBias);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_NoiseMin", noiseMin);
            shells[i].GetComponent<MeshRenderer>().material.SetFloat("_NoiseMax", noiseMax);
            shells[i].GetComponent<MeshRenderer>().material.SetVector("_ShellColor", shellColor);
        }
    }

    void Update() {

        UpdateWindEffect();

        if (updateStatics) {
            for (int i = 0; i < shellCount; i++) {
                shells[i].GetComponent<MeshRenderer>().material.SetInt("_EnableThickness", enableThickness ? 1 : 0);
                shells[i].GetComponent<MeshRenderer>().material.SetInt("_UseHalfLambert", useHalfLambert ? 1 : 0);
                shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
                shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellIndex", i);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_ShellLength", shellLength);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Density", density);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Thickness", thickness);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Attenuation", occlusionAttenuation);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_ShellDistanceAttenuation", distanceAttenuation);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Curvature", curvature);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_DisplacementStrength", displacementStrength);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_OcclusionBias", occlusionBias);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_NoiseMin", noiseMin);
                shells[i].GetComponent<MeshRenderer>().material.SetFloat("_NoiseMax", noiseMax);
                shells[i].GetComponent<MeshRenderer>().material.SetVector("_ShellColor", shellColor);
            }
        }
    }

    void UpdateWindEffect()
    {
        // Calculate wind effect based on sine wave between 0 and 1
        float windEffect = Mathf.Sin(Time.time) * 0.6f + 0.5f; // Map sine wave from [-1, 1] to [0, 1]

        // Combine wind effect with wind strength
        Vector3 windForce = windDirection * windEffect * windStrength;

        // Apply wind force in addition to downward force
        displacementDirection = Vector3.down + windForce;

        // Normalize displacement direction
        if (displacementDirection.magnitude > 1.0f)
        {
            displacementDirection.Normalize();
        }

        // Set global shader variable for wind direction
        Shader.SetGlobalVector("_ShellDirection", displacementDirection);
    }


    void OnDisable() {
        for (int i = 0; i < shells.Length; i++) {
            Destroy(shells[i]);
        }
        shells = null;
    }
}
