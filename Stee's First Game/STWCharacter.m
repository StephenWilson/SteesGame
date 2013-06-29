//
//  STWCharacter.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 29/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWCharacter.h"
#import "STWMovementCalculations.h"


#define CHARACTER_FACES_SIDE_KEY	@"STWCharacterFacesSideKey"


@implementation STWCharacter


- (void) actionOnPoint:(CGPoint)point
{
	// Work out how long the walk should take by t = d/s
	CGFloat distance = [STWMovementCalculations distanceBetweenPointA:self.position
															   pointB:point];
	CGFloat duration = distance / 400;
	if (duration <= 0) return;
	
	SKAction *boyWalkAction = [SKAction moveTo:point duration:duration];
	if (![self actionForKey:@"CharacterWalk"]) {
		// Face the character to the direction they are going if neccassary
		BOOL facingWrongDirection = (point.x < self.position.x && self.size.width > 0) ||
		(point.x > self.position.x && self.size.width < 0);
		BOOL characterFacesSide = [[self.userData objectForKey:CHARACTER_FACES_SIDE_KEY] boolValue];
		if (facingWrongDirection && characterFacesSide) {
			SKAction *turnAroundAction = [SKAction resizeByWidth:-2*self.size.width height:0 duration:0.0];
			[self runAction:turnAroundAction];
		}
	
		[self runAction:boyWalkAction withKey:@"CharacterWalk"];
	}
}


- (void) toggleWeapon
{
	// Weapons should be implemented by subclasses if required
}

@end
