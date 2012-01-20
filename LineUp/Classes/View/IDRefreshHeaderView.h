//
//  IDRefreshHeaderView.h
//  LineUp
//
//  Created by Andy Roth on 1/19/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
	IDRefreshHeaderStateNotReady = 0,
	IDRefreshHeaderStateReady = 1,
	IDRefreshHeaderStateRefreshing
} IDRefreshHeaderState;

@interface IDRefreshHeaderView : UIView

@property (nonatomic) IDRefreshHeaderState state;

@end
