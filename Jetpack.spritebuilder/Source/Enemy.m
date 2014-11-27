//
//  Enemy.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy {
	BOOL defeated;
}

- (void)didLoadFromCCB {
	self.physicsBody.collisionGroup = @"enemy";
	self.scaleX = 0.75;
	self.scaleY = 0.75;
	self.physicsBody.sensor = YES;

	[self setVisibleState:@"Walk"];
	defeated = NO;
}

- (BOOL)isDead {
	return defeated;
}

- (void)startShooting {
	[self setVisibleState:@"ShootWalking"];
}

- (void)stopShooting {
	[self setVisibleState:@"Walk"];
}

- (BOOL)isShooting {
	return [self getChildByName:@"ShootWalking" recursively:YES].visible;
}

- (void)stop {
	for (CCNode *child in self.children) {
		child.visible = NO;
	}
}

- (void)die {
	[self stop];
	defeated = YES;
}

- (void)setVisibleState:(NSString *)name {
	[self getChildByName:name recursively:YES].visible = YES;

	for (CCSprite *sprite in[self children]) {
		if (![sprite.name isEqualToString:name]) {
			sprite.visible = NO;
		}
		else {
			sprite.visible = YES;
		}
	}
}

@end
