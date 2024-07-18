using UnityEngine;

public class RotateLight : MonoBehaviour
{
    public float rotationSpeed = 100f; // Rotation speed in degrees per second

    void Update()
    {
        // Rotate the light around the origin (0, 0, 0)
        transform.RotateAround(Vector3.zero, Vector3.up, rotationSpeed * Time.deltaTime);
    }
}
