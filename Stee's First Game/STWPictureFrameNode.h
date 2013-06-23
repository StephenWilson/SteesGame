//
//  STWPictureFrameNode.h
//  Stee's First Game
//
//  Created by Stephen Wilson on 23/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface STWPictureFrameNode : SKNode


@property (nonatomic, retain) UIImage *image;

+ (STWPictureFrameNode *) pictureFrameNodeWithImage:(UIImage *)image;


@end
