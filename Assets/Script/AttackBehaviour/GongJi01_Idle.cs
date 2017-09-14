using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GongJi01_Idle : StateMachineBehaviour
{
	public override void OnStateUpdate(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{

	}

	public override void OnStateIK(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		Debug.Log("A");
	}
}
