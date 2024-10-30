using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Teleport : MonoBehaviour
{
    // Location to teleport the player to
    public Transform teleportLocation;

    private void OnTriggerEnter(Collider other)
    {
        // Check if the collided object is the player
        if (other.CompareTag("Player"))
        {
            TeleportPlayer(other.transform);
        }
    }

    private void TeleportPlayer(Transform player)
    {
        player.position = teleportLocation.position; // Teleports the player to the location
        Destroy(gameObject); // Destroy the item
    }
}
