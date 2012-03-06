//
//  ViewController.h
//  LineUp
//
//  Created by Gabriel Webb on 1/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDLineupViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutletCollection(UILabel) NSArray *_journalLabels;
	IBOutlet UIScrollView *_scrollView;
    IBOutlet UIActivityIndicatorView *_activityIndicator;
    
    IBOutlet UILabel *_opponentLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet UIImageView *_homeImage;
    IBOutlet UIImageView *_awayImage;
    
    IBOutlet UIImageView *_notPostedImageView;
    IBOutlet UIImageView *_notScheduledImageView;
}

- (void) reloadData;

@end
