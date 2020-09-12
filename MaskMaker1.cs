using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CC02U
{

    public class MaskMaker1
    {
        public static Texture2D Mask(Texture2D roughness, Texture2D ao, Texture2D metallic)
        {
            Texture2D mask = new Texture2D(roughness.width, roughness.height, TextureFormat.RGBAFloat, true);

            for (int x = 0; x < roughness.width; x++)
            {
                for (int y = 0; y < roughness.height; y++)
                {
                    float r = 0, g = 0, b = 0, a = 0;

                    a = 1 - roughness.GetPixel(x, y).r;

                    r = metallic.GetPixel(x, y).r;
                    g = ao.GetPixel(x, y).r;

                    mask.SetPixel(x, y, new Color(r, g, b, a));
                }
            }

            mask.Apply();
            return mask;
        }

        public static Texture2D GlossMask(Texture2D metal, Texture2D roughness)
        {
            Texture2D mask = new Texture2D(roughness.width, roughness.height, TextureFormat.RGBAFloat, true);

            for (int x = 0; x < roughness.width; x++)
            {
                for (int y = 0; y < roughness.height; y++)
                {
                    float r = 0, g = 0, b = 0, a = 0;

                    a = 1 - roughness.GetPixel(x, y).r;

                    r = metal.GetPixel(x, y).r;
                    g = metal.GetPixel(x, y).r;
                    b = metal.GetPixel(x, y).r;

                    mask.SetPixel(x, y, new Color(r, g, b, a));
                }
            }

            mask.Apply();
            return mask;
        }
    }
}