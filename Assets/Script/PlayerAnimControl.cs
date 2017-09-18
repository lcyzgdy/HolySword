using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimControl : MonoBehaviour
{
	private Animator anim;
	private bool isAttacking;
	private bool isRunning;
	private float cancelTime = 0.5f;
	private bool isPrepared;
	//private bool canMove;
	// Use this for initialization
	void Start()
	{
		anim = GetComponent<Animator>();
		isAttacking = false;
		isRunning = false;
		isPrepared = true;
		//canMove = true;
	}

	// Update is called once per frame
	void Update()
	{
		//isAttacking = false;
		if (!isAttacking)
		{
			if (Input.GetKey(KeyCode.W))
			{
				isRunning = true;
			}
			else
			{
				isRunning = false;
			}
		}
		else
		{
			isRunning = false;
		}

		if (Input.GetMouseButtonDown(0) && isPrepared)
		{
			isAttacking = true;
			cancelTime = 0.5f;
		}

		if (Input.GetKeyDown(KeyCode.X))
		{
			if (!isRunning)
			{
				isPrepared = !isPrepared;
				isAttacking = false;
				anim.SetTrigger("ChangeState");
				isPrepared = !isPrepared;
			}
		}

		cancelTime -= Time.deltaTime;
		if (cancelTime <= 0f)
		{
			isAttacking = false;
		}

		anim.SetBool("Attacking", isAttacking);
		anim.SetBool("Running", isRunning);
	}
}
