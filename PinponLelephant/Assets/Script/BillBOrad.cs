using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BillBOrad : MonoBehaviour
{
    Camera cam;

    private void Awake()
    {
        cam = Camera.main;    
    }

    private void LateUpdate()
    {
        transform.LookAt(-cam.transform.forward);
    }
}
