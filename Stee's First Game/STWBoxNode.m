//
//  STWBoxNode.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 21/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWBoxNode.h"
#import "STWBoxNode+Private.h"

@interface STWBoxNode ()

@property (nonatomic) BOOL destroyed;
@property (nonatomic, retain) SKSpriteNode *imageNode;
@property (nonatomic, retain) SKEmitterNode *destructingNode;

@end



@implementation STWBoxNode


- (id) init
{
	self = [super init];
	if (self) {
		
		[self addChild:self.imageNode];
		
		[self addChild:self.destructingNode];
		
		SKPhysicsBody *boxPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.imageNode.frame.size];
		boxPhysicsBody.allowsRotation = NO;
		self.physicsBody = boxPhysicsBody;
	}
	return self;
}



- (SKSpriteNode *) imageNode
{
	if (!_imageNode) {
		_imageNode = [SKSpriteNode spriteNodeWithImageNamed:self.imageName];
	}
	return _imageNode;
}



- (NSString *) imageName
{
	return @"box_wooden";
}



- (SKEmitterNode *) destructingNode
{
	if (!_destructingNode) {
		_destructingNode = [NSKeyedUnarchiver unarchiveObjectWithFile:
							[[NSBundle mainBundle] pathForResource:@"BoxDestruct" ofType:@"sks"]];
		_destructingNode.alpha = 0.0;
	}
	return _destructingNode;
}



- (void) destruct
{
	if (self.destroyed) return;
	self.destroyed = YES;
	
	CGFloat duration = 0.2;
	SKAction *destroyActionA = [SKAction fadeAlphaTo:0.0 duration:duration];

	if (self.destructType == STWBoxNodeDestuctTypeFire) {
	SKAction *destroyActionB = [SKAction fadeAlphaTo:1.0 duration:duration];
		
		[self.imageNode runAction:destroyActionA];
		[self.destructingNode runAction:destroyActionB completion:^(void) {
			[self.destructingNode runAction:destroyActionA completion:^(void) {
				[self removeFromParent];
			}];
		}];
	}
	else {
		[self.imageNode runAction:destroyActionA completion:^(void) {
			[self removeFromParent];
		}];
	}
}


- (STWBoxNodeDestuctType) destructType
{
	return STWBoxNodeDestuctTypeDefault;
}


@end
