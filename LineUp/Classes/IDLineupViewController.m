//
//  ViewController.m
//  LineUp
//
//  Created by Gabriel Webb on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IDLineupViewController.h"
#import "IDRefreshHeaderView.h"
#import "AFNetworking.h"

#import <QuartzCore/QuartzCore.h>

@interface IDLineupViewController ()
{
@private
    IDRefreshHeaderView *_headerView;
    BOOL _refreshing;
}

@end

@implementation IDLineupViewController

#pragma mark - Initialization

- (void) viewDidLoad
{
    // Set every label's font to Journal
    for(UILabel *label in _journalLabels)
    {
        label.font = [UIFont fontWithName:@"JOURNAL" size:label.font.pointSize];
        label.textColor = [UIColor colorWithRed:8.0/255.0 green:100.0/255.0 blue:175.0/255.0 alpha:1.0];
        
        // Rotate slightly
        int random = arc4random() % 3;

        label.layer.anchorPoint = CGPointMake(0, 1);
        label.transform = CGAffineTransformMakeRotation(-random * 0.0174532925);
        
        // Re-adjust the frame after rotation transformation (should probably take into account the angle, too)
        label.frame = CGRectMake(label.frame.origin.x - (label.frame.size.width/2), label.frame.origin.y + (label.frame.size.height/2), label.frame.size.width, label.frame.size.height);
    }
	
	_scrollView.contentSize = CGSizeMake(320, 460);
    _scrollView.delegate = self;
	
	// Create the pull to refresh view
	_headerView = [[IDRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -101, 320, 100)];
	[_scrollView addSubview:_headerView];
}

#pragma mark - Lineup Data

- (void) reloadData
{
    _refreshing = YES;
    _headerView.state = IDRefreshHeaderStateRefreshing;
	[_activityIndicator startAnimating];
    
    // Load data and setup state in completion block
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.inkdryercreative.com/lineup/?feed=json"]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        // Parse the results
        NSLog(@"RESULTS ARE : %@", JSON);
        NSArray *results = (NSArray *)JSON;
        if([results count] > 0)
        {
            // Only the most recent entry will be used
            NSDictionary *mostRecentEntry = [results objectAtIndex:0];
        }
        
        // Update the view state
        _refreshing = NO;
        _headerView.state = IDRefreshHeaderStateNotReady;
        [_activityIndicator stopAnimating];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op];
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_refreshing) return;
    
	if(scrollView.contentOffset.y < -_headerView.frame.size.height)
    {
        _headerView.state = IDRefreshHeaderStateReady;
    }
    else
    {
        _headerView.state = IDRefreshHeaderStateNotReady;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(_headerView.state == IDRefreshHeaderStateReady)
    {
        _scrollView.delegate = nil;
        
        [self reloadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _scrollView.delegate = self;
}

@end
