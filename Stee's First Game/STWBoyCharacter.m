//
//  STWBoyCharacter.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 29/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWBoyCharacter.h"
#import "STWCharacter_Private.h"
#import "STWMovementCalculations.h"

#define GUN_AIM_RADIUS				30
#define BULLET_DIAMETER				5.

@interface STWBoyCharacter ()

@property (nonatomic, retain) SKSpriteNode *gunNode;

@property (nonatomic) BOOL gunActive;

- (void) aimGun:(CGPoint)target;
- (void) firegun:(CGPoint)target;

@end


@implementation STWBoyCharacter


+ (STWBoyCharacter *) boyCharacter
{
	STWBoyCharacter *boyCharacter = [STWBoyCharacter spriteNodeWithImageNamed:@"Character_Boy"];
	
	SKPhysicsBody *boyPhysicsBody = [SKPhysicsBody bodyWithCircleOfRadius:40];
	boyPhysicsBody.allowsRotation = NO;
	boyCharacter.physicsBody = boyPhysicsBody;
	boyCharacter.physicsBody.affectedByGravity = NO;
	
	return boyCharacter;
}


- (void) actionOnPoint:(CGPoint)point
{
	// If the gun is active then shoot otherwise move
	if (self.gunActive) {
		[self aimGun:point];
		[self firegun:point];
	}
	else {
		[super actionOnPoint:point];
	}
}


- (void) toggleWeapon
{
	if (!_gunNode) {
		[self addChild:self.gunNode];
	}
	
	if (self.gunActive) {
		[self.gunNode runAction:[SKAction fadeAlphaTo:0.0 duration:0.15]];
		self.gunActive = NO;
	}
	else {
		[self.gunNode runAction:[SKAction fadeAlphaTo:1.0 duration:0.15]];
		self.gunActive = YES;
	}
}


- (void) aimGun:(CGPoint)target
{
	target = [self convertPoint:target fromNode:self.parent];
	CGFloat newGunX = _gunNode.position.x;
	CGFloat newGunY = _gunNode.position.y;
	
	CGFloat angle = [STWMovementCalculations angleBetweenPointA:CGPointZero pointB:target];
	
	newGunX = (GUN_AIM_RADIUS * cos(angle));
	newGunY = (GUN_AIM_RADIUS * sin(angle));
	
	if (target.x > 0) {
		newGunY = newGunY * -1;
		self.gunNode.xScale = 1;
	}
	else {
		newGunX = newGunX * -1;
		self.gunNode.xScale = -1;
	}
	
	if (target.x < GUN_AIM_RADIUS && target.x > -GUN_AIM_RADIUS &&
		target.y < GUN_AIM_RADIUS && target.y > -GUN_AIM_RADIUS) {
		newGunX = target.x;
		newGunY = target.y;
	}
	
	self.gunNode.position = CGPointMake(newGunX, newGunY);
	self.gunNode.zRotation = -angle;
	
}


- (void) firegun:(CGPoint)target
{
	SKSpriteNode *bullet = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(BULLET_DIAMETER, BULLET_DIAMETER)];
	bullet.position = [self.parent convertPoint:self.gunNode.position fromNode:self];
	bullet.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:BULLET_DIAMETER];
	bullet.physicsBody.mass = 0.000001;
	[self.parent addChild:bullet];
	
	SKAction *fireAction = [SKAction moveTo:target duration:0.3];
	[bullet runAction:fireAction];
	
	SKAction *bulletFade = [SKAction fadeAlphaTo:0.0 duration:0.6];
	[bullet runAction:bulletFade completion:^(void){
		[bullet removeFromParent];
	}];
}


- (SKSpriteNode *) gunNode
{
	if (!_gunNode) {
		_gunNode = [SKSpriteNode spriteNodeWithImageNamed:@"Paintball_Gun"];
		_gunNode.position = CGPointMake(30, -15);
		_gunNode.alpha = 0.0;
	}
	return _gunNode;
}



- (BOOL) facesSide
{
	return NO;
}


@end
