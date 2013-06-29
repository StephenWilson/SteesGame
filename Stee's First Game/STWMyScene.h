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

- (void) toggleWeapon;

@end


@protocol STWSceneDelegate <NSObject>

@end