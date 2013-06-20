//
//  STWSpriteNode.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 19/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWSpriteNode.h"


@interface STWSpriteNode ()

@property (nonatomic) CGFloat parallaxOffset;

@end


@implementation STWSpriteNode


- (id)initWithSprites:(NSArray *)sprites usingOffset:(CGFloat)offset {
    self = [super init];
    if (self) {
        _usesParallaxEffect = YES;
        CGFloat zOffset = 1.0f / (CGFloat)[sprites count];
        CGFloat ourZPosition = self.zPosition;
        NSUInteger childNumber = 0;
        for (SKNode *node in sprites) {
            node.zPosition = ourZPosition - (zOffset + (zOffset * childNumber));
            [self addChild:node];
            childNumber++;
        }
        _parallaxOffset = offset;
    }
    return self;
}


- (void)updateOffset {
    SKScene *scene = self.scene;
    SKNode *parent = self.parent;
//    ... (Return early if parallax is disabled)
	
    CGPoint scenePos = [scene convertPoint:self.position fromNode:parent];
    CGFloat offsetX =  (-1.0f + (2.0 * (scenePos.x / scene.size.width)));
    CGFloat offsetY =  (-1.0f + (2.0 * (scenePos.y / scene.size.height)));
    CGFloat delta = self.parallaxOffset / (CGFloat)self.children.count;
	
    int childNumber = 0;
    for (SKNode *node in self.children) {
        node.position = CGPointMake(offsetX*delta*childNumber,
									offsetY*delta*childNumber);
        childNumber++;
		//NSLog(@"Paralllax Node: %@", NSStringFromCGPoint(node.position));
		
    }
}


@end
