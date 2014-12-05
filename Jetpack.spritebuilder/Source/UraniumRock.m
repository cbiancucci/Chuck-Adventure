//
//  UraniumRock.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "UraniumRock.h"

@implementation UraniumRock

- (void)didLoadFromCCB {
	self.physicsBody.sensor = TRUE;
	self.physicsBody.collisionGroup = @"items";
}

@end
