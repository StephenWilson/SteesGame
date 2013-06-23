//
//  STWMyScene.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 17/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWMyScene.h"
#import "STWMovementCalculations.h"
#import "STWSpriteNode.h"
#import "STWBoxNode.h"
#import "STWBarrelNode.h"
#import "STWPictureFrameNode.h"


#define LADDER_SIZE					66
#define CHARACTER_FACES_SIDE_KEY	@"STWCharacterFacesSideKey"



@interface STWMyScene ()


@property (nonatomic, retain) SKSpriteNode *currentCharacter;
@property (nonatomic, retain) SKSpriteNode *boyCharacter;
@property (nonatomic, retain) SKSpriteNode *elephantCharacter;
@property (nonatomic, retain) SKShapeNode *groundNode;
@property (nonatomic, retain) SKSpriteNode *window1;
@property (nonatomic, retain) SKSpriteNode *window2;
@property (nonatomic, retain) SKSpriteNode *window3;
@property (nonatomic, retain) SKShapeNode *firstFloor;
@property (nonatomic, retain) SKSpriteNode *ladder;
@property (nonatomic, retain) SKSpriteNode *ladder2;
@property (nonatomic, retain) SKSpriteNode *ladder3;
@property (nonatomic, retain) SKNode *world;
@property (nonatomic, retain) SKNode *backgroundNode;
@property (nonatomic, retain) SKNode *foregroundNode;
@property (nonatomic, retain) STWSpriteNode *parallaxContainer;
@property (nonatomic) BOOL worldMovedForUpdate;
@property (nonatomic, retain) NSMutableArray *boxes;
@property (nonatomic, retain) UITouch *currentTouch;


@end


@interface STWMyScene (Actions)

- (void) walkCharacter:(SKSpriteNode *)character To:(CGPoint)pointB;
- (void) moveCameraTo:(CGPoint)point duration:(NSTimeInterval)duration;

@end


@interface STWMyScene (Objects)

- (void) addBoxAtPosition:(CGPoint)position;
- (void) addBarrelAtPosition:(CGPoint)position;

@end


@implementation STWMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0 alpha:1.0];
        
		self.anchorPoint = CGPointMake(0, 0.);
		
		// Setup the world
		self.world = [SKNode node];
		[self addChild:self.world];
		
		self.backgroundNode = [SKNode node];
		self.foregroundNode = [SKNode node];
		
		[self.foregroundNode addChild:self.groundNode];
		[self.backgroundNode addChild:self.window1];
		[self.backgroundNode addChild:self.window2];
		[self.backgroundNode addChild:self.window3];
		[self.foregroundNode addChild:self.firstFloor];
		[self.backgroundNode addChild:self.ladder];
		[self.backgroundNode addChild:self.ladder2];
		[self.backgroundNode addChild:self.ladder3];
		
		STWPictureFrameNode *scaFellPictureFrame = [STWPictureFrameNode pictureFrameNodeWithImage:[UIImage imageNamed:@"Picture_sca_fell"]];
		scaFellPictureFrame.position = CGPointMake(300, 300);
		[self.backgroundNode addChild:scaFellPictureFrame];
		
		[self addBoxAtPosition:CGPointMake(self.boyCharacter.position.x + 100., self.boyCharacter.position.y)];
		
		[self addBarrelAtPosition:CGPointMake(self.boyCharacter.position.x + 200., self.boyCharacter.position.y)];
		[self addBarrelAtPosition:CGPointMake(self.boyCharacter.position.x + 260., self.boyCharacter.position.y)];
		[self addBarrelAtPosition:CGPointMake(self.boyCharacter.position.x + 320., self.boyCharacter.position.y)];
		
		[self.foregroundNode addChild:self.boyCharacter];
		self.currentCharacter = self.boyCharacter;
		[self.foregroundNode addChild:self.elephantCharacter];
		
		self.parallaxContainer = [[STWSpriteNode alloc] initWithSprites:@[self.backgroundNode, self.foregroundNode] usingOffset:25.];
		[self.world addChild:self.parallaxContainer];
    }
    return self;
}


- (BOOL) rectIntersectsLadder:(CGRect)rect
{
	return (CGRectIntersectsRect(rect, self.ladder.frame) |
			CGRectIntersectsRect(rect, self.ladder2.frame) |
			CGRectIntersectsRect(rect, self.ladder3.frame));
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
	if ([self rectIntersectsLadder:self.currentCharacter.frame]) {
		self.currentCharacter.physicsBody.affectedByGravity = NO;
	}
	else {
		self.currentCharacter.physicsBody.affectedByGravity = YES;
	}
	
	for (STWBoxNode *aBoxNode in self.boxes) {
		CGRect smashCollisionFrame = CGRectMake(self.currentCharacter.frame.origin.x - 2.,
												self.currentCharacter.frame.origin.y - 2.,
												self.currentCharacter.frame.size.width + 2.,
												self.currentCharacter.frame.size.height + 2.);
		if (CGRectIntersectsRect(smashCollisionFrame, aBoxNode.frame)) {
			[aBoxNode destruct];
		}
		
	}
	
	if (self.currentTouch) {
		CGPoint aTouchPosition = [self.currentTouch locationInNode:self.world];
		[self walkCharacter:self.currentCharacter To:aTouchPosition];
	}
}

@end

@implementation STWMyScene (Characters)

- (SKSpriteNode *) boyCharacter
{
    if (!_boyCharacter) {
        _boyCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"Character_Boy"];
        _boyCharacter.position = CGPointMake(100, 120.);
		
		SKPhysicsBody *boyPhysicsBody = [SKPhysicsBody bodyWithCircleOfRadius:40];
		boyPhysicsBody.allowsRotation = NO;
		_boyCharacter.physicsBody = boyPhysicsBody;
		_boyCharacter.physicsBody.affectedByGravity = NO;
    }
    return _boyCharacter;
}


- (SKSpriteNode *) elephantCharacter
{
	if (!_elephantCharacter) {
		_elephantCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"Elephant"];
		_elephantCharacter.position = CGPointMake(300., 500.);
		SKPhysicsBody *elephantPhysicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(140., 102.)];
		elephantPhysicsBody.allowsRotation = NO;
		_elephantCharacter.physicsBody = elephantPhysicsBody;
		
		if (!_elephantCharacter.userData) _elephantCharacter.userData = [NSMutableDictionary dictionary];
		[_elephantCharacter.userData setObject:[NSNumber numberWithBool:YES] forKey:CHARACTER_FACES_SIDE_KEY];
		
	}
	return _elephantCharacter;
}


- (void) switchTo:(SKSpriteNode *)character
{
	// Work out how long the walk should take by t = d/s
	CGFloat distance = [STWMovementCalculations distanceBetweenPointA:self.currentCharacter.position
															   pointB:character.position];
	CGFloat duration = distance / 400;
	
	self.currentCharacter = character;
	[self moveCameraTo:self.currentCharacter.position duration:duration];
}

@end

@implementation STWMyScene (Actions)

- (void) walkCharacter:(SKSpriteNode *)character To:(CGPoint)pointB
{
	// Work out how long the walk should take by t = d/s
	CGFloat distance = [STWMovementCalculations distanceBetweenPointA:character.position
															   pointB:pointB];
	CGFloat duration = distance / 400;
	if (duration <= 0) return;
	
	SKAction *boyWalkAction = [SKAction moveTo:pointB duration:duration];
	if (![character actionForKey:@"CharacterWalk"]) {
		
		// Face the character to the direction they are going if neccassary
		BOOL facingWrongDirection = (pointB.x < character.position.x && character.size.width > 0) ||
								(pointB.x > character.position.x && character.size.width < 0);
		BOOL characterFacesSide = [[character.userData objectForKey:CHARACTER_FACES_SIDE_KEY] boolValue];
		if (facingWrongDirection && characterFacesSide) {
			SKAction *turnAroundAction = [SKAction resizeByWidth:-2*character.size.width height:0 duration:0.0];
			[character runAction:turnAroundAction];
		}
		
		[character runAction:boyWalkAction withKey:@"CharacterWalk"];
	}
}


- (void) moveCameraTo:(CGPoint)point duration:(NSTimeInterval)duration
{
	CGFloat x = -point.x;
	
	if (-x < (self.view.frame.size.width/2.0)) {
		x = -(self.view.frame.size.width/2.0);
	}
	else if (-x > self.frame.size.width - (self.view.frame.size.width / 2.0)) {
		x = -(self.frame.size.width - (self.view.frame.size.width / 2.0));
	}
	
	SKAction *moveWorld = [SKAction moveTo:CGPointMake(x + (self.frame.size.width / 2.0), self.world.position.y) duration:duration];
	[self.world runAction:moveWorld withKey:@"MoveCamera"];
}

@end

@implementation STWMyScene (Objects)

- (SKSpriteNode *) ladder
{
	if (!_ladder) {
		_ladder = [SKSpriteNode spriteNodeWithImageNamed:@"Ladders"];
		_ladder.position = CGPointMake(self.frame.size.width - 60, 30+(LADDER_SIZE/2.0));
		_ladder.size = CGSizeMake(LADDER_SIZE, LADDER_SIZE);
	}
	return _ladder;
}


- (SKSpriteNode *) ladder2
{
	if (!_ladder2) {
		_ladder2 = [SKSpriteNode spriteNodeWithImageNamed:@"Ladders"];
		_ladder2.position = CGPointMake(self.ladder.position.x, self.ladder.position.y+LADDER_SIZE);
		_ladder2.size = CGSizeMake(LADDER_SIZE, LADDER_SIZE);
	}
	return _ladder2;
}


- (SKSpriteNode *) ladder3
{
	if (!_ladder3) {
		_ladder3 = [SKSpriteNode spriteNodeWithImageNamed:@"Ladders"];
		_ladder3.position = CGPointMake(self.ladder.position.x, self.ladder2.position.y+LADDER_SIZE);
		_ladder3.size = CGSizeMake(LADDER_SIZE, LADDER_SIZE);
	}
	return _ladder3;
}



- (void) addBoxAtPosition:(CGPoint)position
{
	STWBoxNode *boxNode = [STWBoxNode node];
	boxNode.position = position;
	if (!self.boxes) {
		self.boxes = [NSMutableArray array];
	}
	[self.boxes addObject:boxNode];
	[self.foregroundNode addChild:boxNode];
}


- (void) addBarrelAtPosition:(CGPoint)position
{
	STWBarrelNode *barrelNode = [STWBarrelNode node];
	barrelNode.position = position;
	if (!self.boxes) {
		self.boxes = [NSMutableArray array];
	}
	[self.boxes addObject:barrelNode];
	[self.foregroundNode addChild:barrelNode];
}

@end

@implementation STWMyScene (UserInteraction)

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([touches count] == 1) {
		UITouch *aTouch = [touches anyObject];
		self.currentTouch = aTouch;
		CGPoint aTouchPosition = [aTouch locationInNode:self.world];
		
		if (self.currentCharacter != self.elephantCharacter &&
			CGRectContainsPoint(self.elephantCharacter.frame, aTouchPosition)) {
			[self switchTo:self.elephantCharacter];
		}
		else if (self.currentCharacter != self.boyCharacter &&
				 CGRectContainsPoint(self.boyCharacter.frame, aTouchPosition)) {
			[self switchTo:self.boyCharacter];
		}
		else {
			//[self walkCharacter:self.currentCharacter To:aTouchPosition];
		}
    }
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([touches count] == 1) {
		UITouch *aTouch = [touches anyObject];
		self.currentTouch = aTouch;
	}
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.currentTouch = nil;
}

@end

@implementation STWMyScene (HouseParts)

- (SKShapeNode *) groundNode
{
	if (!_groundNode) {
		_groundNode = [SKShapeNode node];
		_groundNode.position = CGPointMake(CGRectGetMidX(self.frame), 15.);
		_groundNode.fillColor = [UIColor brownColor];
		_groundNode.strokeColor = [UIColor darkGrayColor];
		_groundNode.path = CGPathCreateWithRect(CGRectMake(-CGRectGetMidX(self.frame),
														   -15.,
														   self.frame.size.width,
														   30.), NULL);
		_groundNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width,
																					5.)];
		_groundNode.physicsBody.dynamic = NO;
		_groundNode.physicsBody.affectedByGravity = NO;
	}
	return _groundNode;
}



- (SKShapeNode *) firstFloor
{
	if (!_firstFloor) {
		_firstFloor = [SKShapeNode node];
		CGFloat firstFloorWidth = 530;
		_firstFloor.position = CGPointMake((firstFloorWidth/2), 180.);
		_firstFloor.fillColor = [UIColor brownColor];
		_firstFloor.strokeColor = [UIColor darkGrayColor];
		_firstFloor.path = CGPathCreateWithRect(CGRectMake(-(firstFloorWidth/2), -15, firstFloorWidth, 30), NULL);
		_firstFloor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(firstFloorWidth, 5)];
		_firstFloor.physicsBody.dynamic = NO;
		_firstFloor.physicsBody.affectedByGravity = NO;
	}
	return _firstFloor;
}



- (SKSpriteNode *) window1
{
	if (!_window1) {
		_window1 = [SKSpriteNode spriteNodeWithImageNamed:@"WindowTall"];
		_window1.position = CGPointMake(60., 120.);
	}
	return _window1;
}


- (SKSpriteNode *) window2
{
	if (!_window2) {
		_window2 = [SKSpriteNode spriteNodeWithImageNamed:@"WindowTall"];
		_window2.position = CGPointMake(60., 320.);
	}
	return _window2;
}


- (SKSpriteNode *) window3
{
	if (!_window3) {
		_window3 = [SKSpriteNode spriteNodeWithImageNamed:@"WindowTall"];
		_window3.position = CGPointMake(self.frame.size.width - 60, 320.);
	}
	return _window3;
}

@end

@implementation STWMyScene (Parallax)

- (void)didSimulatePhysics {
    [super didSimulatePhysics];
	
	if (self.currentCharacter && ![self.world actionForKey:@"MoveCamera"]) {
        CGFloat x = -self.currentCharacter.position.x;
		
		if (-x < (self.view.frame.size.width/2.0)) {
			x = -(self.view.frame.size.width/2.0);
		}
		else if (-x > self.frame.size.width - (self.view.frame.size.width / 2.0)) {
			x = -(self.frame.size.width - (self.view.frame.size.width / 2.0));
		}

		self.world.position = CGPointMake(x + (self.frame.size.width / 2.0), self.world.position.y);
    }
	
	// Perform clearWorldMove after subclasses execute didSimulatePhysics
    //[self performSelector:@selector(clearWorldMoved)                  withObject:nil afterDelay:0.0f];
	
	[self.parallaxContainer updateOffset];
}

@end