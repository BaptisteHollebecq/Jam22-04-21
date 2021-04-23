using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using System;

public class PinPon : MonoBehaviour
{
    public float MoveSpeed = 5;

    public GameObject flags;
    public Animator animator;
    public GameObject WaterJet;

    [Header("PinPon's Stats")]
    [Range(0, 1)] public float Emotion = .5f;
    [Range(0, 1)] public float Water = .5f;
    [Range(0, 1)] public float Food = .5f;

    List<Vector3> Path = new List<Vector3>();
    List<GameObject> FlagPath = new List<GameObject>();
    Vector3 currentTarget;

    private void Awake()
    {
        WaterJet.SetActive(false);

        SoundManager.PlayLoop("choupix", SoundManager.Sound.GameMusic);

        StartCoroutine(Hungry());
        StartCoroutine(Mood());
    }

    IEnumerator Mood()
    {
        while (true)
        {
            yield return new WaitForSeconds(1);

            Emotion -= (Mathf.Abs(Mathf.Abs(Food) - .5f) / 25);
            if (Emotion < 0)
                Emotion = 0;
        }
    }

    IEnumerator Hungry()
    {
        while (true)
        {
            yield return new WaitForSeconds(1);
            Food -= 0.005f;
            if (Food < 0)
                Food = 0;
        }
    }

    public void Move()
    {
        transform.DOKill();
        float distance = Vector3.Distance(transform.position, currentTarget);
        transform.forward = (currentTarget - transform.position).normalized;
        animator.SetBool("Walk", true);
        transform.DOMove(currentTarget, distance / MoveSpeed).SetEase(Ease.Linear).OnComplete(() =>
        {
            Path.Remove(currentTarget);
            Destroy(FlagPath[0]);
            FlagPath.RemoveAt(0);
            currentTarget = Vector3.zero;
            animator.SetBool("Walk", false);
        });
    }

    public void AddPath(Vector3 point)
    {
        if (Path.Count < 5)
        {
            Vector3 position = point;
            point.y = transform.position.y;

            var inst = Instantiate(flags, new Vector3(point.x, .5f, point.z), Quaternion.identity);
            FlagPath.Add(inst);

            Path.Add(point);
        }
    }


    private void Update()
    {
        Movement();
    }

    private void Movement()
    {
        if (Path.Count != 0 && currentTarget == Vector3.zero)
        {
            currentTarget = Path[0];
            Move();
        }

    }
}
