//
//  Character.m
//  Jetpack
//
//  Created by Christian Perez Biancucci on 10/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Character.h"
#import "CharacterWalkingState.h"
#import "CharacterJumpingState.h"
#import "CharacterRunningState.h"

@implementation Character

-(BOOL) isWalking
{
    return [self getChildByName:@"Walk" recursively:YES].visible;
}

-(BOOL) isJumping
{
    return [self getChildByName:@"Jump" recursively:YES].visible;
}

-(BOOL) isRunning
{
    return [self getChildByName:@"Run" recursively:YES].visible;
}

-(void) startWalking
{
    self.state = [CharacterWalkingState walkingState];
    [self setVisibleState:@"Walk"];
}

-(void) startJumping
{
    self.state = [CharacterJumpingState jumpingState];
    [self setVisibleState:@"Jump"];
    [self.physicsBody applyImpulse:ccp(0, 3500.f)];
}

-(void) startRunning
{
    self.state = [CharacterRunningState runningState];
    [self setVisibleState:@"Run"];
}

-(void) setVisibleState:(NSString * ) name
{
    for(CCSprite * sprite in [self children]){
        if (![sprite.name isEqualToString:name]) {
            sprite.visible = NO;
        } else {
            sprite.visible = YES;
        }
    }
}

@end
