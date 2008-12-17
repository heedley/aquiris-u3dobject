using UnityEngine;
using System.Collections;

public class Profiler: MonoBehaviour
{
    private string functionToCall;
    private string parameters;
    private string flashId;
    public static string console;
    private bool loading;

    private void Start ()
    {
        loading = false;
        console = "";
        functionToCall = "";
        parameters = "";
        flashId = "flash_content";

        ExternalCommunication.add(EventListener);
    }

    public void EventListener (string p_evt, string p_data)
    {
        console += "ExternalEvent: " + p_evt + "(" + p_data + ")\n";
    }
    
    private void OnGUI ()
    {
        GUI.Label(new Rect(5, 5, 100, 25), "Flash Id:");
        flashId = GUI.TextField(new Rect(110, 5, 300, 25), flashId);

        GUI.Label(new Rect(5, 30, 100, 25), "Function to Call:");
        functionToCall = GUI.TextField(new Rect(110, 30, 300, 25), functionToCall);

        GUI.Label(new Rect(5, 55, 100, 25), "Parameters:");
        parameters = GUI.TextField(new Rect(110, 55, 300, 25), parameters);

        if (GUI.Button(new Rect(370, 80, 40, 25), "Send"))
        {
            ExternalCommunication.callFlashFunction(functionToCall, flashId, (object[])parameters.Split(','));
        }

        if (GUI.Button(new Rect(240, 80, 120, 25), "Simulate Loading"))
        {
            StartCoroutine(SimulateLoading(flashId));
        }

        GUI.TextArea(new Rect(5, 110, 400, 150), console);
    }

    private IEnumerator SimulateLoading (string flash_id)
    {
        if (!loading)
        {
            loading = true;

            float loadProgress = 0;

            while (loadProgress + Time.deltaTime * 0.3f < 1f)
            {
                loadProgress += Time.deltaTime * 0.3f;

                ExternalCommunication.loadProgress(flash_id, loadProgress);

                yield return 0;
            }

            ExternalCommunication.callCompletedLoading(flash_id);

            loading = false;
        }
    }

    public void TestFunction (string p_data)
    {
        console += "TestFunction('" + p_data + "');\n";
    }
}