//
//  Cannonball.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 12/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Cannonball.h"

@implementation Cannonball

- (void)didLoadFromCCB {
	self.physicsBody.sensor = YES;
	self.physicsBody.collisionGroup = @"enemy";
}

@end
