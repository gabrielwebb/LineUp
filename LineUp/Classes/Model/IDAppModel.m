//
//  IDAppModel.m
//  LineUp
//
//  Created by Andy Roth on 1/19/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import "IDAppModel.h"

@implementation IDAppModel

#pragma mark - NSCoding

- (void) save
{
    
}

#pragma mark - Singleton Methods

static IDAppModel *_instance = nil;

+ (IDAppModel *) sharedManager
{
    if (_instance == nil)
    {
        _instance = [[super allocWithZone:NULL] init];
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
