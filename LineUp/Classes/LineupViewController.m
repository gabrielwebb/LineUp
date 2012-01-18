//
//  ViewController.m
//  LineUp
//
//  Created by Gabriel Webb on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LineupViewController.h"

@implementation LineupViewController

#pragma mark - Initialization

- (void) viewDidLoad
{
    // Set every label's font to Journal
    for(UILabel *label in _journalLabels)
    {
        label.font = [UIFont fontWithName:@"JOURNAL" size:label.font.pointSize];
        label.textColor = [UIColor colorWithRed:8.0/255.0 green:100.0/255.0 blue:175.0/255.0 alpha:1.0];
    }
}

@end
