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
#import "IDAppModel.h"
#import "IDTeamInfo.h"
#import "IDPlayerInfo.h"
#import "UIView+IDAdditions.h"

#import <QuartzCore/QuartzCore.h>

static const int PLAYER_NAME_TAG_START = 100;
static const int PLAYER_POS_TAG_START = 200;

@interface IDLineupViewController ()
{
@private
    IDRefreshHeaderView *_headerView;
    BOOL _refreshing;
    UIView *_defaultImage;
}

- (void)updateContent;
- (void)addPadding:(CGFloat)padding toLabel:(UILabel *)label;
- (BOOL)noGameToday:(IDTeamInfo *)team;

@end

@implementation IDLineupViewController

#pragma mark - Initialization

- (void) viewDidLoad
{
    // Set every label's font to Journal
    for(UILabel *label in _journalLabels)
    {
        label.text = @"";
        label.font = [UIFont fontWithName:@"JOURNAL" size:label.font.pointSize];
        label.textColor = [UIColor colorWithRed:8.0/255.0 green:100.0/255.0 blue:175.0/255.0 alpha:1.0];
        [self addPadding:10.0 toLabel:label];
        
        // Rotate slightly
        int random = arc4random() % 3;

        label.transformationPoint = CGPointMake(0, 1);
        label.transform = CGAffineTransformMakeRotation(-random * 0.0174532925);
    }
    
    // Set the date label's font
    _dateLabel.font = [UIFont fontWithName:@"Avenir" size:13.0];
    _dateLabel.text = @"";
	
    // Set the size of the scrollview so it can scroll vertically
	_scrollView.contentSize = CGSizeMake(320, 460);
    _scrollView.delegate = self;
	
	// Create the pull to refresh view
	_headerView = [[IDRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -51, 320, 50)];
	[_scrollView addSubview:_headerView];
    
    // Set the labels based on cached data
    [self updateContent];
    
    // Add the default image so we can animate it
    _defaultImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    _defaultImage.frame = CGRectMake(0, -20, 320, 480);
    [self.view addSubview:_defaultImage];
}

- (void) viewDidAppear:(BOOL)animated
{
    // When the view first appears, curl up the default image
    if(_defaultImage)
    {
        [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            [_defaultImage removeFromSuperview];
        } completion:^(BOOL finished) {
            _defaultImage = nil;
        }];
    }
}

#pragma mark - Lineup Data

- (void) reloadData
{
    [self updateContent];
    
    _refreshing = YES;
    _headerView.state = IDRefreshHeaderStateRefreshing;
	[_activityIndicator startAnimating];
    _scrollView.delegate = nil;
    
    // Load data and setup state in completion block
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.inkdryercreative.com/lineup/?feed=json&time=%d", [[NSDate date] timeIntervalSince1970]]]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        // Parse the results
        NSArray *results = (NSArray *)JSON;
        if([results count] > 0)
        {
            // Only the most recent entry will be used
            NSDictionary *mostRecentEntry = [results objectAtIndex:0];
            int entryPostID = [[mostRecentEntry objectForKey:@"id"] intValue];
            
            IDTeamInfo *cachedTeam = [IDAppModel sharedModel].currentTeamInfo;
            if(cachedTeam.postID != entryPostID)
            {
                // Grab the content JSON and remove all the garbage
                NSString *content = [mostRecentEntry objectForKey:@"content"];
                content = [content stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
                content = [content stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
                content = [content stringByReplacingOccurrencesOfString:@"\\U00a0" withString:@""];
                content = [content stringByReplacingOccurrencesOfString:@"\\U2022" withString:@""];
                content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                NSDictionary *contentJSON = [NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
                
                NSString *dateString = [contentJSON objectForKey:@"date"];
                BOOL isHome = [[contentJSON objectForKey:@"gabp"] isEqualToString:@"yes"];
                NSString *opponent = [contentJSON objectForKey:@"opponent"];
                
                int index = 0;
                NSMutableArray *tempLineup = [[NSMutableArray alloc] init];
                for(NSDictionary *playerJSON in [contentJSON objectForKey:@"lineup"])
                {
                    IDPlayerInfo *player = [[IDPlayerInfo alloc] init];
                    player.playerName = [playerJSON objectForKey:@"name"];
                    player.playerPosition = [playerJSON objectForKey:@"pos"];
                    player.playerIndex = index;
                    
                    index++;
                    [tempLineup addObject:player];
                }
                
                IDTeamInfo *team = [[IDTeamInfo alloc] init];
                team.postID = entryPostID;
                team.teamName = @"Reds"; //TODO: Support multiple teams
                team.gameDateString = dateString;
                team.opponentName = opponent;
                team.isHome = isHome;
                team.lineup = tempLineup;
                
                [IDAppModel sharedModel].currentTeamInfo = team;
                [[IDAppModel sharedModel] save];
                
                [self updateContent];
            }
        }
        
        // Update the view state
        _refreshing = NO;
        _headerView.state = IDRefreshHeaderStateNotReady;
        [_activityIndicator stopAnimating];
        _scrollView.delegate = self;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        // Display an error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"There was a problem updating the lineup, please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        // Update the view state
        _refreshing = NO;
        _headerView.state = IDRefreshHeaderStateNotReady;
        [_activityIndicator stopAnimating];
        _scrollView.delegate = self;
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op];
}

- (void) updateContent
{
    IDTeamInfo *team = [IDAppModel sharedModel].currentTeamInfo;
    
    if ([self noGameToday:team]) return;
    
    _notPostedImageView.hidden = YES;
    _notScheduledImageView.hidden = YES;
    
    _opponentLabel.text = [NSString stringWithFormat:@" %@", team.opponentName];
    _dateLabel.text = team.gameDateString;
    
    if(team.isHome)
    {
        _homeImage.hidden = NO;
        _awayImage.hidden = YES;
    }
    else
    {
        _homeImage.hidden = YES;
        _homeImage.hidden = NO;
    }
    
    for(IDPlayerInfo *player in team.lineup)
    {
        UILabel *nameLabel = (UILabel *)[self.view viewWithTag:PLAYER_NAME_TAG_START + player.playerIndex];
        UILabel *posLabel = (UILabel *)[self.view viewWithTag:PLAYER_POS_TAG_START + player.playerIndex];
        
        nameLabel.text = [NSString stringWithFormat:@" %@", player.playerName];
        posLabel.text = player.playerPosition;
    }
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

#pragma mark - Label Adjustment

- (void)addPadding:(CGFloat)padding toLabel:(UILabel *)label
{
    CGRect frame = label.frame;
    frame.origin.x -= padding;
    frame.origin.y -= padding;
    frame.size.width += padding * 2;
    frame.size.height += padding * 2;
    label.frame = frame;
}

#pragma mark - Conditions for no game

- (BOOL)noGameToday:(IDTeamInfo *)team
{
    NSString *dateString = [[[team.gameDateString stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@"•"] objectAtIndex:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yy"];
    NSDate *gameDate = [formatter dateFromString:dateString];
    
    NSDate *today = [NSDate date];
    today = [formatter dateFromString:[formatter stringFromDate:today]];
    
    // If the current lineup is not today, let's see why
    if (![gameDate isEqualToDate:today])
    {
        BOOL offToday = NO;
        
        NSDate *firstDate = [formatter dateFromString:@"3/3/12"];
        NSDate *lastDate = [formatter dateFromString:@"10/3/12"];
        
        // Check to see if they aren't playing
        NSArray *daysOff = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"DaysOff" withExtension:@"plist"]];
        for (NSString *dayOff in daysOff)
        {
            NSDate *dateOff = [formatter dateFromString:[NSString stringWithFormat:@"%@/12", dayOff]];
            if ([dateOff isEqualToDate:today])
            {
                offToday = YES;
            }
        }
        
        // Clear the labels
        _opponentLabel.text = @"";
        _dateLabel.text = @"";
        
        _homeImage.hidden = YES;
        _awayImage.hidden = YES;
        
        for(IDPlayerInfo *player in team.lineup)
        {
            UILabel *nameLabel = (UILabel *)[self.view viewWithTag:PLAYER_NAME_TAG_START + player.playerIndex];
            UILabel *posLabel = (UILabel *)[self.view viewWithTag:PLAYER_POS_TAG_START + player.playerIndex];
            
            nameLabel.text = @"";
            posLabel.text = @"";
        }
        
        if (offToday || [today timeIntervalSince1970] < [firstDate timeIntervalSince1970] || [today timeIntervalSince1970] > [lastDate timeIntervalSince1970])
        {
            _notScheduledImageView.hidden = NO;
        }
        else
        {
            _notPostedImageView.hidden = NO;
        }
        
        return YES;
    }
     
    return NO;
}

@end
