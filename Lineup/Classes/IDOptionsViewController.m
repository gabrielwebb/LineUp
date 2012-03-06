//
//  OptionsViewController.m
//  LineUp
//
//  Created by Andy Roth on 1/18/12.
//  Copyright (c) 2012 AKQA. All rights reserved.
//

#import "IDOptionsViewController.h"

@interface IDOptionsViewController ()

- (void) enableNotifications;
- (void) disableNotifications;

@end

@implementation IDOptionsViewController

- (void) viewDidLoad
{
    //TODO: Set which button is selected based on saved settings
    _offButton.selected = YES;
    
    UITapGestureRecognizer *tapReco = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapBackground:)];
    [_background addGestureRecognizer:tapReco];
}

- (IBAction) tappedButton:(UIButton *)sender
{
    if(sender == _onButton)
    {
        _onButton.selected = YES;
        _offButton.selected = NO;
        
        [self enableNotifications];
    }
    else
    {
        _onButton.selected = NO;
        _offButton.selected = YES;
        
        [self disableNotifications];
    }
}

- (void) enableNotifications
{
    //TODO: Implement
}

- (void) disableNotifications
{
    //TODO: Implement
}

- (void) didTapBackground:(UITapGestureRecognizer *)reco
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}

@end
