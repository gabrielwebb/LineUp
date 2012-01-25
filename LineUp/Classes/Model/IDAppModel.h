//
//  IDAppModel.h
//  LineUp
//
//  Created by Andy Roth on 1/19/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDTeamInfo.h"

@interface IDAppModel : NSObject

@property (nonatomic, strong) IDTeamInfo *currentTeamInfo;

- (void) save;

@end
