//
//  Pause.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Pause.h"

@implementation Pause {
	CCLabelTTF *pauseLabel;
	CCLabelTTF *musicLabel;
	CCLabelTTF *soundEffectsLabel;
}

- (void)didLoadFromCCB {
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
}

@end
