//
//  IDAppModel.m
//  LineUp
//
//  Created by Andy Roth on 1/19/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import "IDAppModel.h"

@implementation IDAppModel

@synthesize currentTeamInfo = _currentTeamInfo;

#pragma mark - NSCoding

- (void) save
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *teamInfoPath = [documentsPath stringByAppendingPathComponent:@"teamInfo"];
    
    [NSKeyedArchiver archiveRootObject:self.currentTeamInfo toFile:teamInfoPath];
}

- (void) load
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *teamInfoPath = [documentsPath stringByAppendingPathComponent:@"teamInfo"];
    
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:teamInfoPath]];
    
    if(obj)
    {
        self.currentTeamInfo = obj;
    }
    else
    {
        self.currentTeamInfo = [[IDTeamInfo alloc] init];
    }
}

#pragma mark - Singleton Methods

static IDAppModel *_instance = nil;

+ (IDAppModel *) sharedManager
{
    if (_instance == nil)
    {
        _instance = [[super allocWithZone:NULL] init];
        [_instance load];
    }
    
    return _instance;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

@end
