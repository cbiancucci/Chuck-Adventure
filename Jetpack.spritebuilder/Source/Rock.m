//
//  Rock.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Rock.h"

@implementation Rock {
	CCSprite *rock;
}

- (void)didLoadFromCCB {
	rock.physicsBody.collisionType = @"rock";
	rock.physicsBody.sensor = TRUE;
}

- (void)setupPositionX:(CGFloat *)positionX positionY:(CGFloat *)positionY {
//	rock.position = ccp(previousRockXPosition + distanceBetweenRocks, previousRockYPosition);
}

@end
