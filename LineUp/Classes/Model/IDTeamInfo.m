//
//  IDTeamInfo.m
//  LineUp
//
//  Created by Andy Roth on 1/25/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import "IDTeamInfo.h"

@implementation IDTeamInfo

@synthesize postID = _postID;
@synthesize teamName = _teamName;
@synthesize gameDateString = _gameDateString;
@synthesize opponentName = _opponentName;
@synthesize isHome = _isHome;
@synthesize lineup = _lineup;

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self)
    {
        self.postID = [aDecoder decodeIntForKey:@"postID"];
        self.teamName = [aDecoder decodeObjectForKey:@"teamName"];
        self.gameDateString = [aDecoder decodeObjectForKey:@"gameDateString"];
        self.opponentName = [aDecoder decodeObjectForKey:@"opponentName"];
        self.isHome = [aDecoder decodeBoolForKey:@"isHome"];
        self.lineup = [aDecoder decodeObjectForKey:@"lineup"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.postID forKey:@"postID"];
    [aCoder encodeObject:self.teamName forKey:@"teamName"];
    [aCoder encodeObject:self.gameDateString forKey:@"gameDateString"];
    [aCoder encodeObject:self.opponentName forKey:@"opponentName"];
    [aCoder encodeBool:self.isHome forKey:@"isHome"];
    [aCoder encodeObject:self.lineup forKey:@"lineup"];
}

@end
