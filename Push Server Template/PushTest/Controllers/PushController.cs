using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PushSharp;
using PushSharp.Android;
using PushSharp.Apple;
using System.IO;

namespace PushTest.Controllers
    
{
    public class PushController : ApiController
    {
        [HttpGet]
        public void testPush()
        {
            var push = new PushBroker();
            
            //**** iOS Notification ******
            //Read in the Bytes of the apple certificate. Here we make one for dev and another for production
            String devCertificatePath = "ApnsDevSandboxCert.p12";
            String prodCertificatePath = "ApnsProductionSandboxCert.p12";

            //If the file exists, go ahead and use it to send an apple push notification
            if (File.Exists(devCertificatePath))
            {
                var appleCert = File.ReadAllBytes("ApnsDevSandboxCert.p12");
                //var appleCert = File.ReadAllBytes("ApnsProductionSandboxCert.p12");

                //Give the apple certificate and its password to the push broker for processing
                push.RegisterAppleService(new ApplePushChannelSettings(appleCert, "password"));

                //Queue the iOS push notification
                push.QueueNotification(new AppleNotification()
                               .ForDeviceToken("DEVICE_TOKEN_HERE")
                               .WithAlert("Hello World!")
                               .WithBadge(7)
                               .WithSound("sound.caf"));
            }
            //*********************************


            //**** Android Notification ******
            //Register the GCM Service and sending an Android Notification with your browser API key found in your google API Console for your app. Here, we use ours.
            push.RegisterGcmService(new GcmPushChannelSettings("AIzaSyD3J2zRHVMR1BPPnbCVaB1D_qWBYGC4-uU"));

            //Queue the Android notification. Unfortunately, we have to build this packet manually. 
            push.QueueNotification(new GcmNotification().ForDeviceRegistrationId("DEVICE_REGISTRATION_ID")
                      .WithJson("{\"alert\":\"Hello World!\",\"badge\":7,\"sound\":\"sound.caf\"}"));
            //*********************************
        }
    }
}