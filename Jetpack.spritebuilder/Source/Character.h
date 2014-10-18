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

@property (nonatomic, strong) CharacterState * state;
@property (nonatomic, assign) Boolean * hasAdrenaline;

-(BOOL) isWalking;
-(BOOL) isJumping;
-(BOOL) isRunning;

-(void) startWalking;
-(void) startJumping;
-(void) startRunning;

-(BOOL) hasAdrenaline;
@end
