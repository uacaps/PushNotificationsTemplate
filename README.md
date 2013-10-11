Push Notifications Template
============================

**Laziness is Good**

Let's face it, setting up push notifications for the first time is a bit daunting... There's the <code>SenderId</code> the <code>RegistrationId</code>, the <code>AppId</code>. What does it all mean??? When do I use what? Why isn't there a working sample project that I can drop in my app information and it just works? 

Well, we at CAPS wondered the same thing, so we went ahead and set one up for everyone!

## Table of Contents
* What You Need
   * [Xcode](https://developer.apple.com/xcode/), [Android SDK](http://developer.android.com/sdk/index.html), [Microsoft Visual Studio](http://www.microsoft.com/visualstudio/eng/visual-studio-2013)
* What You Get
   * [The iOS App](#the-ios-app)
   * [The Android App](#the-sample-app)
   * [The Server App](#the-server-app)
* [Making it Work](#making-it-work)
* [Scaling](#scaling)

## The iOS App

To start receiving push notifications on your iOS devices, there is a little bit of set up work that must be done before writing any code in Xcode. Here's what you need to do:

**Create An App ID**
* Go to the [iOS Developer Center](https://developer.apple.com)
* Click "Certificates, Identifiers and Profiles"
* Create an AppId
* Make sure you enable Push Notifications at the very bottom of the page

**Provisioning Profile**
* Create a new Development Provisioning Profile for the AppId you created

**Certificates**
* Create a new certificate of type "Apple Push Notification service SSL (Sandbox)"
* Select the same AppID you've been using so far.
* Open "Keychain Access" on your Mac
* Click "Keychain Access->Certificate Assistant->Request A Certificate from a Certificate Authority" in the menu
* Enter in your credentials, and make sure it's "Saved to Disk", not "Email to Authority"
* Save it to Desktop
* Go back to your web browser, and continue where you left off in the dev portal
* Upload the certificate request and it will give you a certificate to download
* Add the downloaded certificate to Keychain Access
* Select the certificate, and then click "File->Export Items" in the menu
* Export it as a .p12 file - this is what you'll add to your Push Server. We will be using them in [The Server App](#the-server-app) section 

**Coding The App**

After adding the .p12 file to your Push Server, and setting that up, you're ready to begin adding Push Notification functionality to your iOS app. There's really not much you need to do here - and we've created a special class for you that handles a lot of the functionality, <code>PusherMan.{h,m}</code>. Add those 2 files to your project, and then:

<code>#import "PusherMan.h"</code> into
* AppDelegate.h
* Any class/controller where you will be registering notifications with your server

PusherMan is a singleton class that just holds onto your device token during the duration of the app, and handles a couple auxilliary methods for registering for notifications with Apple, and retrieving the types of notification that a current device is registered for. Once you've imported PusherMan to your classes, there are only three more methods to add to your <code>AppDelegate.m</code> file, and you are ready to roll. Add these three methods below.

```objc
#pragma mark - Push Notification Methods
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    // Successfully registered the current device with Apple's Push Notification Service
	[PusherMan setDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    // The App was unsuccessful in registering this device for APNS
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // This method is called whenever the App receives a Push Notification from Apple,
    // and the app is open - or they tap on the actual push notification on screen that
    // then launches this app and calls this method.
    NSLog(@"Notification: %@", userInfo);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Noticiation" message:userInfo[@"alert"] delegate:nil cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
    [alertView show];
}
```

All of these methods are delegate callbacks for either successfully registering for Push Notifications, failing to register, or actually receiving the push notification on your device. These three have to be implemented to receive push notification functionality. Also, at the very top of your AppDelegate should be the method, <code>- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions</code>. Add this line to that method:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PusherMan registerAppForPushNotifications];
    return YES;
}
```

All that line does is begin the process of registering for notifications, and then the delegate methods you implemented a second ago handle the rest.

**Coding Style for Notifications**

Once you've set up your app to receive/handle push notifications, you still need to talk to your server to let it know how/when to actually send the notifications. How your app does this is entirely up to you, and changes on a project by project basis.

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

We have provided a sample push server using [PushSharp](https://github.com/Redth/PushSharp), a great C# library for sending Android and iOS push notifications (and blackberry and windows phone). You can install it through the nuget package manager in visual studio, but for brevity, we have already set that up for you in the sample app. 

The push server app is written in MVC 4 and uses Web API to send a test push notification in an event-driven manner, perfect for getting things up and running. Open up the project solution in the **Push Server Template** folder and head to the Controllers folder to find <code>PushController.cs</code> Here you will find the following Web API method:

```csharp
[HttpGet]
public void testPush()
{
	var push = new PushBroker();
            
            //**** iOS Notification ******
            //Establish the connections to your certificates. Here we make one for dev and another for production
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
```

**iOS Notifications**

iOS notifications are authenticated through .p12 certificates, particularly the certificates we set up in [The iOS App](#the-ios-app) section. A certificate will be bundled with your notification when you send it to Apple for processing, allowing them to know you are approved to send notifications for a specific app. Typically, you have two certificatets, one for development and one for production, both of which we have made a place for in the sample app. 

Once you have generated these two certificates, we are going to add them as a resource. Here are the steps to make that happen: 

* Go to the Solution explorer and right click on your project file (not solution file). Select "Properties".
* From the left-hand menu of the properties pane, select Resources.
* Click the "Add Resource" dropdown and select "Add Existing File". Navigate to your certifcates and select it. Repeat for the other certificate, if you have two (for dev and production).
* Once your certificates are added to the resources, you can access them by the following line in the example code.

```csharp
appleCertificate = Properties.Resources.DEV_CERT_NAME;
```
 
 * Now that your certificates are in place, you need only provide a device token and queue your message!

**Android (Google Cloud Messaging) Notifications**

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
