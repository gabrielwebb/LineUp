//
//  IDPlayerInfo.h
//  LineUp
//
//  Created by Andy Roth on 1/25/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDPlayerInfo : NSObject <NSCoding>

@property (nonatomic) int playerIndex;                  // Index of the player on the list, sorted
@property (nonatomic, strong) NSString *playerName;
@property (nonatomic) int playerPosition;               // Position displayed next to the player's name

@end
