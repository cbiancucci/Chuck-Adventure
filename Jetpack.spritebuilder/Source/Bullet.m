//
//  Bullet.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet {
	CCSprite *fire;
	CCSprite *cannonball;
	CCSprite *dart;
}


- (void)didLoadFromCCB {
	fire = (CCSprite *)[self getChildByName:@"Fire" recursively:YES];
	fire.visible = NO;

	cannonball = (CCSprite *)[self getChildByName:@"Cannonball" recursively:YES];
	cannonball.visible = NO;

	dart = (CCSprite *)[self getChildByName:@"Dart" recursively:YES];
	dart.visible = YES;

	self.physicsBody.collisionGroup = @"character";
}

@end
