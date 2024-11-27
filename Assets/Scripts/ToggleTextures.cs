using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleTextures : MonoBehaviour
{
    public Material targetMaterial; // Assign material in the Inspector

    public KeyCode toggleKey = KeyCode.P;

    private Texture originalTexture;
    private Texture originalNormalMap;
    private bool isMapsEnabled = true; // Start with maps enabled

    void Start()
    {
        // Store the original textures
        if (targetMaterial != null)
        {
            originalTexture = targetMaterial.GetTexture("_MainTex");
            originalNormalMap = targetMaterial.GetTexture("_NormalMap");
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(toggleKey))
        {
            ToggleMaps();
        }
    }

    void ToggleMaps()
    {
        if (targetMaterial != null)
        {
            if (isMapsEnabled)
            {
                // Disable textures by setting them to null
                targetMaterial.SetTexture("_MainTex", null);
                targetMaterial.SetTexture("_NormalMap", null);
            }
            else
            {
                // Re-enable textures by restoring the originals
                targetMaterial.SetTexture("_MainTex", originalTexture);
                targetMaterial.SetTexture("_NormalMap", originalNormalMap);
            }

            isMapsEnabled = !isMapsEnabled;
        }
    }
}