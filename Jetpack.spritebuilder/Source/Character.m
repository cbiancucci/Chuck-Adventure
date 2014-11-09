//
//  Character.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Character.h"
#import "CharacterWalkingState.h"
#import "CharacterJumpingState.h"
#import "CharacterRunningState.h"
#import "CharacterShootingState.h"

@implementation Character

- (BOOL)isWalking {
	return [self getChildByName:@"Walk" recursively:YES].visible || [self getChildByName:@"ShootWalking" recursively:YES].visible;
}

- (BOOL)isJumping {
	return [self getChildByName:@"Jump" recursively:YES].visible  || [self getChildByName:@"ShootJumping" recursively:YES].visible;
}

- (BOOL)isRunning {
	return [self getChildByName:@"Run" recursively:YES].visible  || [self getChildByName:@"ShootRunning" recursively:YES].visible;
}

- (BOOL)isShooting {
	return [self getChildByName:@"ShootWalking" recursively:YES].visible || [self getChildByName:@"ShootJumping" recursively:YES].visible || [self getChildByName:@"ShootRunning" recursively:YES].visible;
}

- (void)stop {
	for (CCNode *child in self.children) {
		child.visible = NO;
	}
}

- (void)startWalking {
	self.state = [CharacterWalkingState walkingState];
	if ([self isShooting]) {
		[self setVisibleState:@"ShootWalking"];
	}
	else {
		[self setVisibleState:@"Walk"];
	}
}

- (void)startJumping {
	self.state = [CharacterJumpingState jumpingState];
	if (![self isShooting]) {
		[self setVisibleState:@"Jump"];
	}
	else {
		[self setVisibleState:@"ShootJumping"];
	}
	[self.physicsBody applyImpulse:ccp(200.f, 2500.f)];
}

- (void)startRunning {
	self.state = [CharacterRunningState runningState];
	[self setVisibleState:@"Run"];
}

- (void)startShooting {
	self.state = [CharacterShootingState shootingState];

	if ([self isWalking]) {
		[self setVisibleState:@"ShootWalking"];
	}
	else if ([self isJumping]) {
		[self setVisibleState:@"ShootJumping"];
	}
	else if ([self isRunning]) {
		[self setVisibleState:@"ShootRunning"];
	}
}

- (void)stopShooting {
	if ([self isWalking]) {
		[self setVisibleState:@"Walk"];
	}
	else if ([self isJumping]) {
		[self setVisibleState:@"Jump"];
	}
	else if ([self isRunning]) {
		[self setVisibleState:@"Run"];
	}
}

- (void)setVisibleState:(NSString *)name {
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
