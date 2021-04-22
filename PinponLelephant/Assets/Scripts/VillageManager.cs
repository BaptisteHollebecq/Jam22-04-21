using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class VillageManager : MonoBehaviour
{
    public ProceduralGeneration HouseGenerator;

    static VillageManager _instance;

    public static VillageManager Instance { get { return _instance; } }

    public List<House> Houses;

    [Header("Values")]
    public int MaxHouses;
    int _maxHouses;
    public float FirePercent;
    public float ScoreMultiplier;
    float _scoreMultiplier;

    [Header("Time")]
    public Vector2 MinMaxTimeRoll;
    public int TimeRollDivisions;
    float _timeRoll;
    float _timeForRoll;
    float _timeForRegulation;
    float _divide;

    public float RegulationTick;
    public float TickRate;


    [Header("Debug")]
    [Range(0,1)]public float Happiness;
    public bool EnableDebug;

    private void Awake()
    {
        Houses = new List<House>();

        if (_instance != null && _instance != this)
            Destroy(gameObject);

        _instance = this;
    }

    private void Start()
    {
        _timeRoll = MinMaxTimeRoll.y;
        _divide = MinMaxTimeRoll.y / TimeRollDivisions;

        _maxHouses = MaxHouses;
        _scoreMultiplier = ScoreMultiplier;
    }

    private void Update()
    {
        _timeForRoll += Time.deltaTime;
        _timeForRegulation += Time.deltaTime;

        if(_timeForRoll>=_timeRoll)
        {
            RollFire();

            _timeForRoll = 0;

            if (_timeRoll > MinMaxTimeRoll.x)
                _timeRoll -= _divide;
        }

        if(_timeForRegulation>=RegulationTick)
        {
            _timeForRegulation = 0;

            if (Houses.Count > MaxHouses)
                RegulateVillage();

            if(Houses.Count<MaxHouses)
                RegulateVillage(false);
        }

        //debug Hapinesss
        if(EnableDebug)
        {
            MaxHouses = (int)(_maxHouses*Happiness);
            ScoreMultiplier = _scoreMultiplier * Happiness;
        }
        else
        {
            //intégrer le taff de baptiste
        }
    }

    private void RegulateVillage(bool delete = true)
    {
        if(delete)
        {
            List<House> housesToDelete = new List<House>();
            Houses.Shuffle();
            for (int i = Houses.Count - 1; i >= 0; i--)
            {
                if (Houses.Count > MaxHouses)
                {
                    if (Houses[i].OnFire)
                        continue;
                    else
                    {
                        housesToDelete.Add(Houses[i]);
                        Houses.RemoveAt(i);
                    }
                }
            }

            DeleteHouse(housesToDelete);
        }
        else
        {
            int newHouses = Random.Range(1, MaxHouses - Houses.Count);
            if (newHouses > 3)
                newHouses = 3;

            for (int i =0;i<newHouses;i++)
            {
                int tries = 0;
                while (!HouseGenerator.GenerateHouse())
                {
                    tries++;
                    if (tries == 3)
                    {
                        Debug.Log("unable to spawn");
                        break;
                    }
                }
            }
        }
    }

    void RollFire()
    {
        foreach(House house in Houses)
        {
            if (house.OnFire)
                continue;
            else
            {
                float fire = Random.Range(FirePercent, 100);
                if (fire == FirePercent)
                    house.OnFire = true;
            }
        }
    }

    public void DeleteHouse(List<House> houses)
    {
        foreach (House house in houses)
            DestroyHouse(house);
    }

    public void DestroyHouse(House house)
    {
        house.DestroyAnim(house.transform);
    }
}
