//
//  Gun.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 12/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gun.h"

@implementation Gun {
	BOOL destroyed;
	CCParticleSystem *smoke;
}

- (void)didLoadFromCCB {
	self.scaleX = 0.5;
	self.scaleY = 0.5;

	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"enemy";

	destroyed = false;

	smoke = (CCParticleSystem *)[self getChildByName:@"Smoke" recursively:YES];
	smoke.visible = false;
}

- (BOOL)isBroken {
	return destroyed;
}

- (void)destroy {
	smoke.visible = true;
	destroyed = true;
}

@end
