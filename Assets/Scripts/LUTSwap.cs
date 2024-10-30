using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LUTSwap : MonoBehaviour
{
    public Material[] materials; // Array to hold different LUT colorgrading
    private int currentMaterialIndex = 0; // Track material index

    void Start()
    {
        // Apply the initial material
        ApplyMaterial();
    }

    void Update()
    {
        // Keybinds, J = LUT Enabled, K = Disable.
        if (Input.GetKeyDown(KeyCode.J))
        {
            currentMaterialIndex = 0; // Switch to the first material
            ApplyMaterial();
        }
        else if (Input.GetKeyDown(KeyCode.K))
        {
            currentMaterialIndex = 1; // Switch to the second material
            ApplyMaterial();
        }
        else if (Input.GetKeyDown(KeyCode.L)) // Etc.
        {
            currentMaterialIndex = 2;
            ApplyMaterial();
        }
        else if (Input.GetKeyDown(KeyCode.U))
        {
            currentMaterialIndex = 3;
            ApplyMaterial();
        }
    }

    private void ApplyMaterial()
    {
        // Get the Image component to set the material
        Image image = GetComponent<Image>();
        if (image != null && materials.Length > currentMaterialIndex)
        {
            image.material = materials[currentMaterialIndex];
        }
    }
}
