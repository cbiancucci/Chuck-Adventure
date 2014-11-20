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
	self.physicsBody.collisionGroup = @"difficulties";
	defeated = NO;
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

@end
