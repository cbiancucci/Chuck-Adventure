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
	return [self getChildByName:@"Walk" recursively:YES].visible;
}

- (BOOL)isJumping {
	return [self getChildByName:@"Jump" recursively:YES].visible;
}

- (BOOL)isRunning {
	return [self getChildByName:@"Run" recursively:YES].visible;
}

- (BOOL)isShooting {
	return [self getChildByName:@"ShootWalking" recursively:YES].visible || [self getChildByName:@"ShootJumping" recursively:YES].visible || [self getChildByName:@"ShootRunning" recursively:YES].visible;
}

- (void)startWalking {
	self.state = [CharacterWalkingState walkingState];
	[self setVisibleState:@"Walk"];
}

- (void)startJumping {
	self.state = [CharacterJumpingState jumpingState];
	if (![self isShooting]) {
		[self setVisibleState:@"Jump"];
	}
	else {
		[self setVisibleState:@"ShootJumping"];
	}
	[self.physicsBody applyImpulse:ccp(0, 3000.f)];
}

- (void)startRunning {
	self.state = [CharacterRunningState runningState];
	[self setVisibleState:@"Run"];
}

- (void)startShooting {
	self.state = [CharacterShootingState shootingState];

	if ([self isWalking]) {
		[self getChildByName:@"Walk" recursively:YES];
		[self setVisibleState:@"ShootWalking"];
	}
	else if ([self isJumping]) {
		[self getChildByName:@"Jump" recursively:YES];
		[self setVisibleState:@"ShootJumping"];
	}
	else if ([self isRunning]) {
		[self getChildByName:@"Run" recursively:YES];
		[self setVisibleState:@"ShootRunning"];
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
