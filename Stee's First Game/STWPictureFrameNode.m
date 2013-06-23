//
//  STWPictureFrameNode.m
//  Stee's First Game
//
//  Created by Stephen Wilson on 23/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWPictureFrameNode.h"


@interface STWPictureFrameNode ()

@property (nonatomic, retain) SKSpriteNode *frameNode;
@property (nonatomic, retain) SKSpriteNode *imageNode;

@end


@implementation STWPictureFrameNode


- (id) init
{
	self = [super init];
	if (self) {
		[self addChild:self.imageNode];
		[self addChild:self.frameNode];
	}
	return self;
}



+ (STWPictureFrameNode *) pictureFrameNodeWithImage:(UIImage *)image
{
	STWPictureFrameNode *pictureFrameNode = [self node];
	pictureFrameNode.image = image;
	
	return pictureFrameNode;
}



- (SKSpriteNode *) frameNode
{
	if (!_frameNode) {
		_frameNode = [SKSpriteNode spriteNodeWithImageNamed:@"picture_frame"];
	}
	return _frameNode;
}


- (SKSpriteNode *) imageNode
{
	if (!_imageNode) {
		SKTexture *texture = [SKTexture textureWithImage:self.image];
		_imageNode = [SKSpriteNode spriteNodeWithTexture:texture];
		
		_imageNode.size = CGSizeMake(round(0.66 * self.frameNode.size.width),
									 round(0.66 *self.frameNode.size.height));
	}
	return _imageNode;
}



- (void) setImage:(UIImage *)image
{
	if (image == _image) return;
	
	_image = image;
	
	if (self.imageNode.texture) {
		self.imageNode.texture = nil;
	}
	
	if (_image) {
		SKTexture *texture = [SKTexture textureWithImage:self.image];
		self.imageNode.texture = texture;
	}
}


@end
