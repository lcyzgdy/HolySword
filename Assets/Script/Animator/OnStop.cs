using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class OnStop : StateMachineBehaviour
{
	private bool exited = false;

	public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		exited = false;
	}

	public override void OnStateUpdate(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		if (!exited && animatorStateInfo.normalizedTime >= 1f)
		{
			//Debug.Log(layerIndex);
			exited = true;
			animator.SetTrigger("StateExit" + layerIndex.ToString());
		}
	}
}
