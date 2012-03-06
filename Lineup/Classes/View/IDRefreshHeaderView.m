//
//  IDRefreshHeaderView.m
//  LineUp
//
//  Created by Andy Roth on 1/19/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import "IDRefreshHeaderView.h"

@interface IDRefreshHeaderView ()
{
@private
    UIImageView *_textImage;
    UIImageView *_arrowImage;
}
@end

@implementation IDRefreshHeaderView

@synthesize state = _state;

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        _textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshText.png"]];
        _textImage.center = CGPointMake(roundf(frame.size.width/2.0) + 10, roundf(frame.size.height/2.0));
        [self addSubview:_textImage];
        
        _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"RefreshArrow.png"]];
        _arrowImage.center = CGPointMake(roundf(frame.size.width/2.0) - 50, roundf(frame.size.height/2.0));
        [self addSubview:_arrowImage];
    }
    return self;
}

- (void) setState:(IDRefreshHeaderState)state
{
	if (state != _state)
	{
        _state = state;
		switch (state)
		{
			case IDRefreshHeaderStateNotReady:
            {
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
				break;
			case IDRefreshHeaderStateReady:
            {
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI - .001);
                }];
            }
				break;
			case IDRefreshHeaderStateRefreshing:
            {
                [UIView animateWithDuration:0.2 animations:^{
                    _arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
				break;
			default:
				break;
		}
	}
}

@end
