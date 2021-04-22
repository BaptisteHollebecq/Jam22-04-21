using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralGeneration : MonoBehaviour
{
    [Header("Bounds")]
    public Vector2 Bounds;
    public float SizeSphereCast;
    public LayerMask Ground;
    public LayerMask House;

    [Header("Instance")]
    public List<GameObject> HouseInstances;
    public int StartSpawns;

    [Header("Debug")]
    public float TimeSpawn;
    public bool EnableDebug;

    float _time;

    Transform _houses;

    private void Start()
    {
        if(StartSpawns>0)
        {
            for (int i = 0; i < StartSpawns; i++)
            {
                int tries = 0;
                while (!GenerateHouse())
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

    void Update()
    {
        if(EnableDebug)
        {
            _time += Time.deltaTime;
            if(_time>=TimeSpawn)
            {
                _time = 0;

                int tries = 0;
                while (!GenerateHouse())
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

    public bool GenerateHouse()
    {
        Rect spawnPlace = new Rect((transform.position.x - Bounds.x/2), (transform.position.z - Bounds.y/2), Bounds.x, Bounds.y);

        Vector3 spawn = new Vector3(Random.Range(spawnPlace.xMin,spawnPlace.xMax),transform.position.y,Random.Range(spawnPlace.yMin,spawnPlace.yMax));

        Ray ray = new Ray(spawn, Vector3.down);

        if (!Physics.Raycast(ray, out RaycastHit hit, Mathf.Infinity, Ground))
            return false;
        else
        {
            if (Physics.OverlapSphere(hit.point, SizeSphereCast, House).Length>0)
            {
                Debug.Log("Collision with another house");
                return false;
            }
            else
            {
                PlaceHouse(hit.point);
                return true;
            }
        }
    }

    void PlaceHouse(Vector3 SpawnPlace)
    {
        if(_houses == null)
        {
            _houses = new GameObject("Houses").GetComponent<Transform>();
        }

        Quaternion rot = Quaternion.Euler(0, Random.Range(-45, 45),0);

        GameObject selected = HouseInstances[Random.Range(0, HouseInstances.Count)];

        GameObject instance = Instantiate(selected, SpawnPlace, rot, _houses);

        if (instance.TryGetComponent(out House component))
            VillageManager.Instance.Houses.Add(component);
        else
            Debug.Log("Can't Find House Component");
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireCube(transform.position, new Vector3(Bounds.x,0,Bounds.y));
        
        Gizmos.color = Color.cyan;
        Gizmos.DrawWireSphere(transform.position + Vector3.up * 10, SizeSphereCast);
    }
}
