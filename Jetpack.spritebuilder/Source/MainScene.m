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
	CCSprite *_starship;
	CCPhysicsNode *_physicsNode;
	CCNode *_landscape1;
	CCNode *_landscape2;
	NSArray *_landscapes;
}

- (void)didLoadFromCCB {
	_landscapes = @[_landscape1, _landscape2];
}

- (void)update:(CCTime)delta {
	_starship.position = ccp(_starship.position.x + delta * scrollSpeed, _starship.position.y);
	_physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed * delta), _physicsNode.position.y);

	// loop the background
	for (CCNode *landscape in _landscapes) {
		// get the world position of the background
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:landscape.position];
		// get the screen position of the background
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		// if the left corner is one complete width off the screen, move it to the right
		if (groundScreenPosition.x <= (-1 * landscape.contentSize.width)) {
			landscape.position = ccp(landscape.position.x, landscape.position.y);
		}
	}
}

@end
