//
//  Pause.h
//  Chuck
//
//  Created by Christian Perez Biancucci on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Pause : CCNode

@property BOOL music;
@property BOOL soundEffects;

- (void)touchMusic;
- (void)touchSoundEffect;

- (BOOL)isMusicOn;
- (BOOL)isSoundEffectsOn;

@end
