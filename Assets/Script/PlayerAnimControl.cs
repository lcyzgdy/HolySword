using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAnimControl : MonoBehaviour
{
	private Animator anim;
	private bool isAttacking;
	private bool isRunning;
	private float cancelTime = 0.5f;
	// Use this for initialization
	void Start()
	{
		anim = GetComponent<Animator>();
		isAttacking = false;
		isRunning = false;
	}

	// Update is called once per frame
	void Update()
	{
		//isAttacking = false;

		if (Input.GetKey(KeyCode.W))
		{
			isRunning = true;
		}
		else
		{
			isRunning = false;
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

		anim.SetBool("Attacking", isAttacking);
		anim.SetBool("Running", isRunning);
	}
}
