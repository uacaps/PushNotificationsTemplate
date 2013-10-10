Push Notifications Template
============================

**Laziness is Good**

Let's face it, setting up push notifications for the first time is a bit daunting... There's the <code>SenderId</code> the <code>RegistrationId</code>, the <code>AppId</code>. What does it all mean??? When do I use what? Why isn't there a working sample project that I can drop in my app information and it just works? 

Well, we at CAPS wondered the same thing, so we went ahead and set one up for everyone!

## Table of Contents
* What You Get
   * [The iOS App](#the-ios-app)
   * [The Android App](#the-sample-app)
   * [The Server App](#the-server-app)
* [Making it Work](#making-it-work)
* [Scaling](#scaling)

## The iOS App

## The Android App

First let us take a look at the sample Android app provided in the **Android App Template** folder of the root directory. Inside you will find an app with 3 files.

* **MainActivity.java**
    * The startup activity for the app. Nothing special here, but all of our registration setup with Google will go in this class.
    
* **GcmIntentService.java**
    * This class will be what handles the push notification when it arrives. The <code>onHandleIntent()</code> method handles the raw intent from the push notification services of the operating system, while <code>sendNotification(String msg)</code> will display the text of the notification in the Notifcation Drawer.
    
* **GcmBroadcastReceiver.java**
    * This class allows you to receive intents, in our case GCM Intents. It's basically like a switchboard that routes the notification to the <code>GcmIntentService.java</code> class.


This app needs no edits to get push notifications working. You will need to grab the RegistrationId in the LogCat, but we will talk about that soon.

## The Server App

We have provided a sample push server using [PushSharp](https://github.com/Redth/PushSharp), a great C# library for sending Android and iOS push notifications (and blackberry and windows phone). It is an MVC 4 project that uses Web API to send a test push notification, perfect for getting things up and running. Open up the project solution in the **Push Server Template -> PushTest** and head to the Controllers folder to find <code>PushController.cs</code> Here you will find the following Web API method:

```csharp
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
            push.QueueNotification(new GcmNotification().ForDeviceRegistrationId("REGISTARATION_ID")
                      .WithJson("{\"alert\":\"Hello World!\",\"badge\":7,\"sound\":\"sound.caf\"}"));
        }
```

<code>AIzaSyD3J2zRHVMR1BPPnbCVaB1D_qWBYGC4-uU</code> in the GcmPushChannelSettings constructor is the test app's api key retreived from the Google API Console. The input parameter to the ForDeviceRegistrationId method is where you will put the device registration Id for your particular device. Where might one find this Id? I'm glad you asked.

## Making it Work

**Retrieve the Device Registration Id**

Every Android device will have a registration id for push notifications for an app. It is a long string of characters that your device will have assigned to it when the app sets up push notifications for itself. Each time you want to send a push notification to a specific device, you will need to retreive this identifier from google.

Good news: Our sample Android app already does this! Take a look in the <code>doInBackground() method in PushAsyncTask</code>. Here you are fetching the device registration id from Google, and having it print to the LogCat. In a true system, once you receive the id, you would upload it to your server for safe keeping, but for the sake of example, run the sample app on your droid device and then grab the device registration id from the LogCat. It should look something like this

```csharp
APA71bGDFHk6HCWxskob04URTmd-MDV3FdKJarba0CcMgkxRtpQdSTqg9zoWDioimi0L-fNiTcgepiRsdGyMbv2gW1FM4FZFV9xlikaSiKrY8s-b3BH2T-bii6kEojdXoM9FR0I6vj2E8WDWLbApaHHYgoBU6wuwWA
```

**Add device to Push Server**

Ok, now flip back over to the <code>PushController.cs</code> file in your push server template project. In the testPush method, you should see a string called "REGISTARATION_ID". Replace it with a string contating your device identifier. We are now ready to test!

**Testing 1,2,3**

Find the play button up top and run the visual studio project. You should be met with a simple page representing the MVC template running on your localhost. Now, navigate to the url 

http://localhost:PORT_NUMBER/api/push/testPush 

This should trigger the Web API method <code>testPush()</code> to be hit and send a push notification to your phone!


## Scaling

So this is great for testing and all, but what about building a system? Here are a few tips and tricks that might help.

* If you are using PushSharp, you would simply queue additional notifictions for additional devices.
* Store device tokens in your database and then trigger them on events in your system for registered users.
* Consider moving the push broker to be a global variable so it is not instantiated every time you want to send a message. If your push load is extra heavy, definitely consider moving the notification triggering to a background thread or other server.
