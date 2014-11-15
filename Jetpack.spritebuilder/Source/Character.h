//
//  Character.h
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "CharacterState.h"

@interface Character : CCNode

@property (nonatomic, strong) CharacterState *state;
@property (nonatomic, assign) BOOL hasAdrenaline;

- (BOOL)isWalking;
- (BOOL)isJumping;
- (BOOL)isRunning;
- (BOOL)isShooting;
- (BOOL)isDead;

- (void)stop;
- (void)startWalking;
- (void)startJumping;
- (void)startRunning;
- (void)startShooting;
- (void)stopShooting;
- (void)die;
- (void)bleed;

- (BOOL)hasAdrenaline;
@end
