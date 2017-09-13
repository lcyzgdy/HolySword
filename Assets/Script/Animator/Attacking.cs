using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Attacking : StateMachineBehaviour
{
	private bool exited = false;
	public float attackingStateTime = 0.7f;

	public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		exited = false;
	}

	public override void OnStateUpdate(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		if (!exited && animator.GetBool("Attacking") && animatorStateInfo.normalizedTime >= attackingStateTime)
		{
			exited = true;
			animator.SetTrigger("StateExit" + layerIndex.ToString());
		}
		if (!exited && animatorStateInfo.normalizedTime >= 1f)
		{
			//Debug.Log(layerIndex);
			exited = true;
			animator.SetTrigger("StateExit" + layerIndex.ToString());
		}
	}
}
