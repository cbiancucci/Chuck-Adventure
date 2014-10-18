//
//  CharacterJumpingState.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CharacterJumpingState.h"

@implementation CharacterJumpingState

static CharacterJumpingState *jumpingState = nil;

+ (CharacterJumpingState *)jumpingState
{
    if (jumpingState == nil) {
        jumpingState = [CharacterJumpingState new];
    }
    return jumpingState;
}

-(BOOL) isJumping
{
    return YES;
}

@end
