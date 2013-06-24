//
//  STWSecondScene.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 24/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWSecondScene.h"
#import "STWMyScene_Private.h"

@implementation STWSecondScene


- (void) setupWorld
{
	self.backgroundColor = [SKColor colorWithRed:0.2 green:0.8 blue:0 alpha:1.0];
	[super setupWorld];
	
	[self.foregroundNode addChild:self.boyCharacter];
	self.currentCharacter = self.boyCharacter;
}

@end
