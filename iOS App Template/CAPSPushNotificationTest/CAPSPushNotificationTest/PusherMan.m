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

#import "PusherMan.h"

@implementation PusherMan

static PusherMan *_defaultCenter = nil;

#pragma mark - Set Up
+ (PusherMan*)defaultCenter {
	@synchronized([PusherMan class]) {
		if (!_defaultCenter) {
            _defaultCenter  = [[PusherMan alloc] init];
        }
        
		return _defaultCenter;
	}
	
	return nil;
}

+ (id)alloc {
	@synchronized([PusherMan class]) {
		NSAssert(_defaultCenter == nil, @"Attempted to allocate a second instance of a singleton.");
		_defaultCenter = [super alloc];
		return _defaultCenter;
	}
	
	return nil;
}

- (id)init {
	if (self = [super init]) {
        //
	}
	
	return self;
}

#pragma mark - Register for Push Notifications
+ (void)registerAppForPushNotifications {
    // Calls Apple's APNS servers to register the device for these three notification types
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}


#pragma mark - See enabled types
+ (UIRemoteNotificationType)enabledPushNotificationTypes {
    // Returns the types set in the above method
    return [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
}


#pragma mark - Device Token
+ (NSString *)deviceToken {
    // Returns the deviceToken if it is set, or nil if it's not
    return [PusherMan defaultCenter].DeviceToken;
}

+ (void)setDeviceToken:(NSData *)deviceToken {
    // This removes elbow brackets (< >) and the spaces inside of the returned device token.
    // Apple doesn't accept those characters when you push a notification to them.
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [PusherMan defaultCenter].DeviceToken = newToken;
}


@end
