//
//  Rocket.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Rocket.h"

@implementation Rocket {
	CCSprite *rocketSprite;
}

- (void)didLoadFromCCB {
	rocketSprite = (CCSprite *)[self getChildByName:@"Rocket" recursively:YES];
	rocketSprite.scaleX = 0.25;
	rocketSprite.scaleY = 0.25;

	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"enemy";
}

@end
