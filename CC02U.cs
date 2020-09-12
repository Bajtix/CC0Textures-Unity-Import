using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Net;
using Newtonsoft.Json;
using System.Linq;
using Unity.EditorCoroutines.Editor;
using System.Diagnostics;
using System;

namespace CC02U
{

    public class CC02U : EditorWindow
    {


        [System.Serializable]
        class MatEntry
        {
            public string Tags;
            public string AssetReleasedate;
            public int DownloadCount;
            public string AssetDataTypeID;
            public string CreationMethodID;
            public string CreatedUsingAssetID;
            public double PopularityScore;
            public string Weblink;

            public Dictionary<string, string> PreviewSphere;
            public Dictionary<string, MatDownload> Downloads;
        }

        [System.Serializable]
        public class MatDownload
        {
            public string Filetype;
            public long Size;
            public string PrettyDownloadLink;
            public string RawDownloadLink;
        }

        [System.Serializable]
        class CC0TCallback
        {
            public Dictionary<string, MatEntry> Assets;
            public string RequestTime;
        }


        [MenuItem("Tools/CC02U")]
        public static void ShowWindow()
        {
            EditorWindow.GetWindow<CC02U>().Show();
            EditorWindow.GetWindow<CC02U>().minSize = new Vector2(200, 130);
        }
        string searchQuery = "Search";
        string displayR = "nothing";
        Vector2 scrollpos;
        Dictionary<MatEntry, Texture2D> images;
        private void OnGUI()
        {
            GUIStyle headerStyle = new GUIStyle(EditorStyles.boldLabel);
            headerStyle.fontSize = 27;
            GUILayout.Label("CC0 Textures",headerStyle);

            GUILayout.Label("Search", EditorStyles.boldLabel);

            GUILayout.BeginHorizontal();
            searchQuery = EditorGUILayout.TextField(searchQuery);

            if (GUILayout.Button("Search"))
            {
                EditorCoroutineUtility.StartCoroutine(SendRequest(searchQuery), this);
            }
            GUILayout.EndHorizontal();


            if (images == null) return;
            float x = 0;
            float y = 0;
            foreach (Texture2D t in images.Values.ToArray())
            {
                if (x + 128 > position.width)
                {
                    x = 0;
                    y += 130;
                }
                x += 130;
            }
            Rect workArea = GUILayoutUtility.GetRect(10, 1, 10, 100000000);
            scrollpos = GUI.BeginScrollView(workArea, scrollpos, new Rect(0, 0, position.width - 20, y + 130), false, true);
            x = 0;
            y = 0;
            foreach (Texture2D t in images.Values.ToArray())
            {
                if (x + 128 > position.width)
                {
                    x = 0;
                    y += 130;
                }
                GUI.DrawTexture(new Rect(x, y, 128, 128), t);
                if (GUI.Button(new Rect(x, y, 64, 15), "Select"))
                {
                    CC0Downloader.ShowWindow(images.FirstOrDefault(f => f.Value == t).Key.Downloads);
                }

                if (GUI.Button(new Rect(x + 64, y, 64, 15), "Info"))
                {
                    Process.Start(images.FirstOrDefault(f => f.Value == t).Key.Weblink);
                }
                x += 130;


            }
            GUI.EndScrollView();
        }

        public IEnumerator SendRequest(string q)
        {


            WebClient wc = new WebClient();
            string callback = "";
            callback = wc.DownloadString($"https://cc0textures.com/api/v1/full_json?category=&q={q}&method=&type=&sort=Latest");
            wc.Dispose();

            CC0TCallback json = JsonConvert.DeserializeObject<CC0TCallback>(callback);
            images = new Dictionary<MatEntry, Texture2D>();
            foreach (string key in json.Assets.Keys.ToArray())
            {
                WWW www = new WWW(json.Assets[key].PreviewSphere.Values.ToArray()[0]);
                yield return www;
                Texture2D tex = new Texture2D(128, 128);
                www.LoadImageIntoTexture(tex);
                images.Add(json.Assets[key], tex);


            }

        }
    }
}