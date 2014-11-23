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
	[audio stopAllEffects];
	[[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
}

@end
