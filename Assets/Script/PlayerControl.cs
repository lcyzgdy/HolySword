using System;
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
	[SerializeField] private Transform hand;
	[SerializeField] private Transform sword;
	[SerializeField] private LayerMask layerMask;
	private bool isPrepared;
	private bool canMove;
	private bool isRunning;

	public bool CanMove
	{
		get
		{
			return canMove;
		}

		set
		{
			canMove = value;
		}
	}

	// Use this for initialization
	void Start()
	{
		rigidbody = GetComponent<Rigidbody>();
		animControl = GetComponent<PlayerAnimControl>();
		isAttacking = false;
		isPrepared = true;
		canMove = true;
		isRunning = false;
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
		cancelTime -= Time.deltaTime;
		isRunning = false;

		if (cancelTime <= 0f)
		{
			isAttacking = false;
		}

		if (!isAttacking && canMove && Input.GetKey(KeyCode.W))
		{
			var direction = (transform.position - Camera.main.transform.position);
			direction.y = 0f;
			direction = direction.normalized;
			direction /= 3f;
			direction *= runSpeed;
			direction.y = vSpeed;
			velocity = direction;// new Vector3(0, vSpeed, 0);
			isRunning = true;
		}
		else
		{
			velocity = new Vector3(0, vSpeed, 0);
			isRunning = false;
		}
		if (canMove && Input.GetMouseButtonDown(0) && isPrepared)
		{
			isAttacking = true;
			cancelTime = 0.5f;
		}
		if (Input.GetKeyDown(KeyCode.X))
		{
			if (canMove && !isRunning)
			{
				isAttacking = false;
				isPrepared = !isPrepared;
				//canMove = false;
			}
			//if (isPrepared)
			//{
			//	ShowSword();
			//}
			//else
			//{
			//	HideSword();
			//}
		}

		if (rigidbody.isKinematic)
		{
			rigidbody.MovePosition(rigidbody.position + velocity * Time.deltaTime);
		}
		else
		{
			rigidbody.velocity = velocity;
		}

		if (isAttacking)
		{
			NormalAttack(sword.position - hand.position);
		}
	}

	private void NormalAttack(Vector3 direction)
	{
		Ray ray = new Ray(hand.position, direction);
		foreach (var item in Physics.RaycastAll(ray, direction.sqrMagnitude * 1.2f, layerMask))
		{
			print(item.transform.name);
		}
	}

	public void ShowSword()
	{
		hand.parent.GetComponent<MeshRenderer>().enabled = true;
	}

	public void HideSword()
	{
		hand.parent.GetComponent<MeshRenderer>().enabled = false;
	}

	private bool IsOnGround()
	{
		return true;
	}
}
