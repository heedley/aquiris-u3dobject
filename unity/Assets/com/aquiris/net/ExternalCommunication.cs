using UnityEngine;
using System.Collections;
using System;

public delegate void ExternalEventSimple (string p_evt, string p_data);

public class ExternalCommunication : MonoBehaviour 
{
    public const string CALLFLASHFUNCTION = "callFlashFunction";
    public const string CALLCOMPLETED = "callCompleted";
    public const string CALLLOADPROGRESS = "callLoadProgress";

    private static event ExternalEventSimple events;

    private void Awake ()
    {
        events = null;
    }

    public void OnExternalEvent (string p_param)
    {
        string evtName = null;
        string data = null;

        int auxIndex1 = p_param.IndexOf("(");
        int auxIndex2 = p_param.IndexOf(")");
        if (auxIndex1 != -1 && auxIndex2 != -1)
        {
            evtName = p_param.Substring(0, auxIndex1);

            data = p_param.Substring(auxIndex1 + 1, auxIndex2 - auxIndex1 - 1);

            if (events != null)
            {
                events(evtName, data);
            }
        }
        else
        {
            UnityEngine.Debug.Log("ExternalCommunication: ExternalEvent() - Invalid syntax! " + p_param);
        }
    }

    public static void add (ExternalEventSimple p_param)
    {
        events += p_param;
    }

    public static void remove (ExternalEventSimple p_param)
    {
        events -= p_param;
    }

    public static void callFlashFunction (string p_function, string p_flash_id, object[] p_params)
    {
        string params_to_flash = "";

        params_to_flash += p_function + "(";

        for (int i = 0; i < p_params.Length; i++)
        {
            params_to_flash += p_params[i].ToString() + ",";
        }

        params_to_flash = params_to_flash.Remove(params_to_flash.LastIndexOf(","), 1);

        params_to_flash += ")";

        Application.ExternalCall(CALLFLASHFUNCTION, p_flash_id, params_to_flash); 
    }

    public static void loadProgress (string flash_id, float p_progress)
    {
        Application.ExternalCall(CALLLOADPROGRESS, flash_id, p_progress.ToString().Replace(',', '.'));
    }

    public static void callCompletedLoading (string flash_id)
    {
        Application.ExternalCall(CALLCOMPLETED, flash_id);
    }
}