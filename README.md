
# CC0Download
Import plugin for Unity to download assets from https://cc0textures.com directly from the UI!

## IMPORTANT: PLEASE UPDATE IF USING v1
> I made a lot of very important changes and fixes, and v1 is now totally obsolete. For your own convinience, please update it if you are using the package.

## Download
To use it, just import the package included in *releases* tab. The tool window is in Tools/CC02U.

## Compatibility and changelogs
Should work with all Unity versions above 2019.4.0f1, and quite possibly some older ones. Supports SRP (this includes HDRP and URP)

Works natively with URP, but for HDRP: (TODO: fix this issue)
1. Select the shader graph Assets/CC0Download/CC0TexGraph
2. Click "View generated code" in the inspector (or in other versions you may need to select the master PBR node in the Graph Editor)
3. Copy the code
4. Open the shader file "CC02UShader" and paste
5. At the top of this file change the name to "CC02U Shader"
6. Should work now.

### v2.0
**(NEW)** Works with both HDRP/URP! Check the compatibility section.

*Dropped the Standard Pipeline support because of the switch to custom shaders.*

**Bugfix** Now it should not crash when assets are not found or when the site is unreachable

**Bugfix** Fixed some UI issues

And some other things.

## Credits
All materials credit goes to [CC0Textures.com](https://cc0textures.com)

Used the [DotNetZip For Unity](https://github.com/r2d2rigo/dotnetzip-for-unity) lib. (included in project)

Requires JSON.Net [UnityPackage](https://github.com/jilleJr/Newtonsoft.Json-for-Unity)
And requires **EditorCoroutines package** which can be obtained via the package manager
May or may not work without **ShaderGraph package** 

## Bugs and issues
The tool contains many bugs, which will eventually get fixed. Please report all issues to the Issues section.

## Usage
You are free to use it in any of your projects without giving any credit to me, but you can give credit to CC0Textures.com !
