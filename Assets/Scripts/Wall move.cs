using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wallmove : MonoBehaviour
{
    public Vector3 moveDirection = new Vector3(1, 0, 0); // Direction to move (X-axis by default)
    public float moveDistance = 10.0f; // How far to move
    public float moveSpeed = 25.0f; // Speed of movement
    public float pauseDuration = 0.2f; // Duration to pause at each end

    private Vector3 startPosition;
    private Vector3 endPosition;
    private bool movingToEnd = true;

    // Start is called before the first frame update
    void Start()
    {
        startPosition = transform.position;
        endPosition = startPosition + moveDirection.normalized * moveDistance;
        StartCoroutine(MoveWall());
    }

    // Coroutine to handle the movement
    private IEnumerator MoveWall()
    {
        while (true) // Infinite loop to keep the wall moving back and forth
        {
            Vector3 targetPosition = movingToEnd ? endPosition : startPosition;

            // Move towards the target position
            while (Vector3.Distance(transform.position, targetPosition) > 0.01f)
            {
                transform.position = Vector3.MoveTowards(transform.position, targetPosition, moveSpeed * Time.deltaTime);
                yield return null; // Wait for the next frame
            }

            // Pause at the target position
            yield return new WaitForSeconds(pauseDuration);

            // Toggle the direction
            movingToEnd = !movingToEnd;
        }
    }
}
