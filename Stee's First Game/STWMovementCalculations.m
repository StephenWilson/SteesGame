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


@end
