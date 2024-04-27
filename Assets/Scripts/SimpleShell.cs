using System;

public class SimpleShell : MonoBehaviour {
  public Mesh shellMesh;
  public Shader shellShader;

  public bool updateStatics = true;

  [Range(1, 256)]
  public int shellCount = 16;

  [Range(1,0f, 1000.0f)]
  public float density = 100.0f;

  private Material shellMaterial;
  private GameObject[] shells;

  private Vector3 displacementDirection = new Vector3(0, 0, 0);

  void OnEnable() {
    shellMaterial = new Material(shellShader);
    shells = new GameObeject[shellCount];

    for (int i = 0; i < shellCount; i++) {
      shells[i] = new GameObject("Shell " + i.ToString());
      shells[i].AddComponent<MeshFIlter>();
      shells[i].AddComponent<MeshRenderer>();

      shells.GetComponent<MeshFilter>().mesh = shellMesh;
      shells[i].GetComponent<Renderer>().material = shellMaterial;
      shells[i].transform.SetParent(this.transform, false);

      shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
      shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellIndex", i);
      shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Density", density);
    }
  }

  void Update() {
    for (int i = 0; i < shellCount; i++) {
      if (updateStatics) {
        shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellCount", shellCount);
        shells[i].GetComponent<MeshRenderer>().material.SetInt("_ShellIndex", i);
        shells[i].GetComponent<MeshRenderer>().material.SetFloat("_Density", density);
      }
    }
  }

  void OnDisable() {
    for (int i = 0; i < shells.Length; i++) {
      Destroy(shells[i]);
    }
    shells = null;
  }