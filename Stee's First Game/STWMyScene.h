//
//  STWMyScene.h
//  Stee's First Game
//

//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>


@protocol STWSceneDelegate;


@interface STWMyScene : SKScene

@property (nonatomic, assign) id<STWSceneDelegate> delegate;

@end


@protocol STWSceneDelegate <NSObject>

- (void) scene:(STWMyScene *)scene didPositionMainCharacter:(CGPoint)position duration:(NSTimeInterval)duration;

@end