using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Wheel : MonoBehaviour
{
    PinPon pp;

    bool feed = false;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Pinpon")
        {
            pp = other.GetComponent<PinPon>();
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.tag == "Pinpon")
        {
            pp = null;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.tag == "Pinpon")
        {
            if (pp != null)
            {
                if (!feed)
                {
                    feed = true;
                    pp.Water += 0.01f;
                    if (pp.Water > 1)
                        pp.Water = 1;
                    StartCoroutine(ResetFeed());
                }
            }
        }
    }

    private IEnumerator ResetFeed()
    {
        yield return new WaitForSeconds(.2f);

        feed = false;
    }
}
