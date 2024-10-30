using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraLook : MonoBehaviour
{
    public Transform target; // The player or object to orbit around
    public float distance = 5.0f; // Distance between the camera and the target
    public float sensitivityX = 4.0f; // Mouse sensitivity on the X axis
    public float sensitivityY = 2.0f; // Mouse sensitivity on the Y axis
    public float minY = -20f; // Minimum Y rotation
    public float maxY = 80f; // Maximum Y rotation

    private float rotationY = 0.0f; // Current Y rotation of the camera
    private float rotationX = 0.0f; // Current X rotation of the camera

    private bool cameraLocked = false;

    void Start()
    {
        if (!target)
        {
            Debug.LogError("Target not assigned.");
        }

        // Set initial rotation to match the camera's starting position
        Vector3 angles = transform.eulerAngles;
        rotationX = angles.y;
        rotationY = angles.x;

        LockCamera(true);
        Cursor.visible = false;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Mouse0))
        {
            cameraLocked = !cameraLocked;
            LockCamera(cameraLocked);
        }

        if (!cameraLocked)
        {
            if (target)
            {
                // Get mouse input
                rotationX += Input.GetAxis("Mouse X") * sensitivityX;
                rotationY -= Input.GetAxis("Mouse Y") * sensitivityY;

                // Clamp the Y rotation between the specified min and max values
                rotationY = Mathf.Clamp(rotationY, minY, maxY);

                // Apply the rotation to the camera rig
                Quaternion rotation = Quaternion.Euler(rotationY, rotationX, 0);
                transform.rotation = rotation;

                // Set the camera's position based on distance from the target
                Vector3 negDistance = new Vector3(0.0f, 0.0f, -distance);
                Vector3 position = rotation * negDistance + target.position;

                transform.position = position;
            }
        }
    }

    private void LockCamera(bool lockCamera)
    {
        if (lockCamera)
        {
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
        else
        {
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }
    }

}
