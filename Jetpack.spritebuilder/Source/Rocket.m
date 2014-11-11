//
//  Rocket.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Rocket.h"

@implementation Rocket {
	CCSprite *rocket;
	CCSprite *explosion;
}

- (void)didLoadFromCCB {
	rocket = (CCSprite *)[self getChildByName:@"Rocket" recursively:YES];
	rocket.scaleX = 0.25;
	rocket.scaleY = 0.25;
	rocket.physicsBody.sensor = TRUE;
	rocket.physicsBody.collisionType = @"rocket";

	explosion = (CCSprite *)[self getChildByName:@"Explosion" recursively:YES];
}

- (void)setupPositionX:(CGFloat *)positionX positionY:(CGFloat *)positionY {
	//	rock.position = ccp(previousRockXPosition + distanceBetweenRocks, previousRockYPosition);
}

- (void)explode {
	rocket.visible = NO;
	explosion.visible = YES;
}

- (CCSprite *)rocket {
	return rocket;
}

@end
