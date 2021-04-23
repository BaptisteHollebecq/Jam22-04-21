using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    private void Start()
    {
        SoundManager.PlayLoop("Music", SoundManager.Sound.MenuMusic, 1, true);
    }

    public void PlayButton()
    {
        SceneManager.LoadScene(1);
    }

    public void QuitButton()
    {
        Application.Quit();
    }

    public void PlayHappySound()
    {
        SoundManager.PlaySound(SoundManager.Sound.PinponHappy);
    }

    public void ClickSound()
    {
        SoundManager.PlaySound(SoundManager.Sound.MenuSelect);
    }
}
