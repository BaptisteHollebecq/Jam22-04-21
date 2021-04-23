using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Villageois : MonoBehaviour
{
    public GameObject blood;

    bool moving = false;

    private void Awake()
    {
        blood.SetActive(false);
    }

    private void Update()
    {
        if (!moving)
        {
            moving = true;
            float randX = Random.Range(-3f, 3f);
            float randZ = Random.Range(-3f, 3f);

            Vector3 position = new Vector3(transform.position.x + randX, transform.position.y, transform.position.z + randZ);

            transform.DOMove(position, Vector3.Distance(transform.position, position)).SetEase(Ease.Linear).OnComplete(() =>
            {
                moving = false;
            });
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Pinpon")
        {
            Dead();
        }
    }


    public void Dead()
    {
        blood.SetActive(true);
        transform.DOScaleY(0, .5f).OnComplete(() =>
        {
            Destroy(gameObject);
        });
    }
}
