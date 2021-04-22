using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cantine : MonoBehaviour
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
                    pp.Food += 0.01f;
                    pp.Emotion += 0.01f;
                    if (pp.Emotion > 1)
                        pp.Emotion = 1;
                    if (pp.Food > 1)
                        pp.Food = 1;
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
