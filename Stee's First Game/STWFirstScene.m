//
//  STWFirstScene.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 24/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWFirstScene.h"
#import "STWMyScene_Private.h"


@interface STWFirstScene ()

@end


@implementation STWFirstScene


- (void) setupWorld
{
	[super setupWorld];
	[self addPictureFrame:@"Picture_sca_fell" atPosition:CGPointMake(300, 320)];
	[self addPictureFrame:@"Picture_ennerdale" atPosition:CGPointMake(300, 120)];
	
	[self addBoxAtPosition:CGPointMake(self.boyCharacter.position.x + 100., self.boyCharacter.position.y)];
	
	[self addBarrelAtPosition:CGPointMake(self.boyCharacter.position.x + 200., self.boyCharacter.position.y)];
	[self addBarrelAtPosition:CGPointMake(self.boyCharacter.position.x + 260., self.boyCharacter.position.y)];
	[self addBarrelAtPosition:CGPointMake(self.boyCharacter.position.x + 320., self.boyCharacter.position.y)];
	
	[self.foregroundNode addChild:self.boyCharacter];
	self.currentCharacter = self.boyCharacter;
	[self.foregroundNode addChild:self.elephantCharacter];
	
	[self addWindowAtPosition:CGPointMake(90., 120.)];
	[self addWindowAtPosition:CGPointMake(90., 360.)];
	[self addWindowAtPosition:CGPointMake(self.frame.size.width - 90, 360.)];
	
	CGRect ladderRect = CGRectMake(self.frame.size.width - 90 - (LADDER_SIZE / 2.),
								   30+(LADDER_SIZE/2.),
								   LADDER_SIZE,
								   LADDER_SIZE * 3);
	[self addLadderInRect:ladderRect];
}


@end
