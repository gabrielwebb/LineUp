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
    UILabel *_statusLabel;
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
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 30)];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = UITextAlignmentCenter;
        _statusLabel.text = @"Pull to refresh";
        [self addSubview:_statusLabel];
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
				_statusLabel.text = @"Pull to refresh";
				break;
			case IDRefreshHeaderStateReady:
				_statusLabel.text = @"Release";
				break;
			case IDRefreshHeaderStateRefreshing:
				_statusLabel.text = @"Refreshing...";
				break;
			default:
				break;
		}
	}
}

@end
