//  Copyright (c) 2013 The Board of Trustees of The University of Alabama
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. Neither the name of the University nor the names of the contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
//  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
//  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
//  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//  OF THE POSSIBILITY OF SUCH DAMAGE.

#import "CAPSViewController.h"
#import "PusherMan.h"

@interface CAPSViewController ()

@end

@implementation CAPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@", [PusherMan deviceToken]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Push Notifications
- (void)registerDeviceForPushNotificationsWithServer {
    if ([PusherMan deviceToken]) {
        // Here you'd make a webservice call to the Push Server that includes
        // this push notification device token. Here you'd also want to
        // discrimnate what kind of push notifications you want to receive.
        // For instance: let's say you have an app that sends you notifications
        // on the morning temperature in a town you select. Here you might send
        // your device token and the Zip Code. That way the server goes through
        // a list of Zip Codes in the database, grabs the temperature, then
        // transmits that to a list of deviceTokens that have a link to that Zip.
        //
        // You can always receive your deviceToken by calling:
        // [PusherMan deviceToken]
        //
        // If that's nil, then the device failed to register for notifications
        // or Apple's server is down and couldn't respond to the request.
        // The first scenario is a lot more likely, however.
    }
}

@end
