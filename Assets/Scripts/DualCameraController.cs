using System;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;

public class DualCameraController : MonoBehaviour
{
    [DllImport("__Internal")]
    private static extern void _StartDualCameraCapture();

    [DllImport("__Internal")]
    private static extern void _StopDualCameraCapture();

    public RawImage frontCameraImage;
    public RawImage backCameraImage;
    private Texture2D frontTexture;
    private Texture2D backTexture;

    void Start()
    {
        _StartDualCameraCapture();
        frontTexture = new Texture2D(1920, 1080, TextureFormat.BGRA32, false);
        backTexture = new Texture2D(1920, 1080, TextureFormat.BGRA32, false);
        frontCameraImage.texture = frontTexture;
        backCameraImage.texture = backTexture;
    }

    void OnApplicationPause(bool pauseStatus)
    {
        if (pauseStatus)
        {
            // Release resources when the app is paused
            _StopDualCameraCapture();
            if (frontTexture != null)
            {
                Destroy(frontTexture);
                frontTexture = null;
            }
            if (backTexture != null)
            {
                Destroy(backTexture);
                backTexture = null;
            }
        }
        else
        {
            // Reinitialize resources when the app is resumed
            _StartDualCameraCapture();
            frontTexture = new Texture2D(1920, 1080, TextureFormat.BGRA32, false);
            backTexture = new Texture2D(1920, 1080, TextureFormat.BGRA32, false);
            frontCameraImage.texture = frontTexture;
            backCameraImage.texture = backTexture;
        }
    }

    void OnDestroy()
    {
        _StopDualCameraCapture();
    }

    public void UpdateFrontCameraTexture(string base64FrameData)
    {
        byte[] frameData = Convert.FromBase64String(base64FrameData);
        // frontTexture.LoadRawTextureData(frameData);
        // frontTexture.Apply();
    }

    public void UpdateBackCameraTexture(string base64FrameData)
    {
        byte[] frameData = Convert.FromBase64String(base64FrameData);
        // backTexture.LoadRawTextureData(frameData);
        // backTexture.Apply();
    }
}
