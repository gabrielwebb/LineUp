//
//  UIView+IDAdditions.m
//  LineUp
//
//  Created by Andy Roth on 1/31/12.
//  Copyright (c) 2012 Roozy. All rights reserved.
//

#import "UIView+IDAdditions.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (IDAdditions)

- (void) setTransformationPoint:(CGPoint)transformationPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * transformationPoint.x, self.bounds.size.height * transformationPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
	
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
	
    CGPoint position = self.layer.position;
	
    position.x -= oldPoint.x;
    position.x += newPoint.x;
	
    position.y -= oldPoint.y;
    position.y += newPoint.y;
	
    self.layer.position = position;
    self.layer.anchorPoint = transformationPoint;
}

- (CGPoint) transformationPoint
{
    return self.layer.anchorPoint;
}

@end
