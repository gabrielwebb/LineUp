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

#import <QuartzCore/QuartzCore.h>

static const int PLAYER_NAME_TAG_START = 100;
static const int PLAYER_POS_TAG_START = 200;

@interface IDLineupViewController ()
{
@private
    IDRefreshHeaderView *_headerView;
    BOOL _refreshing;
}

- (void) updateContent;

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
        
        // Rotate slightly
        int random = arc4random() % 3;

        label.layer.anchorPoint = CGPointMake(0, 1);
        label.transform = CGAffineTransformMakeRotation(-random * 0.0174532925);
        
        // Re-adjust the frame after rotation transformation (should probably take into account the angle, too)
        label.frame = CGRectMake(label.frame.origin.x - (label.frame.size.width/2), label.frame.origin.y + (label.frame.size.height/2), label.frame.size.width, label.frame.size.height);
    }
    
    _dateLabel.font = [UIFont fontWithName:@"Avenir" size:13.0];
    _dateLabel.text = @"";
	
	_scrollView.contentSize = CGSizeMake(320, 460);
    _scrollView.delegate = self;
	
	// Create the pull to refresh view
	_headerView = [[IDRefreshHeaderView alloc] initWithFrame:CGRectMake(0, -101, 320, 100)];
	[_scrollView addSubview:_headerView];
    
    [self updateContent];
    
    // Animate open the default image
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    imageView.frame = CGRectMake(-320/2, -20, 320, 480);
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:1.3 animations:^{
        imageView.layer.anchorPoint = CGPointMake(0, 0.5);
        
        CATransform3D transform = CATransform3DMakeRotation(-90 * 0.0174532925, 0, 1, 0);
        transform = CATransform3DScale(transform, 1, 1.2, 1);
        transform = CATransform3DTranslate(transform, 0, 0, 30);
        imageView.layer.transform = transform;
        
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
    }];
}

#pragma mark - Lineup Data

- (void) reloadData
{
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
                    player.playerPosition = [[playerJSON objectForKey:@"pos"] intValue];
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
    
    _opponentLabel.text = team.opponentName;
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
        
        nameLabel.text = player.playerName;
        posLabel.text = [NSString stringWithFormat:@"%d", player.playerPosition];
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

@end
