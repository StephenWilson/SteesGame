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
#import "STWMyScene_Private.h"


#define CHARACTER_FACES_SIDE_KEY	@"STWCharacterFacesSideKey"


@interface STWMyScene ()


@property (nonatomic, retain) SKShapeNode *groundNode;
@property (nonatomic, retain) SKShapeNode *firstFloor;
@property (nonatomic, retain) SKShapeNode *leftWall;
@property (nonatomic, retain) SKShapeNode *rightWall;
@property (nonatomic, retain) NSMutableArray *ladders;
@property (nonatomic, retain) STWSpriteNode *parallaxContainer;
@property (nonatomic) BOOL worldMovedForUpdate;
@property (nonatomic, retain) NSMutableArray *boxes;
@property (nonatomic, retain) UITouch *currentTouch;


@end


@interface STWMyScene (Actions)

- (void) walkCharacter:(SKSpriteNode *)character To:(CGPoint)pointB;
- (void) moveCameraTo:(CGPoint)point duration:(NSTimeInterval)duration;

@end

@interface STWMyScene (Positioning)

- (CGPoint) worldPositionForCamera:(CGPoint)position;
- (void) centreOnPosition:(CGPoint)position;

@end

@implementation STWMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0 alpha:1.0];
        self.anchorPoint = CGPointMake(0, 0.);
		
		// Setup the world
		[self setupWorld];
    }
    return self;
}


- (void) setupWorld
{
	self.world = [SKNode node];
	[self addChild:self.world];
	
	self.backgroundNode = [SKNode node];
	self.foregroundNode = [SKNode node];
	
	[self.foregroundNode addChild:self.groundNode];
	[self.foregroundNode addChild:self.firstFloor];
	[self.foregroundNode addChild:self.leftWall];
	[self.foregroundNode addChild:self.rightWall];
	
	self.parallaxContainer = [[STWSpriteNode alloc] initWithSprites:@[self.backgroundNode, self.foregroundNode] usingOffset:25.];
	[self.world addChild:self.parallaxContainer];
}


- (BOOL) rectIntersectsLadder:(CGRect)rect
{
	for (SKNode *ladder in self.ladders) {
		if (CGRectIntersectsRect(rect, ladder.calculateAccumulatedFrame)) {
			return YES;
		}
	}
	return NO;
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
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
	CGPoint aPoint = [self worldPositionForCamera:point];
	CGPoint thePoint = CGPointMake(-aPoint.x + CGRectGetMidX(self.frame),
								   -aPoint.y + CGRectGetMidY(self.frame));
	SKAction *moveWorld = [SKAction moveTo:thePoint duration:duration];
	[self.world runAction:moveWorld withKey:@"MoveCamera"];
}

@end

@implementation STWMyScene (Objects)



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


- (void) addPictureFrame:(NSString *)imageName atPosition:(CGPoint)position
{
	STWPictureFrameNode *pictureFrame = [STWPictureFrameNode pictureFrameNodeWithImage:[UIImage imageNamed:imageName]];
	pictureFrame.position = position;
	[self.backgroundNode addChild:pictureFrame];
}


- (void) addWindowAtPosition:(CGPoint)position
{
	SKSpriteNode *window = [SKSpriteNode spriteNodeWithImageNamed:@"WindowTall"];
	window.position = position;
	
	[self.backgroundNode addChild:window];
}


- (void) addLadderInRect:(CGRect)worldRect
{
	NSInteger ladderParts = floor(worldRect.size.height / LADDER_SIZE);
	SKNode *ladderNode = [SKNode node];
	ladderNode.position = CGPointMake(CGRectGetMidX(worldRect),
									  CGRectGetMidY(worldRect));
	
	CGFloat yOffset = worldRect.size.height - (ladderParts * LADDER_SIZE) - (worldRect.size.height / 2.);
	
	for (int i=0; i<3; i++) {
		SKSpriteNode *ladderPart = [SKSpriteNode spriteNodeWithImageNamed:@"Ladders"];
		ladderPart.position = CGPointMake(0., yOffset);
		ladderPart.size = CGSizeMake(LADDER_SIZE, LADDER_SIZE);
		yOffset += LADDER_SIZE;
		
		[ladderNode addChild:ladderPart];
	}
	
	[self.backgroundNode addChild:ladderNode];
	
	if (!self.ladders) {
		self.ladders = [NSMutableArray array];
	}
	[self.ladders addObject:ladderNode];
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
		_groundNode.position = CGPointMake(CGRectGetMidX(self.frame)+14, 15.);
		_groundNode.fillColor = [UIColor brownColor];
		_groundNode.strokeColor = [UIColor darkGrayColor];
		_groundNode.path = CGPathCreateWithRect(CGRectMake(-CGRectGetMidX(self.frame),
														   -15.,
														   self.frame.size.width,
														   30.), NULL);
		_groundNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width,
																					5)];
		_groundNode.physicsBody.dynamic = NO;
		_groundNode.physicsBody.affectedByGravity = NO;
	}
	return _groundNode;
}



- (SKShapeNode *) firstFloor
{
	if (!_firstFloor) {
		_firstFloor = [SKShapeNode node];
		CGFloat firstFloorWidth = 500;
		_firstFloor.position = CGPointMake((firstFloorWidth/2), 230.);
		_firstFloor.fillColor = [UIColor brownColor];
		_firstFloor.strokeColor = [UIColor darkGrayColor];
		_firstFloor.path = CGPathCreateWithRect(CGRectMake(-(firstFloorWidth/2), -15, firstFloorWidth, 30), NULL);
		_firstFloor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(firstFloorWidth, 5)];
		_firstFloor.physicsBody.dynamic = NO;
		_firstFloor.physicsBody.affectedByGravity = NO;
	}
	return _firstFloor;
}



- (SKShapeNode *) leftWall
{
	if (!_leftWall) {
		_leftWall = [SKShapeNode node];
		_leftWall.position = CGPointMake(15., CGRectGetMidY(self.frame)+12);
		_leftWall.fillColor = [UIColor brownColor];
		_leftWall.strokeColor = [UIColor darkGrayColor];
		
		CGFloat wallHeight = self.frame.size.height + (_leftWall.lineWidth * 2.0) + 1.;
		_leftWall.path = CGPathCreateWithRect(CGRectMake(-15.,
														 -wallHeight/2.0,
														 30.,
														 wallHeight), NULL);
		_leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30,
																				  wallHeight)];
		_leftWall.physicsBody.dynamic = NO;
		_leftWall.physicsBody.affectedByGravity = NO;
	}
	return _leftWall;
}



- (SKShapeNode *) rightWall
{
	if (!_rightWall) {
		_rightWall = [SKShapeNode node];
		_rightWall.position = CGPointMake(self.frame.size.width+5, CGRectGetMidY(self.frame)+12);
		_rightWall.fillColor = [UIColor brownColor];
		_rightWall.strokeColor = [UIColor darkGrayColor];
		
		CGFloat wallHeight = self.frame.size.height + (_rightWall.lineWidth * 2.0) + 1.;
		_rightWall.path = CGPathCreateWithRect(CGRectMake(-15.,
														 -wallHeight/2.0,
														 30.,
														 wallHeight), NULL);
		_rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(30,
																				  wallHeight)];
		_rightWall.physicsBody.dynamic = NO;
		_rightWall.physicsBody.affectedByGravity = NO;
	}
	return _rightWall;
}

@end

@implementation STWMyScene (Positioning)


- (CGPoint) worldPositionForCamera:(CGPoint)position
{
	CGFloat x = -position.x;
	CGFloat y = -position.y;
	
	CGSize viewableSize = CGSizeMake([self convertPointFromView:CGPointMake(CGRectGetMaxX(self.view.bounds), 0.)].x - [self convertPointFromView:CGPointZero].x,
									 [self convertPointFromView:CGPointZero].y - [self convertPointFromView:CGPointMake(0, CGRectGetMaxY(self.view.bounds))].y);
	
	if (-x < (viewableSize.width/2.0)) {
		x = -(viewableSize.width/2.0);
	}
	else if (-x > self.frame.size.width - (viewableSize.width / 2.0)) {
		x = -(self.frame.size.width - (viewableSize.width / 2.0));
	}
	
	if (-y < (viewableSize.height/2.0)) {
		y = -(viewableSize.height/2.0);
	}
	else if (-y > self.frame.size.height - (viewableSize.height / 2.0)) {
		y = -(self.frame.size.height - (viewableSize.height / 2.0));
	}
	
	return CGPointMake(-x, -y);
}



- (void) centreOnPosition:(CGPoint)position
{
	self.world.position = CGPointMake(-position.x + CGRectGetMidX(self.frame),
									  -position.y + CGRectGetMidY(self.frame));
}


- (void)didSimulatePhysics {
    [super didSimulatePhysics];
	
	if ([self rectIntersectsLadder:self.currentCharacter.frame]) {
		self.currentCharacter.physicsBody.affectedByGravity = NO;
	}
	else {
		self.currentCharacter.physicsBody.affectedByGravity = YES;
	}
	
	if (self.currentCharacter && ![self.world actionForKey:@"MoveCamera"]) {
		
		[self centreOnPosition:[self worldPositionForCamera:self.currentCharacter.position]];
    }
	
	// Perform clearWorldMove after subclasses execute didSimulatePhysics
    //[self performSelector:@selector(clearWorldMoved)                  withObject:nil afterDelay:0.0f];
	
	[self.parallaxContainer updateOffset];
}

@end