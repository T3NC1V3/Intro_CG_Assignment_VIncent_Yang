using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightSwap : MonoBehaviour
{
    public Material[] materials; // Array to hold different materials aka the lighting setups
    private int currentMaterialIndex = 0; // Track material index

    void Start()
    {
        // Apply the initial material
        ApplyMaterial();
    }

    void Update()
    {
        // Keybinds, 0 = Diffuse, 1 = Ambient, 2 = Specular
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            currentMaterialIndex = 0; // Switch to the first material
            ApplyMaterial();
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            currentMaterialIndex = 1; // Switch to the second material
            ApplyMaterial();
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            currentMaterialIndex = 2; // Switch to the third material
            ApplyMaterial();
        }
    }

    private void ApplyMaterial()
    {
        // Get the Renderer component and set the material
        Renderer renderer = GetComponent<Renderer>();
        if (renderer != null && materials.Length > currentMaterialIndex)
        {
            renderer.material = materials[currentMaterialIndex];
        }
    }
}
