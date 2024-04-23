using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Shell : MonoBehaviour
{
    public float density = 10f;

    void Start()
    {
        Renderer renderer = GetComponent<Renderer>();
        renderer.material.SetFloat("_Density", density);
    }
}
