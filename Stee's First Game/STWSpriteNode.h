//
//  STWSpriteNode.h
//  Stee's First Game
//
//  Created by Stephen Wilson on 19/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STWSpriteNode : SKSpriteNode


@property (nonatomic) BOOL usesParallaxEffect;


- (id)initWithSprites:(NSArray *)sprites usingOffset:(CGFloat)offset;
- (void)updateOffset;


@end
