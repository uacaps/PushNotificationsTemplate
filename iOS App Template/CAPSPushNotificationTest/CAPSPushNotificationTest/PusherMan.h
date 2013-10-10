//
//  PusherMan.h
//  Schoolbus
//
//  Created by Ben Gordon on 9/20/13.
//  Copyright (c) 2013 Center for Advanced Public Safety. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PusherMan : NSObject

// Properties
@property (nonatomic, retain) NSString *DeviceToken;

// Methods
+ (void)registerAppForPushNotifications;
+ (UIRemoteNotificationType)enabledPushNotificationTypes;
+ (PusherMan*)defaultCenter;
+ (NSString *)deviceToken;
+ (void)setDeviceToken:(NSData *)deviceToken;


@end
