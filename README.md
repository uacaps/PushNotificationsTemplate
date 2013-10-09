GCM Android App Template
============================

**Laziness is Good**

Let's face it, setting up push notifications in an Android app for the first time is a bit daunting... There's the <code>SenderId</code> the <code>RegistrationId</code>, the <code>AppId</code>. What does it all mean??? When do I use what? Why isn't there a working sample project that I can drop in my <code>SenderId</code> and it just works? 

Well, we at CAPS wondered the same thing, so we went ahead and set one up for everyone!

## Table of Contents

* [The Android App](#the-sample-app)
* [The Server App](#the-server-app)

## The Sample App

First let us take a look at the sample Android app provided in the **GCM Template** folder of the root directory. Inside you will find an app with 3 files.

* **MainActivity.java**
    * The startup activity for the app. Nothing special here, but all of our registration setup with Google will go in this class.
    
* **GcmIntentService.java**
    * This class will be what handles the push notification when it arrives. The <code>onHandleIntent()</code> method handles the raw intent from the push notification services of the operating system, while <code>sendNotification(String msg)</code> will display the text of the notification in the Notifcation Drawer.
    
* **GcmBroadcastReceiver.java**
    * This class allows you to receive intents, in our case GCM Intents. It's basically like a switchboard that routes the notification to the <code>GcmIntentService.java</code> class.

## The Server App
