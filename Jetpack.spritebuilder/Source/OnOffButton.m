//
//  OnOffButton.m
//  Chuck
//
//  Created by Christian Perez Biancucci on 11/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "OnOffButton.h"

@implementation OnOffButton {
	CCNode *on;
	CCNode *off;
}

- (void)didLoadFromCCB {
	on = [self getChildByName:@"OnButton" recursively:YES];
	off = [self getChildByName:@"OffButton" recursively:YES];
}

- (void)turnOn {
	on.visible = YES;
	off.visible = NO;
}

- (void)turnOff {
	off.visible = YES;
	on.visible = NO;
}

- (BOOL)isOn {
	return on.visible;
}

- (CGSize)size {
	if (on.visible) {
		return on.contentSize;
	}
	return off.contentSize;
}

@end
