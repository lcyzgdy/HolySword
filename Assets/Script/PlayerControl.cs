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
	private bool isAttacking;
	private float cancelTime;
	private PlayerAnimControl animControl;
	// Use this for initialization
	void Start()
	{
		rigidbody = GetComponent<Rigidbody>();
		animControl = GetComponent<PlayerAnimControl>();
		isAttacking = false;
		cancelTime = 0.5f;
	}

	// Update is called once per frame
	void Update()
	{
		var velocity = rigidbody.velocity;
		//print(velocity);
		float y = Camera.main.transform.rotation.eulerAngles.y;
		float vSpeed = velocity.y;
		transform.rotation = Quaternion.Euler(0f, y, 0f);
		if (!isAttacking && Input.GetKey(KeyCode.W))
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

		if (Input.GetMouseButtonDown(0))
		{
			isAttacking = true;
			cancelTime = 0.5f;
		}

		cancelTime -= Time.deltaTime;
		if (cancelTime <= 0f)
		{
			isAttacking = false;
		}
		print(GameObject.Find("Sphere").transform.position);
		Debug.DrawRay(GameObject.Find("Sphere").transform.position, 
			GameObject.Find("Sphere").transform.rotation.eulerAngles, 
			Color.red);
	}
}
