//
//  Character.h
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Character.h"
#import "CharacterState.h"

@interface MainCharacter : Character

@property (nonatomic, strong) CharacterState *state;
@property (nonatomic, assign) BOOL hasAdrenaline;

- (BOOL)isWalking;
- (BOOL)isJumping;
- (BOOL)isRunning;
- (BOOL)isShooting;
- (BOOL)isDead;

- (void)startWalking;
- (void)startJumping;
- (void)startRunning;
- (void)startShooting;
- (void)stopShooting;
- (void)startAdrenaline;
- (void)stopAdrenaline;
- (void)die;
- (void)bleed;
- (void)stop;

@end
