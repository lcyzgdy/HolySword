using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnprepareHideSword : StateMachineBehaviour
{
	public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		var playerControl = animator.transform.parent.GetComponent<PlayerControl>();
		if (playerControl == null)
		{
			playerControl = animator.gameObject.GetComponent<PlayerControl>();
		}
		playerControl.CanMove = false;
	}

	public override void OnStateExit(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		var playerControl = animator.transform.parent.GetComponent<PlayerControl>();
		if (playerControl == null)
		{
			playerControl = animator.gameObject.GetComponent<PlayerControl>();
		}
		playerControl.HideSword();
		playerControl.CanMove = true;
	}
}
