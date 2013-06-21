//
//  STWBarrelNode.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 21/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWBarrelNode.h"
#import "STWBoxNode+Private.h"

@implementation STWBarrelNode



- (STWBoxNodeDestuctType) destructType
{
	return STWBoxNodeDestuctTypeFire;
}


- (NSString *) imageName
{
	return @"barrel_flammable";
}


@end
