//
//  CharacterShootingState.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CharacterShootingState.h"

@implementation CharacterShootingState

static CharacterShootingState *shootingState = nil;

+ (CharacterShootingState *)shootingState {
	if (shootingState == nil) {
		shootingState = [CharacterShootingState new];
	}
	return shootingState;
}

- (BOOL)isShooting {
	return YES;
}

@end
