using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraController : MonoBehaviour
{
    public GameObject CameraMain;
    public float CameraSpeed = 5;
    public float ZoomSpeed = .2f;
    public float CameraMaxDistance = 100;
    public float CameraMinDistance = 25;
    public LayerMask GroundLayer;

     public PinPon pinpon;

    Camera cam;
    Vector3 MoveDirection;
    Vector3 CamDir;
    float CameraDistance;
    float zoom;

    private void Awake()
    {
        pinpon = FindObjectOfType<PinPon>();

        cam = Camera.main;
        CameraDistance = Vector3.Distance(transform.position, CameraMain.transform.position);
        CamDir = (CameraMain.transform.position - transform.position).normalized;

        SetCameraDistance();
    }

    private void Update()
    {
        MoveDirection = Vector3.zero;
        zoom = 0;

        UserInputs();
        Clicks();
    }


    private void LateUpdate()
    {
        Move();
    }

    private void Clicks()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, Mathf.Infinity, GroundLayer))
            {
                Debug.Log("touched ground");
                pinpon.AddPath(hit.point);
            }
        }
    }


    private void Move()
    {
        transform.Translate(MoveDirection, Space.World);

        CameraDistance += -zoom * ZoomSpeed;
        CameraDistance = Mathf.Clamp(CameraDistance, CameraMinDistance, CameraMaxDistance);

        SetCameraDistance();
    }

    private void UserInputs()
    {
        if (Input.GetButton("Left"))
        {
            MoveDirection.x = -CameraSpeed / 100;
        }
        if (Input.GetButton("Right"))
        {
            MoveDirection.x = CameraSpeed / 100;
        }
        if (Input.GetButton("Up"))
        {
            MoveDirection.z = CameraSpeed / 100;
        }
        if (Input.GetButton("Down"))
        {
            MoveDirection.z = -CameraSpeed / 100;
        }

        if (Input.GetAxis("Scroll") != 0)
        {
            zoom = Input.GetAxis("Scroll");
        }
    }

    private void SetCameraDistance()
    {
        CameraMain.transform.position = transform.position + CamDir * CameraDistance;
    }
}
