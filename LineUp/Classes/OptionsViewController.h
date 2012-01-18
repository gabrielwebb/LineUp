//
//  OptionsViewController.h
//  LineUp
//
//  Created by Andy Roth on 1/18/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UIViewController
{
    IBOutlet UIButton *_offButton;
    IBOutlet UIButton *_onButton;
    IBOutlet UIImageView *_background;
}

- (IBAction) tappedButton:(UIButton *)sender;

@end
