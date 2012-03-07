//
//  IDAppDelegate.m
//  Lineup
//
//  Created by Andy Roth on 3/6/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import "IDAppDelegate.h"

#import "IDLineupViewController.h"

@implementation IDAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Request push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    UADeviceManager *manager = [UADeviceManager sharedManagerWithApplicationKey:@"kwLyELSITwW_OrIdHOB5wg" applicationSecret:@"DOt2cOo7SrGJT515jH-VNw"];
    manager.delegate = self;
    [manager registerDeviceToken:deviceToken];
}

- (void) manager:(UADeviceManager *)manager didRegisterWithResponse:(NSString *)response
{
    NSLog(@"SUCCESS : %@", response);
}

- (void) manager:(UADeviceManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"FAIL : %@", error.localizedDescription);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [((IDLineupViewController *)_window.rootViewController) reloadData];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
