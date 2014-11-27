//
//  Pause.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Pause.h"
#import "OnOffButton.h"

@implementation Pause {
	CCLabelTTF *pauseLabel;
	CCLabelTTF *musicLabel;
	CCLabelTTF *soundEffectsLabel;

	OnOffButton *musicButton;
	OnOffButton *soundEffectsButton;
}

- (void)didLoadFromCCB {
	self.music = YES;
	self.soundEffects = YES;


	pauseLabel = [CCLabelTTF labelWithString:@"PAUSE" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:13];
	pauseLabel.outlineColor = [CCColor blackColor];
	pauseLabel.outlineWidth = 2.0f;
	[self addChild:pauseLabel];
	[pauseLabel setPosition:ccp(0, 56)];


	musicLabel = [CCLabelTTF labelWithString:@"Music" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:13];
	musicLabel.outlineColor = [CCColor blackColor];
	musicLabel.outlineWidth = 2.0f;
	[self addChild:musicLabel];
	[musicLabel setPosition:ccp(-79, 25)];


	soundEffectsLabel = [CCLabelTTF labelWithString:@"Sound effects" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:13];
	soundEffectsLabel.outlineColor = [CCColor blackColor];
	soundEffectsLabel.outlineWidth = 2.0f;
	[self addChild:soundEffectsLabel];
	[soundEffectsLabel setPosition:ccp(-55, 1)];

	musicButton = (OnOffButton *)[CCBReader load:@"OnOffButton"];
	if ([self isMusicOn]) {
		[musicButton turnOn];
	}
	else {
		[musicButton turnOff];
	}
	[self addChild:musicButton];
	[musicButton setPosition:ccp(85, 24)];


	soundEffectsButton = (OnOffButton *)[CCBReader load:@"OnOffButton"];
	if ([self isSoundEffectsOn]) {
		[soundEffectsButton turnOn];
	}
	else {
		[soundEffectsButton turnOff];
	}
	[self addChild:soundEffectsButton];
	[soundEffectsButton setPosition:ccp(85, -1)];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	NSLog(@"Llegue aca");
	CGPoint p = [touch locationInView:[touch view]];

	// TODO
	if ([self musicIsTouched:p]) {
		NSLog(@"Music button was touched");
	}

	if ([self soundEffectIsTouched:p]) {
	}
	/*
	   //Music button
	   if ([self musicIsTouched:initialTouchLocation]) {
	   [pauseDialog touchMusic];
	   if (![pauseDialog isMusicOn]) {
	   [audio stopBg];
	   }
	   else {
	   [audio playEffect:@"Level.mp3"];
	   }
	   }

	   // Sound effects button
	   else if ([self soundEffectIsTouched:initialTouchLocation]) {
	   [pauseDialog touchSoundEffect];
	   }
	 */
}

- (bool)musicIsTouched:(CGPoint)touchLocation {
	CGPoint r = [self convertToWorldSpace:musicButton.position];

	CGRect musicButtonArea = CGRectMake(r.x - [musicButton size].width / 2, r.y - [musicButton size].height / 2, [musicButton size].width, [musicButton size].height);

	return CGRectContainsPoint(musicButtonArea, [self convertToNodeSpace:touchLocation]);
}

- (bool)soundEffectIsTouched:(CGPoint)touchLocation {
	NSLog(@"x: %f, y:%f", touchLocation.x, touchLocation.y);
	if ((touchLocation.x >= 355 && touchLocation.x <= 383) && (touchLocation.y >= 154 && touchLocation.y <= 170)) {
		return YES;
	}
	return NO;
}

- (void)touchMusic {
	if ([self isMusicOn]) {
		[self turnOffMusic];
	}
	else {
		[self turnOnMusic];
	}
}

- (void)touchSoundEffect {
	if ([self isSoundEffectsOn]) {
		[self turnOffSoundEffects];
	}
	else {
		[self turnOnSoundEffects];
	}
}

- (BOOL)isMusicOn {
	return self.music;
}

- (BOOL)isSoundEffectsOn {
	return self.soundEffects;
}

- (void)turnOnMusic {
	self.music = YES;
	[musicButton turnOn];
}

- (void)turnOffMusic {
	self.music = NO;
	[musicButton turnOff];
}

- (void)turnOnSoundEffects {
	self.soundEffects = YES;
	[soundEffectsButton turnOn];
}

- (void)turnOffSoundEffects {
	self.soundEffects = NO;
	[soundEffectsButton turnOff];
}

- (CGSize)size {
	return [self getChildByName:@"PauseBackground" recursively:YES].contentSize;
}

@end
