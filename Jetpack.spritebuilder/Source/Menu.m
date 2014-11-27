//
//  Menu.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 11/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Menu.h"

@implementation Menu {
	CCLabelTTF *startGameText;
	CCLabelTTF *optionsText;
	CCLabelTTF *aboutText;
	OALSimpleAudio *audio;
}


- (void)didLoadFromCCB {
	self.userInteractionEnabled = YES;

	CGSize size  = [[CCDirector sharedDirector] viewSize];

	startGameText = [CCLabelTTF labelWithString:@"Start Game" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:40];
	startGameText.outlineColor = [CCColor blackColor];
	startGameText.outlineWidth = 2.0f;
	[startGameText setPosition:ccp(size.width / 2, size.height / 2 + 20)];
	[self addChild:startGameText];

	optionsText = [CCLabelTTF labelWithString:@"Options" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:30];
	optionsText.outlineColor = [CCColor blackColor];
	optionsText.outlineWidth = 2.0f;
	[optionsText setPosition:ccp(size.width / 2, size.height / 2 - 30)];
	[self addChild:optionsText];

	aboutText = [CCLabelTTF labelWithString:@"About" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:20];
	aboutText.outlineColor = [CCColor blackColor];
	aboutText.outlineWidth = 2.0f;
	[aboutText setPosition:ccp(size.width / 2, size.height / 2 - 70)];
	[self addChild:aboutText];

	audio = [OALSimpleAudio sharedInstance];
	[audio playBg:@"Menu.mp3" loop:YES];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchPosition = [touch locationInView:[touch view]];

	if ([self startGameIsPressed:touchPosition]) {
		[audio stopAllEffects];
		[[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
	}
	else if ([self optionIsPressed:touchPosition]) {
	}
	else if ([self aboutIsPressed:touchPosition]) {
	}
}

- (BOOL)startGameIsPressed:(CGPoint)touch {
	float left = startGameText.position.x - startGameText.contentSize.width / 2;
	float right = startGameText.position.x + startGameText.contentSize.width / 2;

	float down = (startGameText.position.y - startGameText.contentSize.height / 2) - 20;
	float up = (startGameText.position.y + startGameText.contentSize.height / 2) - 20;

	if (touch.x >= left && touch.x <= right && touch.y >= down && touch.y <= up) {
		return YES;
	}
	return NO;
}

- (BOOL)optionIsPressed:(CGPoint)touch {
	return NO;
}

- (BOOL)aboutIsPressed:(CGPoint)touch {
	return NO;
}

@end
