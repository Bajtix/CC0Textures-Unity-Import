Shader "CC02U Shader"
{
    Properties
    {
        [NoScaleOffset] _MainTex("Albedo", 2D) = "white" {}
        [NoScaleOffset]_NormalMap("Normal Map", 2D) = "white" {}
        _NormalS("Normal Strength", Float) = 0.1
        [NoScaleOffset]_AO("Ambient Occlusion", 2D) = "white" {}
        _AOR("Ambient Occlusion Remap", Vector) = (0, 1, 0, 0)
        [NoScaleOffset]_Roughness("Roughness", 2D) = "white" {}
        _RoughnessR("Roughness Remap", Vector) = (0, 1, 0, 0)
        [NoScaleOffset]_Metallic("Metallic", 2D) = "white" {}
        _MetallicR("MetallicRemap", Vector) = (0, 1, 0, 0)
        [NoScaleOffset]_Height("Heightmap", 2D) = "white" {}
        _AlphaClipThreshold("Alpha Clip", Float) = 0
        [NoScaleOffset]_Emission("Emission", 2D) = "black" {}
        _EmissionS("EmissionStrength", Float) = 0
        _HeightS("Height Scale", Float) = 1
    }
        SubShader
        {
            Tags
            {
                "RenderPipeline" = "UniversalPipeline"
                "RenderType" = "Opaque"
                "Queue" = "Geometry+0"
            }

            Pass
            {
                Name "Universal Forward"
                Tags
                {
                    "LightMode" = "UniversalForward"
                }

            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>


            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            // GraphKeywords: <None>

            // Defines
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define SHADERPASS_FORWARD

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _NormalS;
            float2 _AOR;
            float2 _RoughnessR;
            float2 _MetallicR;
            float _AlphaClipThreshold;
            float _EmissionS;
            float _HeightS;
            CBUFFER_END
            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
            TEXTURE2D(_NormalMap); SAMPLER(sampler_NormalMap); float4 _NormalMap_TexelSize;
            TEXTURE2D(_AO); SAMPLER(sampler_AO); float4 _AO_TexelSize;
            TEXTURE2D(_Roughness); SAMPLER(sampler_Roughness); float4 _Roughness_TexelSize;
            TEXTURE2D(_Metallic); SAMPLER(sampler_Metallic); float4 _Metallic_TexelSize;
            TEXTURE2D(_Height); SAMPLER(sampler_Height); float4 _Height_TexelSize;
            TEXTURE2D(_Emission); SAMPLER(sampler_Emission); float4 _Emission_TexelSize;
            SAMPLER(_SampleTexture2D_5A42DBC9_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_5062E993_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_4B67B37D_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_20A0DB7E_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_C80EE170_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_33809B0B_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_E5EB970E_Sampler_3_Linear_Repeat);

            // Graph Functions

            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }

            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }

            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }

            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }

            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }

            void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A / B;
            }

            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }

            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A + B;
            }

            struct Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e
            {
                float3 TangentSpaceViewDirection;
            };

            void SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(float Vector1_C55D14B, float Vector1_82B59319, float2 Vector2_46023C87, Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e IN, out float4 Output_1)
            {
                float2 _Property_FF5A7212_Out_0 = Vector2_46023C87;
                float _Property_2EB7FC75_Out_0 = Vector1_C55D14B;
                float _Multiply_A257210A_Out_2;
                Unity_Multiply_float(_Property_2EB7FC75_Out_0, 0.083, _Multiply_A257210A_Out_2);
                float _Add_B83225FD_Out_2;
                Unity_Add_float(_Multiply_A257210A_Out_2, 0.5, _Add_B83225FD_Out_2);
                float _Property_ED1D42AD_Out_0 = Vector1_82B59319;
                float _Multiply_9DD2E35C_Out_2;
                Unity_Multiply_float(_Add_B83225FD_Out_2, _Property_ED1D42AD_Out_0, _Multiply_9DD2E35C_Out_2);
                float _Divide_7273B47D_Out_2;
                Unity_Divide_float(_Property_ED1D42AD_Out_0, 2, _Divide_7273B47D_Out_2);
                float _Subtract_30507953_Out_2;
                Unity_Subtract_float(_Multiply_9DD2E35C_Out_2, _Divide_7273B47D_Out_2, _Subtract_30507953_Out_2);
                float3 _Normalize_55E59F12_Out_1;
                Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_55E59F12_Out_1);
                float3 _Add_F1ED545D_Out_2;
                Unity_Add_float3(_Normalize_55E59F12_Out_1, float3(0, 0, 0.43), _Add_F1ED545D_Out_2);
                float _Split_737A2D40_R_1 = _Add_F1ED545D_Out_2[0];
                float _Split_737A2D40_G_2 = _Add_F1ED545D_Out_2[1];
                float _Split_737A2D40_B_3 = _Add_F1ED545D_Out_2[2];
                float _Split_737A2D40_A_4 = 0;
                float2 _Vector2_383706FF_Out_0 = float2(_Split_737A2D40_R_1, _Split_737A2D40_G_2);
                float2 _Divide_EB7CA811_Out_2;
                Unity_Divide_float2(_Vector2_383706FF_Out_0, (_Split_737A2D40_B_3.xx), _Divide_EB7CA811_Out_2);
                float2 _Multiply_CD8E17E4_Out_2;
                Unity_Multiply_float((_Subtract_30507953_Out_2.xx), _Divide_EB7CA811_Out_2, _Multiply_CD8E17E4_Out_2);
                float2 _Add_28BC651D_Out_2;
                Unity_Add_float2(_Property_FF5A7212_Out_0, _Multiply_CD8E17E4_Out_2, _Add_28BC651D_Out_2);
                Output_1 = (float4(_Add_28BC651D_Out_2, 0.0, 1.0));
            }

            void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
            {
                Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
            }

            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }

            void Unity_Remap_float4(float4 In, float2 InMinMax, float2 OutMinMax, out float4 Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            void Unity_OneMinus_float4(float4 In, out float4 Out)
            {
                Out = 1 - In;
            }

            // Graph Vertex
            // GraphVertex: <None>

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceTangent;
                float3 WorldSpaceBiTangent;
                float3 WorldSpaceViewDirection;
                float3 TangentSpaceViewDirection;
                float4 uv0;
            };

            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float _Property_19945B30_Out_0 = _HeightS;
                float4 _UV_7FEAA842_Out_0 = IN.uv0;
                float4 _SampleTexture2D_5A42DBC9_RGBA_0 = SAMPLE_TEXTURE2D(_Height, sampler_Height, (_UV_7FEAA842_Out_0.xy));
                float _SampleTexture2D_5A42DBC9_R_4 = _SampleTexture2D_5A42DBC9_RGBA_0.r;
                float _SampleTexture2D_5A42DBC9_G_5 = _SampleTexture2D_5A42DBC9_RGBA_0.g;
                float _SampleTexture2D_5A42DBC9_B_6 = _SampleTexture2D_5A42DBC9_RGBA_0.b;
                float _SampleTexture2D_5A42DBC9_A_7 = _SampleTexture2D_5A42DBC9_RGBA_0.a;
                Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e _ParallaxOffset_8073D4F7;
                _ParallaxOffset_8073D4F7.TangentSpaceViewDirection = IN.TangentSpaceViewDirection;
                float4 _ParallaxOffset_8073D4F7_Output_1;
                SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(_Property_19945B30_Out_0, (_SampleTexture2D_5A42DBC9_RGBA_0).x, (_UV_7FEAA842_Out_0.xy), _ParallaxOffset_8073D4F7, _ParallaxOffset_8073D4F7_Output_1);
                float4 _SampleTexture2D_5062E993_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, (_ParallaxOffset_8073D4F7_Output_1.xy));
                float _SampleTexture2D_5062E993_R_4 = _SampleTexture2D_5062E993_RGBA_0.r;
                float _SampleTexture2D_5062E993_G_5 = _SampleTexture2D_5062E993_RGBA_0.g;
                float _SampleTexture2D_5062E993_B_6 = _SampleTexture2D_5062E993_RGBA_0.b;
                float _SampleTexture2D_5062E993_A_7 = _SampleTexture2D_5062E993_RGBA_0.a;
                float4 _SampleTexture2D_4B67B37D_RGBA_0 = SAMPLE_TEXTURE2D(_NormalMap, sampler_NormalMap, (_ParallaxOffset_8073D4F7_Output_1.xy));
                float _SampleTexture2D_4B67B37D_R_4 = _SampleTexture2D_4B67B37D_RGBA_0.r;
                float _SampleTexture2D_4B67B37D_G_5 = _SampleTexture2D_4B67B37D_RGBA_0.g;
                float _SampleTexture2D_4B67B37D_B_6 = _SampleTexture2D_4B67B37D_RGBA_0.b;
                float _SampleTexture2D_4B67B37D_A_7 = _SampleTexture2D_4B67B37D_RGBA_0.a;
                float _Property_239629FE_Out_0 = _NormalS;
                float3 _NormalStrength_3C162D0F_Out_2;
                Unity_NormalStrength_float((_SampleTexture2D_4B67B37D_RGBA_0.xyz), _Property_239629FE_Out_0, _NormalStrength_3C162D0F_Out_2);
                float4 _SampleTexture2D_20A0DB7E_RGBA_0 = SAMPLE_TEXTURE2D(_Emission, sampler_Emission, (_ParallaxOffset_8073D4F7_Output_1.xy));
                float _SampleTexture2D_20A0DB7E_R_4 = _SampleTexture2D_20A0DB7E_RGBA_0.r;
                float _SampleTexture2D_20A0DB7E_G_5 = _SampleTexture2D_20A0DB7E_RGBA_0.g;
                float _SampleTexture2D_20A0DB7E_B_6 = _SampleTexture2D_20A0DB7E_RGBA_0.b;
                float _SampleTexture2D_20A0DB7E_A_7 = _SampleTexture2D_20A0DB7E_RGBA_0.a;
                float _Property_5D4350C9_Out_0 = _EmissionS;
                float4 _Multiply_BA21BA5A_Out_2;
                Unity_Multiply_float(_SampleTexture2D_20A0DB7E_RGBA_0, (_Property_5D4350C9_Out_0.xxxx), _Multiply_BA21BA5A_Out_2);
                float4 _SampleTexture2D_C80EE170_RGBA_0 = SAMPLE_TEXTURE2D(_Metallic, sampler_Metallic, (_ParallaxOffset_8073D4F7_Output_1.xy));
                float _SampleTexture2D_C80EE170_R_4 = _SampleTexture2D_C80EE170_RGBA_0.r;
                float _SampleTexture2D_C80EE170_G_5 = _SampleTexture2D_C80EE170_RGBA_0.g;
                float _SampleTexture2D_C80EE170_B_6 = _SampleTexture2D_C80EE170_RGBA_0.b;
                float _SampleTexture2D_C80EE170_A_7 = _SampleTexture2D_C80EE170_RGBA_0.a;
                float2 _Property_82C8C940_Out_0 = _MetallicR;
                float4 _Remap_B9B63EB8_Out_3;
                Unity_Remap_float4(_SampleTexture2D_C80EE170_RGBA_0, float2 (0, 1), _Property_82C8C940_Out_0, _Remap_B9B63EB8_Out_3);
                float4 _SampleTexture2D_33809B0B_RGBA_0 = SAMPLE_TEXTURE2D(_Roughness, sampler_Roughness, (_ParallaxOffset_8073D4F7_Output_1.xy));
                float _SampleTexture2D_33809B0B_R_4 = _SampleTexture2D_33809B0B_RGBA_0.r;
                float _SampleTexture2D_33809B0B_G_5 = _SampleTexture2D_33809B0B_RGBA_0.g;
                float _SampleTexture2D_33809B0B_B_6 = _SampleTexture2D_33809B0B_RGBA_0.b;
                float _SampleTexture2D_33809B0B_A_7 = _SampleTexture2D_33809B0B_RGBA_0.a;
                float4 _OneMinus_6AD4893B_Out_1;
                Unity_OneMinus_float4(_SampleTexture2D_33809B0B_RGBA_0, _OneMinus_6AD4893B_Out_1);
                float2 _Property_48EC7D26_Out_0 = _RoughnessR;
                float4 _Remap_F6F79A40_Out_3;
                Unity_Remap_float4(_OneMinus_6AD4893B_Out_1, float2 (0, 1), _Property_48EC7D26_Out_0, _Remap_F6F79A40_Out_3);
                float4 _SampleTexture2D_E5EB970E_RGBA_0 = SAMPLE_TEXTURE2D(_AO, sampler_AO, (_ParallaxOffset_8073D4F7_Output_1.xy));
                float _SampleTexture2D_E5EB970E_R_4 = _SampleTexture2D_E5EB970E_RGBA_0.r;
                float _SampleTexture2D_E5EB970E_G_5 = _SampleTexture2D_E5EB970E_RGBA_0.g;
                float _SampleTexture2D_E5EB970E_B_6 = _SampleTexture2D_E5EB970E_RGBA_0.b;
                float _SampleTexture2D_E5EB970E_A_7 = _SampleTexture2D_E5EB970E_RGBA_0.a;
                float2 _Property_D6EFDE84_Out_0 = _AOR;
                float4 _Remap_FD3E4A71_Out_3;
                Unity_Remap_float4(_SampleTexture2D_E5EB970E_RGBA_0, float2 (0, 1), _Property_D6EFDE84_Out_0, _Remap_FD3E4A71_Out_3);
                float _Property_39DC0DB7_Out_0 = _AlphaClipThreshold;
                surface.Albedo = (_SampleTexture2D_5062E993_RGBA_0.xyz);
                surface.Normal = _NormalStrength_3C162D0F_Out_2;
                surface.Emission = (_Multiply_BA21BA5A_Out_2.xyz);
                surface.Metallic = (_Remap_B9B63EB8_Out_3).x;
                surface.Smoothness = (_Remap_F6F79A40_Out_3).x;
                surface.Occlusion = (_Remap_FD3E4A71_Out_3).x;
                surface.Alpha = _SampleTexture2D_5062E993_A_7;
                surface.AlphaClipThreshold = _Property_39DC0DB7_Out_0;
                return surface;
            }

            // --------------------------------------------------
            // Structs and Packing

            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 tangentWS;
                float4 texCoord0;
                float3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                float3 sh;
                #endif
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if defined(LIGHTMAP_ON)
                #endif
                #if !defined(LIGHTMAP_ON)
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float4 interp03 : TEXCOORD3;
                float3 interp04 : TEXCOORD4;
                float2 interp05 : TEXCOORD5;
                float3 interp06 : TEXCOORD6;
                float4 interp07 : TEXCOORD7;
                float4 interp08 : TEXCOORD8;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp05.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp06.xyz = input.sh;
                #endif
                output.interp07.xyzw = input.fogFactorAndVertexLight;
                output.interp08.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                output.viewDirectionWS = input.interp04.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp05.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp06.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp07.xyzw;
                output.shadowCoord = input.interp08.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                // use bitangent on the fly like in hdrp
                // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph

                // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                // This is explained in section 2.2 in "surface gradient based bump mapping framework"
                output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                output.WorldSpaceBiTangent = renormFactor * bitang;

                output.WorldSpaceViewDirection = input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                output.uv0 = input.texCoord0;
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }


            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

                // Render State
                Blend One Zero, One Zero
                Cull Back
                ZTest LEqual
                ZWrite On
                // ColorMask: <None>


                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                // Debug
                // <None>

                // --------------------------------------------------
                // Pass

                // Pragmas
                #pragma prefer_hlslcc gles
                #pragma exclude_renderers d3d11_9x
                #pragma target 2.0
                #pragma multi_compile_instancing

                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>

                // Defines
                #define _AlphaClip 1
                #define _NORMALMAP 1
                #define _NORMAL_DROPOFF_TS 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_NORMAL_WS
                #define VARYINGS_NEED_TANGENT_WS
                #define VARYINGS_NEED_TEXCOORD0
                #define VARYINGS_NEED_VIEWDIRECTION_WS
                #define SHADERPASS_SHADOWCASTER

                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                // --------------------------------------------------
                // Graph

                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float _NormalS;
                float2 _AOR;
                float2 _RoughnessR;
                float2 _MetallicR;
                float _AlphaClipThreshold;
                float _EmissionS;
                float _HeightS;
                CBUFFER_END
                TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
                TEXTURE2D(_NormalMap); SAMPLER(sampler_NormalMap); float4 _NormalMap_TexelSize;
                TEXTURE2D(_AO); SAMPLER(sampler_AO); float4 _AO_TexelSize;
                TEXTURE2D(_Roughness); SAMPLER(sampler_Roughness); float4 _Roughness_TexelSize;
                TEXTURE2D(_Metallic); SAMPLER(sampler_Metallic); float4 _Metallic_TexelSize;
                TEXTURE2D(_Height); SAMPLER(sampler_Height); float4 _Height_TexelSize;
                TEXTURE2D(_Emission); SAMPLER(sampler_Emission); float4 _Emission_TexelSize;
                SAMPLER(_SampleTexture2D_5A42DBC9_Sampler_3_Linear_Repeat);
                SAMPLER(_SampleTexture2D_5062E993_Sampler_3_Linear_Repeat);

                // Graph Functions

                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }

                void Unity_Add_float(float A, float B, out float Out)
                {
                    Out = A + B;
                }

                void Unity_Divide_float(float A, float B, out float Out)
                {
                    Out = A / B;
                }

                void Unity_Subtract_float(float A, float B, out float Out)
                {
                    Out = A - B;
                }

                void Unity_Normalize_float3(float3 In, out float3 Out)
                {
                    Out = normalize(In);
                }

                void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                {
                    Out = A + B;
                }

                void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A / B;
                }

                void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
                {
                    Out = A * B;
                }

                void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                {
                    Out = A + B;
                }

                struct Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e
                {
                    float3 TangentSpaceViewDirection;
                };

                void SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(float Vector1_C55D14B, float Vector1_82B59319, float2 Vector2_46023C87, Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e IN, out float4 Output_1)
                {
                    float2 _Property_FF5A7212_Out_0 = Vector2_46023C87;
                    float _Property_2EB7FC75_Out_0 = Vector1_C55D14B;
                    float _Multiply_A257210A_Out_2;
                    Unity_Multiply_float(_Property_2EB7FC75_Out_0, 0.083, _Multiply_A257210A_Out_2);
                    float _Add_B83225FD_Out_2;
                    Unity_Add_float(_Multiply_A257210A_Out_2, 0.5, _Add_B83225FD_Out_2);
                    float _Property_ED1D42AD_Out_0 = Vector1_82B59319;
                    float _Multiply_9DD2E35C_Out_2;
                    Unity_Multiply_float(_Add_B83225FD_Out_2, _Property_ED1D42AD_Out_0, _Multiply_9DD2E35C_Out_2);
                    float _Divide_7273B47D_Out_2;
                    Unity_Divide_float(_Property_ED1D42AD_Out_0, 2, _Divide_7273B47D_Out_2);
                    float _Subtract_30507953_Out_2;
                    Unity_Subtract_float(_Multiply_9DD2E35C_Out_2, _Divide_7273B47D_Out_2, _Subtract_30507953_Out_2);
                    float3 _Normalize_55E59F12_Out_1;
                    Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_55E59F12_Out_1);
                    float3 _Add_F1ED545D_Out_2;
                    Unity_Add_float3(_Normalize_55E59F12_Out_1, float3(0, 0, 0.43), _Add_F1ED545D_Out_2);
                    float _Split_737A2D40_R_1 = _Add_F1ED545D_Out_2[0];
                    float _Split_737A2D40_G_2 = _Add_F1ED545D_Out_2[1];
                    float _Split_737A2D40_B_3 = _Add_F1ED545D_Out_2[2];
                    float _Split_737A2D40_A_4 = 0;
                    float2 _Vector2_383706FF_Out_0 = float2(_Split_737A2D40_R_1, _Split_737A2D40_G_2);
                    float2 _Divide_EB7CA811_Out_2;
                    Unity_Divide_float2(_Vector2_383706FF_Out_0, (_Split_737A2D40_B_3.xx), _Divide_EB7CA811_Out_2);
                    float2 _Multiply_CD8E17E4_Out_2;
                    Unity_Multiply_float((_Subtract_30507953_Out_2.xx), _Divide_EB7CA811_Out_2, _Multiply_CD8E17E4_Out_2);
                    float2 _Add_28BC651D_Out_2;
                    Unity_Add_float2(_Property_FF5A7212_Out_0, _Multiply_CD8E17E4_Out_2, _Add_28BC651D_Out_2);
                    Output_1 = (float4(_Add_28BC651D_Out_2, 0.0, 1.0));
                }

                // Graph Vertex
                // GraphVertex: <None>

                // Graph Pixel
                struct SurfaceDescriptionInputs
                {
                    float3 WorldSpaceNormal;
                    float3 WorldSpaceTangent;
                    float3 WorldSpaceBiTangent;
                    float3 WorldSpaceViewDirection;
                    float3 TangentSpaceViewDirection;
                    float4 uv0;
                };

                struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float _Property_19945B30_Out_0 = _HeightS;
                    float4 _UV_7FEAA842_Out_0 = IN.uv0;
                    float4 _SampleTexture2D_5A42DBC9_RGBA_0 = SAMPLE_TEXTURE2D(_Height, sampler_Height, (_UV_7FEAA842_Out_0.xy));
                    float _SampleTexture2D_5A42DBC9_R_4 = _SampleTexture2D_5A42DBC9_RGBA_0.r;
                    float _SampleTexture2D_5A42DBC9_G_5 = _SampleTexture2D_5A42DBC9_RGBA_0.g;
                    float _SampleTexture2D_5A42DBC9_B_6 = _SampleTexture2D_5A42DBC9_RGBA_0.b;
                    float _SampleTexture2D_5A42DBC9_A_7 = _SampleTexture2D_5A42DBC9_RGBA_0.a;
                    Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e _ParallaxOffset_8073D4F7;
                    _ParallaxOffset_8073D4F7.TangentSpaceViewDirection = IN.TangentSpaceViewDirection;
                    float4 _ParallaxOffset_8073D4F7_Output_1;
                    SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(_Property_19945B30_Out_0, (_SampleTexture2D_5A42DBC9_RGBA_0).x, (_UV_7FEAA842_Out_0.xy), _ParallaxOffset_8073D4F7, _ParallaxOffset_8073D4F7_Output_1);
                    float4 _SampleTexture2D_5062E993_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, (_ParallaxOffset_8073D4F7_Output_1.xy));
                    float _SampleTexture2D_5062E993_R_4 = _SampleTexture2D_5062E993_RGBA_0.r;
                    float _SampleTexture2D_5062E993_G_5 = _SampleTexture2D_5062E993_RGBA_0.g;
                    float _SampleTexture2D_5062E993_B_6 = _SampleTexture2D_5062E993_RGBA_0.b;
                    float _SampleTexture2D_5062E993_A_7 = _SampleTexture2D_5062E993_RGBA_0.a;
                    float _Property_39DC0DB7_Out_0 = _AlphaClipThreshold;
                    surface.Alpha = _SampleTexture2D_5062E993_A_7;
                    surface.AlphaClipThreshold = _Property_39DC0DB7_Out_0;
                    return surface;
                }

                // --------------------------------------------------
                // Structs and Packing

                // Generated Type: Attributes
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };

                // Generated Type: Varyings
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float3 normalWS;
                    float4 tangentWS;
                    float4 texCoord0;
                    float3 viewDirectionWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                // Generated Type: PackedVaryings
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    float3 interp00 : TEXCOORD0;
                    float4 interp01 : TEXCOORD1;
                    float4 interp02 : TEXCOORD2;
                    float3 interp03 : TEXCOORD3;
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                // Packed Type: Varyings
                PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output = (PackedVaryings)0;
                    output.positionCS = input.positionCS;
                    output.interp00.xyz = input.normalWS;
                    output.interp01.xyzw = input.tangentWS;
                    output.interp02.xyzw = input.texCoord0;
                    output.interp03.xyz = input.viewDirectionWS;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                // Unpacked Type: Varyings
                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output = (Varyings)0;
                    output.positionCS = input.positionCS;
                    output.normalWS = input.interp00.xyz;
                    output.tangentWS = input.interp01.xyzw;
                    output.texCoord0 = input.interp02.xyzw;
                    output.viewDirectionWS = input.interp03.xyz;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                // --------------------------------------------------
                // Build Graph Inputs

                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                    // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                    float3 unnormalizedNormalWS = input.normalWS;
                    const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                    // use bitangent on the fly like in hdrp
                    // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                    float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                    float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                    output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph

                    // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                    // This is explained in section 2.2 in "surface gradient based bump mapping framework"
                    output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                    output.WorldSpaceBiTangent = renormFactor * bitang;

                    output.WorldSpaceViewDirection = input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                    float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                    output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                    output.uv0 = input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                    return output;
                }


                // --------------------------------------------------
                // Main

                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

                ENDHLSL
            }

            Pass
            {
                Name "DepthOnly"
                Tags
                {
                    "LightMode" = "DepthOnly"
                }

                    // Render State
                    Blend One Zero, One Zero
                    Cull Back
                    ZTest LEqual
                    ZWrite On
                    ColorMask 0


                    HLSLPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag

                    // Debug
                    // <None>

                    // --------------------------------------------------
                    // Pass

                    // Pragmas
                    #pragma prefer_hlslcc gles
                    #pragma exclude_renderers d3d11_9x
                    #pragma target 2.0
                    #pragma multi_compile_instancing

                    // Keywords
                    // PassKeywords: <None>
                    // GraphKeywords: <None>

                    // Defines
                    #define _AlphaClip 1
                    #define _NORMALMAP 1
                    #define _NORMAL_DROPOFF_TS 1
                    #define ATTRIBUTES_NEED_NORMAL
                    #define ATTRIBUTES_NEED_TANGENT
                    #define ATTRIBUTES_NEED_TEXCOORD0
                    #define VARYINGS_NEED_NORMAL_WS
                    #define VARYINGS_NEED_TANGENT_WS
                    #define VARYINGS_NEED_TEXCOORD0
                    #define VARYINGS_NEED_VIEWDIRECTION_WS
                    #define SHADERPASS_DEPTHONLY

                    // Includes
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                    // --------------------------------------------------
                    // Graph

                    // Graph Properties
                    CBUFFER_START(UnityPerMaterial)
                    float _NormalS;
                    float2 _AOR;
                    float2 _RoughnessR;
                    float2 _MetallicR;
                    float _AlphaClipThreshold;
                    float _EmissionS;
                    float _HeightS;
                    CBUFFER_END
                    TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
                    TEXTURE2D(_NormalMap); SAMPLER(sampler_NormalMap); float4 _NormalMap_TexelSize;
                    TEXTURE2D(_AO); SAMPLER(sampler_AO); float4 _AO_TexelSize;
                    TEXTURE2D(_Roughness); SAMPLER(sampler_Roughness); float4 _Roughness_TexelSize;
                    TEXTURE2D(_Metallic); SAMPLER(sampler_Metallic); float4 _Metallic_TexelSize;
                    TEXTURE2D(_Height); SAMPLER(sampler_Height); float4 _Height_TexelSize;
                    TEXTURE2D(_Emission); SAMPLER(sampler_Emission); float4 _Emission_TexelSize;
                    SAMPLER(_SampleTexture2D_5A42DBC9_Sampler_3_Linear_Repeat);
                    SAMPLER(_SampleTexture2D_5062E993_Sampler_3_Linear_Repeat);

                    // Graph Functions

                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }

                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }

                    void Unity_Normalize_float3(float3 In, out float3 Out)
                    {
                        Out = normalize(In);
                    }

                    void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                    {
                        Out = A / B;
                    }

                    void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                    {
                        Out = A + B;
                    }

                    struct Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e
                    {
                        float3 TangentSpaceViewDirection;
                    };

                    void SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(float Vector1_C55D14B, float Vector1_82B59319, float2 Vector2_46023C87, Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e IN, out float4 Output_1)
                    {
                        float2 _Property_FF5A7212_Out_0 = Vector2_46023C87;
                        float _Property_2EB7FC75_Out_0 = Vector1_C55D14B;
                        float _Multiply_A257210A_Out_2;
                        Unity_Multiply_float(_Property_2EB7FC75_Out_0, 0.083, _Multiply_A257210A_Out_2);
                        float _Add_B83225FD_Out_2;
                        Unity_Add_float(_Multiply_A257210A_Out_2, 0.5, _Add_B83225FD_Out_2);
                        float _Property_ED1D42AD_Out_0 = Vector1_82B59319;
                        float _Multiply_9DD2E35C_Out_2;
                        Unity_Multiply_float(_Add_B83225FD_Out_2, _Property_ED1D42AD_Out_0, _Multiply_9DD2E35C_Out_2);
                        float _Divide_7273B47D_Out_2;
                        Unity_Divide_float(_Property_ED1D42AD_Out_0, 2, _Divide_7273B47D_Out_2);
                        float _Subtract_30507953_Out_2;
                        Unity_Subtract_float(_Multiply_9DD2E35C_Out_2, _Divide_7273B47D_Out_2, _Subtract_30507953_Out_2);
                        float3 _Normalize_55E59F12_Out_1;
                        Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_55E59F12_Out_1);
                        float3 _Add_F1ED545D_Out_2;
                        Unity_Add_float3(_Normalize_55E59F12_Out_1, float3(0, 0, 0.43), _Add_F1ED545D_Out_2);
                        float _Split_737A2D40_R_1 = _Add_F1ED545D_Out_2[0];
                        float _Split_737A2D40_G_2 = _Add_F1ED545D_Out_2[1];
                        float _Split_737A2D40_B_3 = _Add_F1ED545D_Out_2[2];
                        float _Split_737A2D40_A_4 = 0;
                        float2 _Vector2_383706FF_Out_0 = float2(_Split_737A2D40_R_1, _Split_737A2D40_G_2);
                        float2 _Divide_EB7CA811_Out_2;
                        Unity_Divide_float2(_Vector2_383706FF_Out_0, (_Split_737A2D40_B_3.xx), _Divide_EB7CA811_Out_2);
                        float2 _Multiply_CD8E17E4_Out_2;
                        Unity_Multiply_float((_Subtract_30507953_Out_2.xx), _Divide_EB7CA811_Out_2, _Multiply_CD8E17E4_Out_2);
                        float2 _Add_28BC651D_Out_2;
                        Unity_Add_float2(_Property_FF5A7212_Out_0, _Multiply_CD8E17E4_Out_2, _Add_28BC651D_Out_2);
                        Output_1 = (float4(_Add_28BC651D_Out_2, 0.0, 1.0));
                    }

                    // Graph Vertex
                    // GraphVertex: <None>

                    // Graph Pixel
                    struct SurfaceDescriptionInputs
                    {
                        float3 WorldSpaceNormal;
                        float3 WorldSpaceTangent;
                        float3 WorldSpaceBiTangent;
                        float3 WorldSpaceViewDirection;
                        float3 TangentSpaceViewDirection;
                        float4 uv0;
                    };

                    struct SurfaceDescription
                    {
                        float Alpha;
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float _Property_19945B30_Out_0 = _HeightS;
                        float4 _UV_7FEAA842_Out_0 = IN.uv0;
                        float4 _SampleTexture2D_5A42DBC9_RGBA_0 = SAMPLE_TEXTURE2D(_Height, sampler_Height, (_UV_7FEAA842_Out_0.xy));
                        float _SampleTexture2D_5A42DBC9_R_4 = _SampleTexture2D_5A42DBC9_RGBA_0.r;
                        float _SampleTexture2D_5A42DBC9_G_5 = _SampleTexture2D_5A42DBC9_RGBA_0.g;
                        float _SampleTexture2D_5A42DBC9_B_6 = _SampleTexture2D_5A42DBC9_RGBA_0.b;
                        float _SampleTexture2D_5A42DBC9_A_7 = _SampleTexture2D_5A42DBC9_RGBA_0.a;
                        Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e _ParallaxOffset_8073D4F7;
                        _ParallaxOffset_8073D4F7.TangentSpaceViewDirection = IN.TangentSpaceViewDirection;
                        float4 _ParallaxOffset_8073D4F7_Output_1;
                        SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(_Property_19945B30_Out_0, (_SampleTexture2D_5A42DBC9_RGBA_0).x, (_UV_7FEAA842_Out_0.xy), _ParallaxOffset_8073D4F7, _ParallaxOffset_8073D4F7_Output_1);
                        float4 _SampleTexture2D_5062E993_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, (_ParallaxOffset_8073D4F7_Output_1.xy));
                        float _SampleTexture2D_5062E993_R_4 = _SampleTexture2D_5062E993_RGBA_0.r;
                        float _SampleTexture2D_5062E993_G_5 = _SampleTexture2D_5062E993_RGBA_0.g;
                        float _SampleTexture2D_5062E993_B_6 = _SampleTexture2D_5062E993_RGBA_0.b;
                        float _SampleTexture2D_5062E993_A_7 = _SampleTexture2D_5062E993_RGBA_0.a;
                        float _Property_39DC0DB7_Out_0 = _AlphaClipThreshold;
                        surface.Alpha = _SampleTexture2D_5062E993_A_7;
                        surface.AlphaClipThreshold = _Property_39DC0DB7_Out_0;
                        return surface;
                    }

                    // --------------------------------------------------
                    // Structs and Packing

                    // Generated Type: Attributes
                    struct Attributes
                    {
                        float3 positionOS : POSITION;
                        float3 normalOS : NORMAL;
                        float4 tangentOS : TANGENT;
                        float4 uv0 : TEXCOORD0;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : INSTANCEID_SEMANTIC;
                        #endif
                    };

                    // Generated Type: Varyings
                    struct Varyings
                    {
                        float4 positionCS : SV_POSITION;
                        float3 normalWS;
                        float4 tangentWS;
                        float4 texCoord0;
                        float3 viewDirectionWS;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    // Generated Type: PackedVaryings
                    struct PackedVaryings
                    {
                        float4 positionCS : SV_POSITION;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        float3 interp00 : TEXCOORD0;
                        float4 interp01 : TEXCOORD1;
                        float4 interp02 : TEXCOORD2;
                        float3 interp03 : TEXCOORD3;
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    // Packed Type: Varyings
                    PackedVaryings PackVaryings(Varyings input)
                    {
                        PackedVaryings output = (PackedVaryings)0;
                        output.positionCS = input.positionCS;
                        output.interp00.xyz = input.normalWS;
                        output.interp01.xyzw = input.tangentWS;
                        output.interp02.xyzw = input.texCoord0;
                        output.interp03.xyz = input.viewDirectionWS;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    // Unpacked Type: Varyings
                    Varyings UnpackVaryings(PackedVaryings input)
                    {
                        Varyings output = (Varyings)0;
                        output.positionCS = input.positionCS;
                        output.normalWS = input.interp00.xyz;
                        output.tangentWS = input.interp01.xyzw;
                        output.texCoord0 = input.interp02.xyzw;
                        output.viewDirectionWS = input.interp03.xyz;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    // --------------------------------------------------
                    // Build Graph Inputs

                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                    {
                        SurfaceDescriptionInputs output;
                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                        float3 unnormalizedNormalWS = input.normalWS;
                        const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                        // use bitangent on the fly like in hdrp
                        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph

                        // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                        // This is explained in section 2.2 in "surface gradient based bump mapping framework"
                        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                        output.WorldSpaceBiTangent = renormFactor * bitang;

                        output.WorldSpaceViewDirection = input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                        float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                        output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                        output.uv0 = input.texCoord0;
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                    #else
                    #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                    #endif
                    #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                        return output;
                    }


                    // --------------------------------------------------
                    // Main

                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

                    ENDHLSL
                }

                Pass
                {
                    Name "Meta"
                    Tags
                    {
                        "LightMode" = "Meta"
                    }

                        // Render State
                        Blend One Zero, One Zero
                        Cull Back
                        ZTest LEqual
                        ZWrite On
                        // ColorMask: <None>


                        HLSLPROGRAM
                        #pragma vertex vert
                        #pragma fragment frag

                        // Debug
                        // <None>

                        // --------------------------------------------------
                        // Pass

                        // Pragmas
                        #pragma prefer_hlslcc gles
                        #pragma exclude_renderers d3d11_9x
                        #pragma target 2.0

                        // Keywords
                        #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
                        // GraphKeywords: <None>

                        // Defines
                        #define _AlphaClip 1
                        #define _NORMALMAP 1
                        #define _NORMAL_DROPOFF_TS 1
                        #define ATTRIBUTES_NEED_NORMAL
                        #define ATTRIBUTES_NEED_TANGENT
                        #define ATTRIBUTES_NEED_TEXCOORD0
                        #define ATTRIBUTES_NEED_TEXCOORD1
                        #define ATTRIBUTES_NEED_TEXCOORD2
                        #define VARYINGS_NEED_NORMAL_WS
                        #define VARYINGS_NEED_TANGENT_WS
                        #define VARYINGS_NEED_TEXCOORD0
                        #define VARYINGS_NEED_VIEWDIRECTION_WS
                        #define SHADERPASS_META

                        // Includes
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                        // --------------------------------------------------
                        // Graph

                        // Graph Properties
                        CBUFFER_START(UnityPerMaterial)
                        float _NormalS;
                        float2 _AOR;
                        float2 _RoughnessR;
                        float2 _MetallicR;
                        float _AlphaClipThreshold;
                        float _EmissionS;
                        float _HeightS;
                        CBUFFER_END
                        TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
                        TEXTURE2D(_NormalMap); SAMPLER(sampler_NormalMap); float4 _NormalMap_TexelSize;
                        TEXTURE2D(_AO); SAMPLER(sampler_AO); float4 _AO_TexelSize;
                        TEXTURE2D(_Roughness); SAMPLER(sampler_Roughness); float4 _Roughness_TexelSize;
                        TEXTURE2D(_Metallic); SAMPLER(sampler_Metallic); float4 _Metallic_TexelSize;
                        TEXTURE2D(_Height); SAMPLER(sampler_Height); float4 _Height_TexelSize;
                        TEXTURE2D(_Emission); SAMPLER(sampler_Emission); float4 _Emission_TexelSize;
                        SAMPLER(_SampleTexture2D_5A42DBC9_Sampler_3_Linear_Repeat);
                        SAMPLER(_SampleTexture2D_5062E993_Sampler_3_Linear_Repeat);
                        SAMPLER(_SampleTexture2D_20A0DB7E_Sampler_3_Linear_Repeat);

                        // Graph Functions

                        void Unity_Multiply_float(float A, float B, out float Out)
                        {
                            Out = A * B;
                        }

                        void Unity_Add_float(float A, float B, out float Out)
                        {
                            Out = A + B;
                        }

                        void Unity_Divide_float(float A, float B, out float Out)
                        {
                            Out = A / B;
                        }

                        void Unity_Subtract_float(float A, float B, out float Out)
                        {
                            Out = A - B;
                        }

                        void Unity_Normalize_float3(float3 In, out float3 Out)
                        {
                            Out = normalize(In);
                        }

                        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                        {
                            Out = A + B;
                        }

                        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                        {
                            Out = A / B;
                        }

                        void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
                        {
                            Out = A * B;
                        }

                        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                        {
                            Out = A + B;
                        }

                        struct Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e
                        {
                            float3 TangentSpaceViewDirection;
                        };

                        void SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(float Vector1_C55D14B, float Vector1_82B59319, float2 Vector2_46023C87, Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e IN, out float4 Output_1)
                        {
                            float2 _Property_FF5A7212_Out_0 = Vector2_46023C87;
                            float _Property_2EB7FC75_Out_0 = Vector1_C55D14B;
                            float _Multiply_A257210A_Out_2;
                            Unity_Multiply_float(_Property_2EB7FC75_Out_0, 0.083, _Multiply_A257210A_Out_2);
                            float _Add_B83225FD_Out_2;
                            Unity_Add_float(_Multiply_A257210A_Out_2, 0.5, _Add_B83225FD_Out_2);
                            float _Property_ED1D42AD_Out_0 = Vector1_82B59319;
                            float _Multiply_9DD2E35C_Out_2;
                            Unity_Multiply_float(_Add_B83225FD_Out_2, _Property_ED1D42AD_Out_0, _Multiply_9DD2E35C_Out_2);
                            float _Divide_7273B47D_Out_2;
                            Unity_Divide_float(_Property_ED1D42AD_Out_0, 2, _Divide_7273B47D_Out_2);
                            float _Subtract_30507953_Out_2;
                            Unity_Subtract_float(_Multiply_9DD2E35C_Out_2, _Divide_7273B47D_Out_2, _Subtract_30507953_Out_2);
                            float3 _Normalize_55E59F12_Out_1;
                            Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_55E59F12_Out_1);
                            float3 _Add_F1ED545D_Out_2;
                            Unity_Add_float3(_Normalize_55E59F12_Out_1, float3(0, 0, 0.43), _Add_F1ED545D_Out_2);
                            float _Split_737A2D40_R_1 = _Add_F1ED545D_Out_2[0];
                            float _Split_737A2D40_G_2 = _Add_F1ED545D_Out_2[1];
                            float _Split_737A2D40_B_3 = _Add_F1ED545D_Out_2[2];
                            float _Split_737A2D40_A_4 = 0;
                            float2 _Vector2_383706FF_Out_0 = float2(_Split_737A2D40_R_1, _Split_737A2D40_G_2);
                            float2 _Divide_EB7CA811_Out_2;
                            Unity_Divide_float2(_Vector2_383706FF_Out_0, (_Split_737A2D40_B_3.xx), _Divide_EB7CA811_Out_2);
                            float2 _Multiply_CD8E17E4_Out_2;
                            Unity_Multiply_float((_Subtract_30507953_Out_2.xx), _Divide_EB7CA811_Out_2, _Multiply_CD8E17E4_Out_2);
                            float2 _Add_28BC651D_Out_2;
                            Unity_Add_float2(_Property_FF5A7212_Out_0, _Multiply_CD8E17E4_Out_2, _Add_28BC651D_Out_2);
                            Output_1 = (float4(_Add_28BC651D_Out_2, 0.0, 1.0));
                        }

                        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                        {
                            Out = A * B;
                        }

                        // Graph Vertex
                        // GraphVertex: <None>

                        // Graph Pixel
                        struct SurfaceDescriptionInputs
                        {
                            float3 WorldSpaceNormal;
                            float3 WorldSpaceTangent;
                            float3 WorldSpaceBiTangent;
                            float3 WorldSpaceViewDirection;
                            float3 TangentSpaceViewDirection;
                            float4 uv0;
                        };

                        struct SurfaceDescription
                        {
                            float3 Albedo;
                            float3 Emission;
                            float Alpha;
                            float AlphaClipThreshold;
                        };

                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                        {
                            SurfaceDescription surface = (SurfaceDescription)0;
                            float _Property_19945B30_Out_0 = _HeightS;
                            float4 _UV_7FEAA842_Out_0 = IN.uv0;
                            float4 _SampleTexture2D_5A42DBC9_RGBA_0 = SAMPLE_TEXTURE2D(_Height, sampler_Height, (_UV_7FEAA842_Out_0.xy));
                            float _SampleTexture2D_5A42DBC9_R_4 = _SampleTexture2D_5A42DBC9_RGBA_0.r;
                            float _SampleTexture2D_5A42DBC9_G_5 = _SampleTexture2D_5A42DBC9_RGBA_0.g;
                            float _SampleTexture2D_5A42DBC9_B_6 = _SampleTexture2D_5A42DBC9_RGBA_0.b;
                            float _SampleTexture2D_5A42DBC9_A_7 = _SampleTexture2D_5A42DBC9_RGBA_0.a;
                            Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e _ParallaxOffset_8073D4F7;
                            _ParallaxOffset_8073D4F7.TangentSpaceViewDirection = IN.TangentSpaceViewDirection;
                            float4 _ParallaxOffset_8073D4F7_Output_1;
                            SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(_Property_19945B30_Out_0, (_SampleTexture2D_5A42DBC9_RGBA_0).x, (_UV_7FEAA842_Out_0.xy), _ParallaxOffset_8073D4F7, _ParallaxOffset_8073D4F7_Output_1);
                            float4 _SampleTexture2D_5062E993_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, (_ParallaxOffset_8073D4F7_Output_1.xy));
                            float _SampleTexture2D_5062E993_R_4 = _SampleTexture2D_5062E993_RGBA_0.r;
                            float _SampleTexture2D_5062E993_G_5 = _SampleTexture2D_5062E993_RGBA_0.g;
                            float _SampleTexture2D_5062E993_B_6 = _SampleTexture2D_5062E993_RGBA_0.b;
                            float _SampleTexture2D_5062E993_A_7 = _SampleTexture2D_5062E993_RGBA_0.a;
                            float4 _SampleTexture2D_20A0DB7E_RGBA_0 = SAMPLE_TEXTURE2D(_Emission, sampler_Emission, (_ParallaxOffset_8073D4F7_Output_1.xy));
                            float _SampleTexture2D_20A0DB7E_R_4 = _SampleTexture2D_20A0DB7E_RGBA_0.r;
                            float _SampleTexture2D_20A0DB7E_G_5 = _SampleTexture2D_20A0DB7E_RGBA_0.g;
                            float _SampleTexture2D_20A0DB7E_B_6 = _SampleTexture2D_20A0DB7E_RGBA_0.b;
                            float _SampleTexture2D_20A0DB7E_A_7 = _SampleTexture2D_20A0DB7E_RGBA_0.a;
                            float _Property_5D4350C9_Out_0 = _EmissionS;
                            float4 _Multiply_BA21BA5A_Out_2;
                            Unity_Multiply_float(_SampleTexture2D_20A0DB7E_RGBA_0, (_Property_5D4350C9_Out_0.xxxx), _Multiply_BA21BA5A_Out_2);
                            float _Property_39DC0DB7_Out_0 = _AlphaClipThreshold;
                            surface.Albedo = (_SampleTexture2D_5062E993_RGBA_0.xyz);
                            surface.Emission = (_Multiply_BA21BA5A_Out_2.xyz);
                            surface.Alpha = _SampleTexture2D_5062E993_A_7;
                            surface.AlphaClipThreshold = _Property_39DC0DB7_Out_0;
                            return surface;
                        }

                        // --------------------------------------------------
                        // Structs and Packing

                        // Generated Type: Attributes
                        struct Attributes
                        {
                            float3 positionOS : POSITION;
                            float3 normalOS : NORMAL;
                            float4 tangentOS : TANGENT;
                            float4 uv0 : TEXCOORD0;
                            float4 uv1 : TEXCOORD1;
                            float4 uv2 : TEXCOORD2;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : INSTANCEID_SEMANTIC;
                            #endif
                        };

                        // Generated Type: Varyings
                        struct Varyings
                        {
                            float4 positionCS : SV_POSITION;
                            float3 normalWS;
                            float4 tangentWS;
                            float4 texCoord0;
                            float3 viewDirectionWS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        // Generated Type: PackedVaryings
                        struct PackedVaryings
                        {
                            float4 positionCS : SV_POSITION;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            float3 interp00 : TEXCOORD0;
                            float4 interp01 : TEXCOORD1;
                            float4 interp02 : TEXCOORD2;
                            float3 interp03 : TEXCOORD3;
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        // Packed Type: Varyings
                        PackedVaryings PackVaryings(Varyings input)
                        {
                            PackedVaryings output = (PackedVaryings)0;
                            output.positionCS = input.positionCS;
                            output.interp00.xyz = input.normalWS;
                            output.interp01.xyzw = input.tangentWS;
                            output.interp02.xyzw = input.texCoord0;
                            output.interp03.xyz = input.viewDirectionWS;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        // Unpacked Type: Varyings
                        Varyings UnpackVaryings(PackedVaryings input)
                        {
                            Varyings output = (Varyings)0;
                            output.positionCS = input.positionCS;
                            output.normalWS = input.interp00.xyz;
                            output.tangentWS = input.interp01.xyzw;
                            output.texCoord0 = input.interp02.xyzw;
                            output.viewDirectionWS = input.interp03.xyz;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        // --------------------------------------------------
                        // Build Graph Inputs

                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                        {
                            SurfaceDescriptionInputs output;
                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                            // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                            float3 unnormalizedNormalWS = input.normalWS;
                            const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                            // use bitangent on the fly like in hdrp
                            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                            float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                            output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph

                            // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                            // This is explained in section 2.2 in "surface gradient based bump mapping framework"
                            output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                            output.WorldSpaceBiTangent = renormFactor * bitang;

                            output.WorldSpaceViewDirection = input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                            float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                            output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                            output.uv0 = input.texCoord0;
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                        #else
                        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                        #endif
                        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                            return output;
                        }


                        // --------------------------------------------------
                        // Main

                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

                        ENDHLSL
                    }

                    Pass
                    {
                            // Name: <None>
                            Tags
                            {
                                "LightMode" = "Universal2D"
                            }

                            // Render State
                            Blend One Zero, One Zero
                            Cull Back
                            ZTest LEqual
                            ZWrite On
                            // ColorMask: <None>


                            HLSLPROGRAM
                            #pragma vertex vert
                            #pragma fragment frag

                            // Debug
                            // <None>

                            // --------------------------------------------------
                            // Pass

                            // Pragmas
                            #pragma prefer_hlslcc gles
                            #pragma exclude_renderers d3d11_9x
                            #pragma target 2.0
                            #pragma multi_compile_instancing

                            // Keywords
                            // PassKeywords: <None>
                            // GraphKeywords: <None>

                            // Defines
                            #define _AlphaClip 1
                            #define _NORMALMAP 1
                            #define _NORMAL_DROPOFF_TS 1
                            #define ATTRIBUTES_NEED_NORMAL
                            #define ATTRIBUTES_NEED_TANGENT
                            #define ATTRIBUTES_NEED_TEXCOORD0
                            #define VARYINGS_NEED_NORMAL_WS
                            #define VARYINGS_NEED_TANGENT_WS
                            #define VARYINGS_NEED_TEXCOORD0
                            #define VARYINGS_NEED_VIEWDIRECTION_WS
                            #define SHADERPASS_2D

                            // Includes
                            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                            // --------------------------------------------------
                            // Graph

                            // Graph Properties
                            CBUFFER_START(UnityPerMaterial)
                            float _NormalS;
                            float2 _AOR;
                            float2 _RoughnessR;
                            float2 _MetallicR;
                            float _AlphaClipThreshold;
                            float _EmissionS;
                            float _HeightS;
                            CBUFFER_END
                            TEXTURE2D(_MainTex); SAMPLER(sampler_MainTex); float4 _MainTex_TexelSize;
                            TEXTURE2D(_NormalMap); SAMPLER(sampler_NormalMap); float4 _NormalMap_TexelSize;
                            TEXTURE2D(_AO); SAMPLER(sampler_AO); float4 _AO_TexelSize;
                            TEXTURE2D(_Roughness); SAMPLER(sampler_Roughness); float4 _Roughness_TexelSize;
                            TEXTURE2D(_Metallic); SAMPLER(sampler_Metallic); float4 _Metallic_TexelSize;
                            TEXTURE2D(_Height); SAMPLER(sampler_Height); float4 _Height_TexelSize;
                            TEXTURE2D(_Emission); SAMPLER(sampler_Emission); float4 _Emission_TexelSize;
                            SAMPLER(_SampleTexture2D_5A42DBC9_Sampler_3_Linear_Repeat);
                            SAMPLER(_SampleTexture2D_5062E993_Sampler_3_Linear_Repeat);

                            // Graph Functions

                            void Unity_Multiply_float(float A, float B, out float Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Add_float(float A, float B, out float Out)
                            {
                                Out = A + B;
                            }

                            void Unity_Divide_float(float A, float B, out float Out)
                            {
                                Out = A / B;
                            }

                            void Unity_Subtract_float(float A, float B, out float Out)
                            {
                                Out = A - B;
                            }

                            void Unity_Normalize_float3(float3 In, out float3 Out)
                            {
                                Out = normalize(In);
                            }

                            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
                            {
                                Out = A + B;
                            }

                            void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                            {
                                Out = A / B;
                            }

                            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
                            {
                                Out = A * B;
                            }

                            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                            {
                                Out = A + B;
                            }

                            struct Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e
                            {
                                float3 TangentSpaceViewDirection;
                            };

                            void SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(float Vector1_C55D14B, float Vector1_82B59319, float2 Vector2_46023C87, Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e IN, out float4 Output_1)
                            {
                                float2 _Property_FF5A7212_Out_0 = Vector2_46023C87;
                                float _Property_2EB7FC75_Out_0 = Vector1_C55D14B;
                                float _Multiply_A257210A_Out_2;
                                Unity_Multiply_float(_Property_2EB7FC75_Out_0, 0.083, _Multiply_A257210A_Out_2);
                                float _Add_B83225FD_Out_2;
                                Unity_Add_float(_Multiply_A257210A_Out_2, 0.5, _Add_B83225FD_Out_2);
                                float _Property_ED1D42AD_Out_0 = Vector1_82B59319;
                                float _Multiply_9DD2E35C_Out_2;
                                Unity_Multiply_float(_Add_B83225FD_Out_2, _Property_ED1D42AD_Out_0, _Multiply_9DD2E35C_Out_2);
                                float _Divide_7273B47D_Out_2;
                                Unity_Divide_float(_Property_ED1D42AD_Out_0, 2, _Divide_7273B47D_Out_2);
                                float _Subtract_30507953_Out_2;
                                Unity_Subtract_float(_Multiply_9DD2E35C_Out_2, _Divide_7273B47D_Out_2, _Subtract_30507953_Out_2);
                                float3 _Normalize_55E59F12_Out_1;
                                Unity_Normalize_float3(IN.TangentSpaceViewDirection, _Normalize_55E59F12_Out_1);
                                float3 _Add_F1ED545D_Out_2;
                                Unity_Add_float3(_Normalize_55E59F12_Out_1, float3(0, 0, 0.43), _Add_F1ED545D_Out_2);
                                float _Split_737A2D40_R_1 = _Add_F1ED545D_Out_2[0];
                                float _Split_737A2D40_G_2 = _Add_F1ED545D_Out_2[1];
                                float _Split_737A2D40_B_3 = _Add_F1ED545D_Out_2[2];
                                float _Split_737A2D40_A_4 = 0;
                                float2 _Vector2_383706FF_Out_0 = float2(_Split_737A2D40_R_1, _Split_737A2D40_G_2);
                                float2 _Divide_EB7CA811_Out_2;
                                Unity_Divide_float2(_Vector2_383706FF_Out_0, (_Split_737A2D40_B_3.xx), _Divide_EB7CA811_Out_2);
                                float2 _Multiply_CD8E17E4_Out_2;
                                Unity_Multiply_float((_Subtract_30507953_Out_2.xx), _Divide_EB7CA811_Out_2, _Multiply_CD8E17E4_Out_2);
                                float2 _Add_28BC651D_Out_2;
                                Unity_Add_float2(_Property_FF5A7212_Out_0, _Multiply_CD8E17E4_Out_2, _Add_28BC651D_Out_2);
                                Output_1 = (float4(_Add_28BC651D_Out_2, 0.0, 1.0));
                            }

                            // Graph Vertex
                            // GraphVertex: <None>

                            // Graph Pixel
                            struct SurfaceDescriptionInputs
                            {
                                float3 WorldSpaceNormal;
                                float3 WorldSpaceTangent;
                                float3 WorldSpaceBiTangent;
                                float3 WorldSpaceViewDirection;
                                float3 TangentSpaceViewDirection;
                                float4 uv0;
                            };

                            struct SurfaceDescription
                            {
                                float3 Albedo;
                                float Alpha;
                                float AlphaClipThreshold;
                            };

                            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                            {
                                SurfaceDescription surface = (SurfaceDescription)0;
                                float _Property_19945B30_Out_0 = _HeightS;
                                float4 _UV_7FEAA842_Out_0 = IN.uv0;
                                float4 _SampleTexture2D_5A42DBC9_RGBA_0 = SAMPLE_TEXTURE2D(_Height, sampler_Height, (_UV_7FEAA842_Out_0.xy));
                                float _SampleTexture2D_5A42DBC9_R_4 = _SampleTexture2D_5A42DBC9_RGBA_0.r;
                                float _SampleTexture2D_5A42DBC9_G_5 = _SampleTexture2D_5A42DBC9_RGBA_0.g;
                                float _SampleTexture2D_5A42DBC9_B_6 = _SampleTexture2D_5A42DBC9_RGBA_0.b;
                                float _SampleTexture2D_5A42DBC9_A_7 = _SampleTexture2D_5A42DBC9_RGBA_0.a;
                                Bindings_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e _ParallaxOffset_8073D4F7;
                                _ParallaxOffset_8073D4F7.TangentSpaceViewDirection = IN.TangentSpaceViewDirection;
                                float4 _ParallaxOffset_8073D4F7_Output_1;
                                SG_ParallaxOffset_8f9a6c3828772884fbe4b48ea96d671e(_Property_19945B30_Out_0, (_SampleTexture2D_5A42DBC9_RGBA_0).x, (_UV_7FEAA842_Out_0.xy), _ParallaxOffset_8073D4F7, _ParallaxOffset_8073D4F7_Output_1);
                                float4 _SampleTexture2D_5062E993_RGBA_0 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, (_ParallaxOffset_8073D4F7_Output_1.xy));
                                float _SampleTexture2D_5062E993_R_4 = _SampleTexture2D_5062E993_RGBA_0.r;
                                float _SampleTexture2D_5062E993_G_5 = _SampleTexture2D_5062E993_RGBA_0.g;
                                float _SampleTexture2D_5062E993_B_6 = _SampleTexture2D_5062E993_RGBA_0.b;
                                float _SampleTexture2D_5062E993_A_7 = _SampleTexture2D_5062E993_RGBA_0.a;
                                float _Property_39DC0DB7_Out_0 = _AlphaClipThreshold;
                                surface.Albedo = (_SampleTexture2D_5062E993_RGBA_0.xyz);
                                surface.Alpha = _SampleTexture2D_5062E993_A_7;
                                surface.AlphaClipThreshold = _Property_39DC0DB7_Out_0;
                                return surface;
                            }

                            // --------------------------------------------------
                            // Structs and Packing

                            // Generated Type: Attributes
                            struct Attributes
                            {
                                float3 positionOS : POSITION;
                                float3 normalOS : NORMAL;
                                float4 tangentOS : TANGENT;
                                float4 uv0 : TEXCOORD0;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                uint instanceID : INSTANCEID_SEMANTIC;
                                #endif
                            };

                            // Generated Type: Varyings
                            struct Varyings
                            {
                                float4 positionCS : SV_POSITION;
                                float3 normalWS;
                                float4 tangentWS;
                                float4 texCoord0;
                                float3 viewDirectionWS;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                uint instanceID : CUSTOM_INSTANCE_ID;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                #endif
                            };

                            // Generated Type: PackedVaryings
                            struct PackedVaryings
                            {
                                float4 positionCS : SV_POSITION;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                uint instanceID : CUSTOM_INSTANCE_ID;
                                #endif
                                float3 interp00 : TEXCOORD0;
                                float4 interp01 : TEXCOORD1;
                                float4 interp02 : TEXCOORD2;
                                float3 interp03 : TEXCOORD3;
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                                #endif
                            };

                            // Packed Type: Varyings
                            PackedVaryings PackVaryings(Varyings input)
                            {
                                PackedVaryings output = (PackedVaryings)0;
                                output.positionCS = input.positionCS;
                                output.interp00.xyz = input.normalWS;
                                output.interp01.xyzw = input.tangentWS;
                                output.interp02.xyzw = input.texCoord0;
                                output.interp03.xyz = input.viewDirectionWS;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }

                            // Unpacked Type: Varyings
                            Varyings UnpackVaryings(PackedVaryings input)
                            {
                                Varyings output = (Varyings)0;
                                output.positionCS = input.positionCS;
                                output.normalWS = input.interp00.xyz;
                                output.tangentWS = input.interp01.xyzw;
                                output.texCoord0 = input.interp02.xyzw;
                                output.viewDirectionWS = input.interp03.xyz;
                                #if UNITY_ANY_INSTANCING_ENABLED
                                output.instanceID = input.instanceID;
                                #endif
                                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                                #endif
                                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                                #endif
                                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                                output.cullFace = input.cullFace;
                                #endif
                                return output;
                            }

                            // --------------------------------------------------
                            // Build Graph Inputs

                            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                            {
                                SurfaceDescriptionInputs output;
                                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                                // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
                                float3 unnormalizedNormalWS = input.normalWS;
                                const float renormFactor = 1.0 / length(unnormalizedNormalWS);

                                // use bitangent on the fly like in hdrp
                                // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                                float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
                                float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);

                                output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph

                                // to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
                                // This is explained in section 2.2 in "surface gradient based bump mapping framework"
                                output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
                                output.WorldSpaceBiTangent = renormFactor * bitang;

                                output.WorldSpaceViewDirection = input.viewDirectionWS; //TODO: by default normalized in HD, but not in universal
                                float3x3 tangentSpaceTransform = float3x3(output.WorldSpaceTangent,output.WorldSpaceBiTangent,output.WorldSpaceNormal);
                                output.TangentSpaceViewDirection = mul(tangentSpaceTransform, output.WorldSpaceViewDirection);
                                output.uv0 = input.texCoord0;
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                            #else
                            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                            #endif
                            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                                return output;
                            }


                            // --------------------------------------------------
                            // Main

                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
                            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

                            ENDHLSL
                        }

        }
            CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
                                FallBack "Hidden/Shader Graph/FallbackError"
}
