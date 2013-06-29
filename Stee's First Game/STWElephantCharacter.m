//
//  STWElephantCharacter.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 29/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWElephantCharacter.h"
#import "STWCharacter_Private.h"

@implementation STWElephantCharacter


+ (STWElephantCharacter *) elephantCharacter
{
	STWElephantCharacter *elephantCharacter = [STWElephantCharacter spriteNodeWithImageNamed:@"Elephant"];
	elephantCharacter.position = CGPointMake(300., 500.);
	SKPhysicsBody *elephantPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(140., 102.)];
	elephantPhysicsBody.allowsRotation = NO;
	elephantCharacter.physicsBody = elephantPhysicsBody;
	
	return elephantCharacter;
}


- (BOOL) facesSide
{
	return YES;
}

@end
