//
//  IDTeamInfo.h
//  LineUp
//
//  Created by Andy Roth on 1/25/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDTeamInfo : NSObject <NSCoding>

@property (nonatomic) int postID;
@property (nonatomic, strong) NSString *teamName;
@property (nonatomic, strong) NSString *gameDateString;
@property (nonatomic, strong) NSString *opponentName;
@property (nonatomic) BOOL isHome;

@property (nonatomic, strong) NSArray *lineup;

@end
