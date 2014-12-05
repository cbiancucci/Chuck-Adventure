//
//  Spike.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 12/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Spike.h"

@implementation Spike

- (void)didLoadFromCCB {
	self.scaleX = 0.4;
	self.scaleY = 0.4;

	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"enemy";
}

@end
