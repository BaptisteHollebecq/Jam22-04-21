using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class House : MonoBehaviour
{
    public int Hp;
    public int MaxHp = 100;

    [Header("Fire")]
    public bool OnFire;
    float _fireHealTick;
    public GameObject Fire;

    public Transform HouseTransform;

    [Header("Ruin")]
    public GameObject Ruin;
    bool _ruinActivated;
    public float RuinLifeSpan;
    float _timeRuin;

    private void Start()
    {
        Fire.SetActive(false);
        Hp = MaxHp;

        Ruin.SetActive(false);
        //SpawnAnim();
    }

    private void Update()
    {
        if(_ruinActivated)
        {
            _timeRuin += Time.deltaTime;
            if(_timeRuin>=RuinLifeSpan)
            {
                DestroyAnim(Ruin.transform);
                VillageManager.Instance.Houses.Remove(this);
                Destroy(gameObject, 1.1f);
            }
        }

        if (OnFire || (Hp < MaxHp && !_ruinActivated))
        {
            _fireHealTick += Time.deltaTime;

            if(_fireHealTick>=VillageManager.Instance.TickRate)
            {
                if (OnFire)
                    Hp--;
                else
                    Hp++;

                _fireHealTick = 0;
            }
        }
        else
            _fireHealTick = 0;


        //burned;
        if(Hp<=0)
        {
            OnFire = false;
            DestroyAnim(HouseTransform, true);
            Fire.SetActive(false);
        }
    }

    void SpawnAnim()
    {
        Sequence sqc = DOTween.Sequence();
        sqc.Append(transform.DOScale(0, 0));
        sqc.Append(transform.DOScale(1.25f, .5f));
        sqc.Append(transform.DOScale(1,.5f));
        sqc.Play().OnComplete(() => sqc.Kill());
    }

    public void DestroyAnim(Transform obj,bool spawnDebris = false)
    {
        /*Sequence destroy = DOTween.Sequence();
        destroy.Append(obj.DOScale(1.25f, .5f));
        destroy.Append(obj.DOScale(0, .5f));
        destroy.Play().OnComplete(() => { SpawnRuin(spawnDebris);destroy.Kill(); });*/

        SpawnRuin(spawnDebris);
        obj.gameObject.SetActive(false);
    }

    void SpawnRuin(bool spawnDebris = false)
    {
        if (spawnDebris)
        {
            Ruin.SetActive(true);
            /*Sequence ruinSQC = DOTween.Sequence();
            ruinSQC.Append(Ruin.transform.DOScale(0, 0));
            ruinSQC.Append(Ruin.transform.DOScale(1.25f, .5f));
            ruinSQC.Append(Ruin.transform.DOScale(1, .5f));*/

            _ruinActivated = true;
        }
        else
        {
            DOTween.Kill(gameObject);
            VillageManager.Instance.Houses.Remove(this);
            Destroy(gameObject, 1.1f);
        }
    }
}
