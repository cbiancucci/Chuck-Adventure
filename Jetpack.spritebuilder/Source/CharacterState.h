//
//  State.h
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface CharacterState : CCNode

-(BOOL) isWalking;
-(BOOL) isRunning;
-(BOOL) isJumping;

@end
