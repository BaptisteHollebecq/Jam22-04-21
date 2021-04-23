using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireFighter : MonoBehaviour
{
    public PinPon pinpon;

    House house = null;

    bool water = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "House")
        {
            house = other.transform.parent.parent.GetComponent<House>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "House")
        {
            house = null;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "House")
        {
            if (!water && house.OnFire)
            {
                water = true;

                house.Hp += ((int)(pinpon.Emotion * 100) / 10);

                if (house.Hp >= house.MaxHp)
                {
                    house.OnFire = false;
                    house.Hp = house.MaxHp;
                    house.Fire.SetActive(false);
                }
                StartCoroutine(ResetWater());
            }
        }
        if (other.tag == "Villageois")
        {
            if (water && pinpon.Emotion >= 0.75f)
            {
                other.GetComponent<Villageois>().Dead();
            }
        }
    }

    private IEnumerator ResetWater()
    {
        yield return new WaitForSeconds(.2f);
        water = false;
    }
}
