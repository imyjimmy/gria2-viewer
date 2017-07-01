using UnityEngine;
using System.Collections;

public class Example_10_CameraMove : MonoBehaviour
{
    Vector3 origPosition;
	// Use this for initialization
	void Start ()
    {
        origPosition = transform.position;
    }
	
	// Update is called once per frame
	void Update ()
    {
        Vector3 newPos = origPosition + transform.forward * (-1 * Mathf.PingPong(Time.realtimeSinceStartup, 5) * 2);

        transform.position = newPos;
	}
}
