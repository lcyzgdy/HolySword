using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerControl : MonoBehaviour
{
	public float runSpeed = 10f;
	public float walkSpeed = 5f;
	private float maxSpeed;
	//private Vector3 direction;
	private new Rigidbody rigidbody;
	// Use this for initialization
	void Start()
	{
		rigidbody = GetComponent<Rigidbody>();
	}

	// Update is called once per frame
	void Update()
	{
		var velocity = rigidbody.velocity;
		//print(velocity);
		float y = Camera.main.transform.rotation.eulerAngles.y;
		float vSpeed = velocity.y;
		transform.rotation = Quaternion.Euler(0f, y, 0f);
		if (Input.GetKey(KeyCode.W))
		{
			var direction = (transform.position - Camera.main.transform.position);
			direction.y = 0f;
			direction = direction.normalized;
			direction /= 3f;
			direction *= runSpeed;
			direction.y = vSpeed;
			rigidbody.velocity = direction;// new Vector3(0, vSpeed, 0);
		}
		else
		{
			rigidbody.velocity = new Vector3(0, vSpeed, 0);
		}
	}
}
