using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Villageois : MonoBehaviour
{
    bool moving = false;

    private void Update()
    {
        if (!moving)
        {
            moving = true;
            float randX = Random.Range(-1f, 1f);
            float randZ = Random.Range(-1f, 1f);

            Vector3 position = new Vector3(transform.position.x + randX, transform.position.y, transform.position.z + randZ);

            transform.DOMove(position, Vector3.Distance(transform.position, position)).SetEase(Ease.Linear).OnComplete(() =>
            {
                moving = false;
            });
        }
    }

    public void Dead()
    {

    }
}
