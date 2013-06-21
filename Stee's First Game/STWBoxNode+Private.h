//
//  STWBoxNode+Private.h
//  Stee's First Game
//
//  Created by Stephen Wilson on 21/06/2013.
//  Copyright (c) 2013 Stephen Wilson. All rights reserved.
//

#import "STWBoxNode.h"


typedef enum {
	STWBoxNodeDestuctTypeDefault,
	STWBoxNodeDestuctTypeFire
}STWBoxNodeDestuctType;


@interface STWBoxNode (Private)


@property (nonatomic, retain) NSString *imageName;
@property (nonatomic) STWBoxNodeDestuctType destructType;


@end
