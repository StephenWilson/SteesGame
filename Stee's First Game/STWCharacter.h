//
//  STWCharacter.h
//  Stee's First Game
//
//  Created by Stephen Wilson on 29/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STWCharacter : SKSpriteNode

- (void) actionOnPoint:(CGPoint)point;

- (void) toggleWeapon;

@end
