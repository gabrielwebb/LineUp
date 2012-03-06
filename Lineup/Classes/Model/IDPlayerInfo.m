//
//  IDPlayerInfo.m
//  LineUp
//
//  Created by Andy Roth on 1/25/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import "IDPlayerInfo.h"

@implementation IDPlayerInfo

@synthesize playerIndex = _playerIndex;
@synthesize playerName = _playerName;
@synthesize playerPosition = _playerPosition;

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.playerIndex = [aDecoder decodeIntForKey:@"playerIndex"];
        self.playerName = [aDecoder decodeObjectForKey:@"playerName"];
        self.playerPosition = [aDecoder decodeIntForKey:@"playerPosition"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.playerIndex forKey:@"playerIndex"];
    [aCoder encodeObject:self.playerName forKey:@"playerName"];
    [aCoder encodeInt:self.playerPosition forKey:@"playerPosition"];
}

@end
