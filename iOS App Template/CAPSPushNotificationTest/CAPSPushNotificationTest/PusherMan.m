//
//  PusherMan.m
//  Schoolbus
//
//  Created by Ben Gordon on 9/20/13.
//  Copyright (c) 2013 Center for Advanced Public Safety. All rights reserved.
//

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
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}


#pragma mark - See enabled types
+ (UIRemoteNotificationType)enabledPushNotificationTypes {
    return [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
}


#pragma mark - Device Token
+ (NSString *)deviceToken {
    return [PusherMan defaultCenter].DeviceToken;
}

+ (void)setDeviceToken:(NSData *)deviceToken {
    NSString *newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [PusherMan defaultCenter].DeviceToken = newToken;
}


@end
