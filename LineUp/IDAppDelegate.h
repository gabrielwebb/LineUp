//
//  AppDelegate.h
//  LineUp
//
//  Created by Gabriel Webb on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UADeviceManager.h"

@interface IDAppDelegate : UIResponder <UIApplicationDelegate, UADeviceManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
