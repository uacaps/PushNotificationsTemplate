using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PushSharp;
using PushSharp.Android;
using PushSharp.Apple;
using System.Resources;
using System.Reflection;

namespace PushTest.Controllers
    
{
    public class PushController : ApiController
    {
        [HttpGet]
        public void testPush()
        {
            var push = new PushBroker();
            
            //**** iOS Notification ******
            //Establish the file path to your certificates. Here we make one for dev and another for production
            byte[] appleCertificate = null;
            //appleCertificate = Properties.Resources.DEV_CERT_NAME;
            //appleCertificate = Properties.Resources.PROD_CERT_NAME;

            //If the file exists, go ahead and use it to send an apple push notification
            if (appleCertificate != null)
            {

                //Give the apple certificate and its password to the push broker for processing
                push.RegisterAppleService(new ApplePushChannelSettings(appleCertificate, "password"));

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