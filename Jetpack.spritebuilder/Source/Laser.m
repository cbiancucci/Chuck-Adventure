//
//  Laser.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Laser.h"

@implementation Laser {
	CCParticleSystem *laserParticle;
}

- (void)didLoadFromCCB {
	laserParticle = (CCParticleSystem *)[self getChildByName:@"LaserParticle" recursively:YES];
	laserParticle.scaleX = 0.25f;
	laserParticle.scaleY = 0.25f;

	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"enemy";
}

@end
