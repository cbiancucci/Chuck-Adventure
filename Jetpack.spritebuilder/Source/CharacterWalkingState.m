//
//  CharacterWalkingState.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CharacterWalkingState.h"

@implementation CharacterWalkingState

static CharacterWalkingState *walkingState = nil;

+ (CharacterWalkingState *)walkingState
{
    if (walkingState == nil) {
        walkingState = [CharacterWalkingState new];
    }
    return walkingState;
}

-(BOOL)isWalking
{
    return YES;
}

@end
