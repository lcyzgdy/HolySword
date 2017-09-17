using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
	[SerializeField] private float angleSpeedX;
	[SerializeField] private float angleSpeedY;
	[SerializeField] private float angleSpeedZ;

	void Update()
	{
		transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x + Time.deltaTime * angleSpeedX,
			transform.rotation.eulerAngles.y + Time.deltaTime * angleSpeedY,
			transform.rotation.eulerAngles.z + Time.deltaTime * angleSpeedZ);
	}
}
