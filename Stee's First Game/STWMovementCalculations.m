//
//  STWMovementCalculations.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 17/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWMovementCalculations.h"

@implementation STWMovementCalculations


+(CGFloat) distanceBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
	return sqrt(pow(pointB.x-pointA.x,2)+pow(pointB.y-pointA.y,2));
}


+(CGFloat) angleBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB
{
	CGFloat height = pointB.y - pointA.y;
	CGFloat width = pointA.x - pointB.x;
	CGFloat rads = atan(height/width);
	return rads;
}


@end
