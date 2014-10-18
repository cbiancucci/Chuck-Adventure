//
//  CharacterRunningState.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CharacterRunningState.h"

@implementation CharacterRunningState

static CharacterRunningState *runningState = nil;

+ (CharacterRunningState *)runningState
{
    if (runningState == nil) {
        runningState = [CharacterRunningState new];
    }
    return runningState;
}

- (BOOL) isRunning
{
    return YES;
}

@end
