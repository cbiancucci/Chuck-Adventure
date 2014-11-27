//
//  Enemy.h
//  Jetpack
//
//  Created by Christian Perez Biancucci on 11/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Enemy : CCNode

- (BOOL)isDead;

- (void)die;
- (void)stop;
- (void)startShooting;
- (void)stopShooting;
- (BOOL)isShooting;

@end
