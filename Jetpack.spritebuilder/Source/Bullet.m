//
//  Bullet.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet {
	CCSprite *dart;
}


- (void)didLoadFromCCB {
	dart = (CCSprite *)[self getChildByName:@"Dart" recursively:YES];
	dart.visible = YES;

	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"character";
}

@end
