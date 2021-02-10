using Ionic.Zip;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using Unity.EditorCoroutines.Editor;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace CC02U {

    public class CC0Downloader : EditorWindow {

        public Dictionary<string, CC02U.MatDownload> download;

        public static void ShowWindow(Dictionary<string, CC02U.MatDownload> d) {
            var w = EditorWindow.GetWindow<CC0Downloader>();
            w.Show();
            w.download = d;
            w.maxSize = new Vector2(250, w.download.Keys.Count * 20);
            w.minSize = new Vector2(250, w.download.Keys.Count * 20);

        }


        public static Texture2D LoadIMG(string filePath) {

            Texture2D tex = null;
            byte[] fileData;

            if (File.Exists(filePath)) {
                fileData = File.ReadAllBytes(filePath);
                tex = new Texture2D(2, 2);
                tex.LoadImage(fileData); //..this will auto-resize the texture dimensions.
            }
            return tex;
        }

        private void OnGUI() {
            if (Directory.Exists(Application.dataPath + "/Temp/")) {
                Directory.Delete(Application.dataPath + "/Temp/", true);
            }

            foreach (string k in download.Keys) {
                if (download[k].Filetype.Contains("zip")) {
                    if (GUILayout.Button("Download " + k)) {
                        WebClient wc = new WebClient();
                        Directory.CreateDirectory(Application.dataPath + "/Temp/");
                        wc.DownloadFile(download[k].RawDownloadLink, Application.dataPath + "/Temp/downloadTex.zip");
                        wc.Dispose();
                        Directory.CreateDirectory(Application.dataPath + "/Materials/Textures");
                        var zf = ZipFile.Read(Application.dataPath + "/Temp/downloadTex.zip");
                        zf.ExtractAll(Application.dataPath + "/Temp");
                        zf.Dispose();
                        string[] textureFiles = Directory.GetFiles(Application.dataPath + "/Temp").Where(x => { return x.Contains("_"); }).ToArray();

                        string texName = Path.GetFileName(textureFiles[0]).Split('_')[0];
                        string ext = Path.GetExtension(textureFiles[0]);
                        string res = Path.GetFileName(textureFiles[0]).Split('_')[1];

                        foreach (string f in textureFiles) {
                            if (!File.Exists(Application.dataPath + "/Materials/Textures/" + Path.GetFileName(f))) {
                                File.Move(f, Application.dataPath + "/Materials/Textures/" + Path.GetFileName(f));
                            }
                        }

                        this.Close();


                        EditorCoroutineUtility.StartCoroutine(StartImport(texName, res, ext), this);
                    }
                }
            }

        }

        private IEnumerator StartImport(string texName, string res, string ext) {
            Debug.Log("Downloaded. Importing...");
            Debug.Log("Waiting for 1 seconds for the processes to finish...");
            string fname = texName + "_" + res + "_Color" + ext;
            yield return new WaitForSecondsRealtime(1);

            AssetDatabase.Refresh();

            Texture2D colorTex = AssetDatabase.LoadAssetAtPath("Assets/Materials/Textures/" + fname, typeof(Texture2D)) as Texture2D;

            AssetDatabase.ImportAsset("Assets/Materials/Textures/" + fname, ImportAssetOptions.ImportRecursive);

            fname = texName + "_" + res + "_Normal" + ext;
            Texture2D normalTex = AssetDatabase.LoadAssetAtPath("Assets/Materials/Textures/" + fname, typeof(Texture2D)) as Texture2D;

            Debug.Log("Loaded base maps. ");

            AssetDatabase.Refresh();

            // LOAD TEXTURES

            Texture2D roughnessTex = new Texture2D(colorTex.width, colorTex.height);
            Texture2D aoTex = new Texture2D(colorTex.width, colorTex.height);
            Texture2D metalTex = new Texture2D(colorTex.width, colorTex.height);
            Texture2D heightTex = new Texture2D(colorTex.width, colorTex.height);

            fname = texName + "_" + res + "_Roughness" + ext;
            Debug.Log("Searching for " + (Application.dataPath + "/Materials/Textures/" + fname));
            if (File.Exists(Application.dataPath + "/Materials/Textures/" + fname)) {
                Debug.Log("Loaded Roughness map.");

                roughnessTex = AssetDatabase.LoadAssetAtPath("Assets/Materials/Textures/" + fname, typeof(Texture2D)) as Texture2D;

                //roughnessTex = duplicateTexture(roughnessTex);
            }
            fname = texName + "_" + res + "_AmbientOcclusion" + ext;
            Debug.Log("Searching for " + (Application.dataPath + "/Materials/Textures/" + fname));
            if (File.Exists(Application.dataPath + "/Materials/Textures/" + fname)) {
                Debug.Log("Loaded AO map.");

                aoTex = AssetDatabase.LoadAssetAtPath("Assets/Materials/Textures/" + fname, typeof(Texture2D)) as Texture2D;

                //aoTex = duplicateTexture(aoTex);
            }

            fname = texName + "_" + res + "_Metalness" + ext;
            Debug.Log("Searching for " + (Application.dataPath + "/Materials/Textures/" + fname));
            if (File.Exists(Application.dataPath + "/Materials/Textures/" + fname)) {
                Debug.Log("Loaded Metallic map.");

                metalTex = AssetDatabase.LoadAssetAtPath("Assets/Materials/Textures/" + fname, typeof(Texture2D)) as Texture2D;

               // metalTex = duplicateTexture(metalTex);
            }

            fname = texName + "_" + res + "_Displacement" + ext;
            Debug.Log("Searching for " + (Application.dataPath + "/Materials/Textures/" + fname));
            if (File.Exists(Application.dataPath + "/Materials/Textures/" + fname)) {
                Debug.Log("Loaded Height map.");

                heightTex = AssetDatabase.LoadAssetAtPath("Assets/Materials/Textures/" + fname, typeof(Texture2D)) as Texture2D;

                //heightTex = duplicateTexture(metalTex);
            }

            AssetDatabase.Refresh();

            Debug.Log("Waiting for processes to finish...");
            yield return new WaitForSecondsRealtime(1);


            // CREATE THE MATERIAL

            Debug.Log("Creating the material");
            Shader ashder = Shader.Find("CC02U Shader");
            Material material = new Material(ashder);

            material.SetTexture("_MainTex", colorTex);
            material.SetTexture("_NormalMap", normalTex);
            material.SetTexture("_AO", aoTex);
            material.SetTexture("_Roughness", roughnessTex);
            material.SetTexture("_Metallic", metalTex);
            material.SetTexture("_Height", heightTex);

            AssetDatabase.CreateAsset(material, "Assets/Materials/" + texName +".mat");
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
        }

        private Texture2D duplicateTexture(Texture2D source) {
            RenderTexture renderTex = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.sRGB);

            Graphics.Blit(source, renderTex);
            RenderTexture previous = RenderTexture.active;
            RenderTexture.active = renderTex;
            Texture2D readableText = new Texture2D(source.width, source.height);
            readableText.ReadPixels(new Rect(0, 0, renderTex.width, renderTex.height), 0, 0);
            readableText.Apply();
            RenderTexture.active = previous;
            RenderTexture.ReleaseTemporary(renderTex);
            return readableText;
        }

        private bool IsHDRP() {
            return GraphicsSettings.renderPipelineAsset.GetType().Name.Contains("HD");
        }

        private bool IsURP() {
            return GraphicsSettings.renderPipelineAsset.GetType().Name.Contains("Universal") || GraphicsSettings.renderPipelineAsset.GetType().Name.Contains("Lightweight");
        }
    }
}