//
//  UADeviceManager.h
//  PushTest
//
//  Created by Andy Roth on 6/16/11.
//  Copyright 2011 AKQA. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UADeviceManager;

@protocol UADeviceManagerDelegate <NSObject>

@optional

- (void) manager:(UADeviceManager *)manager didRegisterWithResponse:(NSString *)response;
- (void) manager:(UADeviceManager *)manager didFailWithError:(NSError *)error;

@end

/*
 
 Manager class used to register devices with Urban Airship. First, register for remote notifications:
 
 [[UIApplication sharedApplication]
		registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
											UIRemoteNotificationTypeSound |
											UIRemoteNotificationTypeAlert)];
 
 Then implement this in your application delegate:
 
 - (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
 
 In that method, you can register the device token:
 
 UADeviceManager *manager = [UADeviceManager sharedManagerWithApplicationKey:myKey applicationSecret:mySecret];
 manager.delegate = self;
 [manager registerDeviceToken:deviceToken];
 
 */
@interface UADeviceManager : NSObject
{
	@private
	NSMutableData *_responseData;
}

@property (nonatomic, assign) id <UADeviceManagerDelegate> delegate;
@property (nonatomic, copy) NSString *applicationKey;
@property (nonatomic, copy) NSString *applicationSecret;

+ (UADeviceManager *) sharedManager;
+ (UADeviceManager *) sharedManagerWithApplicationKey:(NSString *)key applicationSecret:(NSString *)secret;

- (void) registerDeviceToken:(NSData *)token;
- (void) registerDeviceTokenString:(NSString *)token;

@end
