using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using Unity.EditorCoroutines.Editor;
using System.IO;
namespace CC02U
{
    public class TextureSettings : AssetPostprocessor
    {



        void OnPostprocessTexture(Texture2D texture)
        {
            Debug.Log("Applied settings");

            if (texture == null)
            {
                Debug.Log("Fucking doesn't work");
                return;
            }
            TextureImporter ti = (TextureImporter)assetImporter;
            if (assetPath.Contains("_Normal"))
            {



                if (ti.textureType != TextureImporterType.NormalMap)
                {

                    ti.isReadable = true;
                    var set = ti.GetPlatformTextureSettings("Standalone");
                    set.overridden = true;
                    set.format = TextureImporterFormat.RGBA32;
                    ti.SetPlatformTextureSettings(set);
                    ti.textureType = TextureImporterType.NormalMap;
                    ti.SaveAndReimport();
                    AssetDatabase.Refresh();
                    Debug.Log("Inverting normalmap");
                    for (int m = 0; m < texture.mipmapCount; m++)
                    {
                        Color[] c = texture.GetPixels(m);

                        for (int i = 0; i < c.Length; i++)
                        {
                            c[i].r = 1 - c[i].r;
                            c[i].b = 1 - c[i].b;
                            c[i].g = 1 - c[i].g;
                        }
                        texture.SetPixels(c, m);
                    }
                    texture.Apply();
                    ti.SaveAndReimport();
                    Debug.Log("Done");

                    AssetDatabase.Refresh();
                    ti.SaveAndReimport();

                    AssetDatabase.Refresh();
                    ti.SaveAndReimport();
                }
            }
            else if (assetPath.Contains("Roughness") || assetPath.Contains("AmbientOcclusion"))
            {
                ti.isReadable = true;
                var set = ti.GetPlatformTextureSettings("Standalone");
                set.overridden = true;
                set.format = TextureImporterFormat.RGBA32;
                set.maxTextureSize = 2048;
                ti.sRGBTexture = false;
                ti.mipmapEnabled = false;
                ti.SetPlatformTextureSettings(set);


                ti.SaveAndReimport();
            }


        }
    }
}