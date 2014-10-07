//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
static const CGFloat scrollSpeed = 80.f;
@implementation MainScene {
	CCSprite *_character;
	CCPhysicsNode *_physicsNode;
	CCNode *_background1;
	CCNode *_background2;
	NSArray *_backgrounds;
	CCNode *_floor1;
	CCNode *_floor2;
	NSArray *_floors;
	CCNode *_roof1;
	CCNode *_roof2;
	NSArray *_roofs;
}

- (void)didLoadFromCCB {
	_backgrounds = @[_background1, _background2];
	_floors = @[_floor1, _floor2];
	_roofs = @[_roof1, _roof2];

	self.userInteractionEnabled = TRUE;
}

- (void)update:(CCTime)delta {
	_character.position = ccp(_character.position.x + delta * scrollSpeed, _character.position.y);
	_physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed * delta), _physicsNode.position.y);

	// loop the background
	for (CCNode *background in _backgrounds) {
		// get the world position of the background
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:background.position];
		// get the screen position of the background
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		// if the left corner is one complete width off the screen, move it to the right
		if (groundScreenPosition.x <= (-1 * background.contentSize.width)) {
			background.position = ccp(background.position.x + 2 * background.contentSize.width, background.position.y);
		}
	}

	for (CCNode *floor in _floors) {
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:floor.position];
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		if (groundScreenPosition.x <= (-1 * floor.contentSize.width)) {
			floor.position = ccp(floor.position.x + 2 * (floor.contentSize.width - 1), floor.position.y);
		}
	}

	for (CCNode *roof in _roofs) {
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:roof.position];
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		if (groundScreenPosition.x <= (-1 * roof.contentSize.width)) {
			roof.position = ccp(roof.position.x + 2 * roof.contentSize.width, roof.position.y);
		}
	}
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	[_character.physicsBody applyImpulse:ccp(0, 7000.f)];
}

@end
