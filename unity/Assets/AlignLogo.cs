using UnityEngine;
using System.Collections;

public class AlignLogo: MonoBehaviour
{
    private void OnGUI ()
    {
        guiTexture.pixelInset = new Rect(Screen.width - guiTexture.pixelInset.width, 0, guiTexture.pixelInset.width, guiTexture.pixelInset.height);
    }
}