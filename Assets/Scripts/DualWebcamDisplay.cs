using UnityEngine;
using UnityEngine.UI;

public class DualWebcamDisplay : MonoBehaviour
{
    public RawImage rawImage1;
    public RawImage rawImage2;
    public RawImage rawImage3;
    public RawImage rawImage4;
    public RawImage rawImage5;

    private WebCamTexture webcamTexture1;
    private WebCamTexture webcamTexture2;
    private WebCamTexture webcamTexture3;
    private WebCamTexture webcamTexture4;
    private WebCamTexture webcamTexture5;

    private void Start()
    {
        // Get available devices
        WebCamDevice[] devices = WebCamTexture.devices;
        Debug.Log("There are " + devices.Length + " camera devices.");

        // Check if there are at least two devices
        if (devices.Length == 5)
        {
            // Initialize and start the first webcam texture
            webcamTexture1 = new WebCamTexture(devices[0].name);
            rawImage1.texture = webcamTexture1;
            webcamTexture1.Play();

            // Initialize and start the second webcam texture
            webcamTexture2 = new WebCamTexture(devices[1].name);
            rawImage2.texture = webcamTexture2;
            webcamTexture2.Play();

            // Initialize and start the third webcam texture
            webcamTexture3 = new WebCamTexture(devices[2].name);
            rawImage2.texture = webcamTexture3;
            webcamTexture3.Play();

            // Initialize and start the fourth webcam texture
            webcamTexture4 = new WebCamTexture(devices[3].name);
            rawImage2.texture = webcamTexture4;
            webcamTexture4.Play();

            // Initialize and start the fifth webcam texture
            webcamTexture5 = new WebCamTexture(devices[4].name);
            rawImage2.texture = webcamTexture5;
            webcamTexture5.Play();
        }
        else if (devices.Length >= 2)
        {
            // Initialize and start the first webcam texture
            webcamTexture1 = new WebCamTexture(devices[0].name);
            rawImage1.texture = webcamTexture1;
            webcamTexture1.Play();

            // Initialize and start the second webcam texture
            webcamTexture2 = new WebCamTexture(devices[1].name);
            rawImage2.texture = webcamTexture2;
            webcamTexture2.Play();
        }
        else
        {
            Debug.LogError("Not enough webcam devices found.");
        }
    }

    private void OnDestroy()
    {
        // Stop the webcam textures when the object is destroyed
        if (webcamTexture1 != null && webcamTexture1.isPlaying)
        {
            webcamTexture1.Stop();
        }

        if (webcamTexture2 != null && webcamTexture2.isPlaying)
        {
            webcamTexture2.Stop();
        }
    }
}
