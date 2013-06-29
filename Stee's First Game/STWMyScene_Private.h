//
//  STWMyScene_Private.h
//  Stee's First Game
//
//  Created by Stephen Wilson on 24/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWMyScene.h"
#import "STWBoyCharacter.h"
#import "STWElephantCharacter.h"

#define LADDER_SIZE					66

@interface STWMyScene ()

@property (nonatomic, retain) SKNode *world;
@property (nonatomic, retain) SKNode *backgroundNode;
@property (nonatomic, retain) SKNode *foregroundNode;

@property (nonatomic, retain) STWCharacter *currentCharacter;
@property (nonatomic, retain) STWBoyCharacter *boyCharacter;
@property (nonatomic, retain) STWElephantCharacter *elephantCharacter;


- (void) setupWorld;

@end

@interface STWMyScene (Objects)

- (void) addBoxAtPosition:(CGPoint)position;
- (void) addBarrelAtPosition:(CGPoint)position;
- (void) addPictureFrame:(NSString *)imageName atPosition:(CGPoint)position;

- (void) addWindowAtPosition:(CGPoint)position;
- (void) addLadderInRect:(CGRect)worldRect;

@end