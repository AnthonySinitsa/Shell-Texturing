using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shell : MonoBehaviour
{
    [Range(1.0f, 1000.0f)]
    public float Density = 100f; // Adjust the density here

    void Start()
    {
        // Get the renderer component and set the density value
        Renderer renderer = GetComponent<Renderer>();
        renderer.material.SetFloat("_Density", Density);
    }
}
