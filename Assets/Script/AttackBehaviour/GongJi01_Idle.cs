using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using UnityEngine;

public class GongJi01_Idle : StateMachineBehaviour
{
	public LayerMask layerMask;
	private Transform weapon;
	private Rigidbody rigidbody;

	public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		rigidbody = animator.gameObject.transform.parent.GetComponent<Rigidbody>();
		weapon = GameObject.Find("Point_RH_sword_003").transform;
	}

	public override void OnStateUpdate(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		if (rigidbody == null)
		{
			Debug.Log("Rigidbody is null");
			return;
		}
		if (animatorStateInfo.normalizedTime - 0.3f < 0.02f && animatorStateInfo.normalizedTime - 0.3f > 0f)
		{
			Attack(animator.gameObject);
		}
		//Debug.Log(weapon.transform.TransformDirection(weapon.transform.eulerAngles));
	}

	private void Attack(GameObject obj)
	{
		RaycastHit hitInfo;
		Physics.Raycast(obj.transform.position, Camera.main.transform.rotation.eulerAngles, out hitInfo, 10f, layerMask);

		if (hitInfo.collider != null)
		{
			Debug.Log(hitInfo.transform.name);
		}
	}
}
