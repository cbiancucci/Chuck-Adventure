//
//  LifeSupply.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 12/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LifeSupply.h"

@implementation LifeSupply

- (void)didLoadFromCCB {
	self.scaleX = 0.5f;
	self.scaleY = 0.5f;

	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"items";
}

@end
