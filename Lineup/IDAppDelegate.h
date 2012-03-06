//
//  IDAppDelegate.h
//  Lineup
//
//  Created by Andy Roth on 3/6/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UADeviceManager.h"

@interface IDAppDelegate : UIResponder <UIApplicationDelegate, UADeviceManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
