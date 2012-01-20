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
}

- (void) reloadData;

@end
