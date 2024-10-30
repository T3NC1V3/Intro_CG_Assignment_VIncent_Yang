using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotatingWalls : MonoBehaviour
{
    public Vector3 rotationAngle = new Vector3(0, 90, 0); // Set to rotate 90 degrees around Y-axis
    public float rotationDuration = 0.75f; // Time taken to complete the rotation
    public float intervalDuration = 1.65f; // Time between rotations

    private bool isRotating = false;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(RotateIntervals());
    }

    // Coroutine to handle rotation at intervals
    IEnumerator RotateIntervals()
    {
        while (true)
        {
            yield return new WaitForSeconds(intervalDuration); // Wait for the interval before rotating
            if (!isRotating)
            {
                StartCoroutine(RotateWall());
            }
        }
    }

    // Rotate the wall
    IEnumerator RotateWall()
    {
        isRotating = true;

        Quaternion startRotation = transform.rotation;
        Quaternion endRotation = startRotation * Quaternion.Euler(rotationAngle);
        float elapsedTime = 0.0f;

        while (elapsedTime < rotationDuration)
        {
            transform.rotation = Quaternion.Slerp(startRotation, endRotation, elapsedTime / rotationDuration);
            elapsedTime += Time.deltaTime;
            yield return null;
        }

        transform.rotation = endRotation;
        isRotating = false;
    }
}
