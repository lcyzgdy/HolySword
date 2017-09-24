using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PrintPosition : MonoBehaviour
{
	private void Update()
	{
		print(transform.eulerAngles);
	}
}
