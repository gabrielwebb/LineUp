//
//  ViewController.m
//  LineUp
//
//  Created by Gabriel Webb on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IDLineupViewController.h"
#import "IDRefreshHeaderView.h"

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
    
    //TODO: Load data and setup state in completion block
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
