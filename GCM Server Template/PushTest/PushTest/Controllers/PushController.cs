using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using PushSharp;
using PushSharp.Android;

namespace PushTest.Controllers
    
{
    public class PushController : ApiController
    {
        [HttpGet]
        public void testPush()
        {
            var push = new PushBroker();
            /*
            //Registering the Apple Service and sending an iOS Notification
            var appleCert = File.ReadAllBytes("ApnsSandboxCert.p12"));
            push.RegisterAppleService(new ApplePushChannelSettings(appleCert, "pwd"));
                push.QueueNotification(new AppleNotification()
                           .ForDeviceToken("DEVICE TOKEN HERE")
                           .WithAlert("Hello World!")
                           .WithBadge(7)
                           .WithSound("sound.caf"));*/

            //Registering the GCM Service and sending an Android Notification
            push.RegisterGcmService(new GcmPushChannelSettings("AIzaSyD3J2zRHVMR1BPPnbCVaB1D_qWBYGC4-uU"));
            //Fluent construction of an Android GCM Notification
            //IMPORTANT: For Android you MUST use your own RegistrationId here that gets generated within your Android app itself!
            push.QueueNotification(new GcmNotification().ForDeviceRegistrationId("APA91bGDFHk6HCWxskob04URTmQ-MDV3FdKJarbz0CcMgkxRtmQdSTqp9zoWDioimi0L-fNiTcgeppRsdGyMRv2gW1FM4FZFV9slikaSiKrY8s-b3BH2T-bii6kEojdXoM9FR0I6vj2E8WDWLbApaHHYgoBU6wuwWA")
                      .WithJson("{\"alert\":\"Hello World!\",\"badge\":7,\"sound\":\"sound.caf\"}"));
        }
    }
}