//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Rock.h"

static const CGFloat scrollSpeed = 80.f;
static const CGFloat firstRockXPosition = 280.f;
static const CGFloat firstRockYPosition = 100.f;
static const CGFloat distanceBetweenRocks = 50.f;

typedef NS_ENUM (NSInteger, DrawingOrder) {
	DrawingOrderBackground,
	DrawingOrderRock,
	DrawingOrderCharacter
};

@implementation MainScene {
	//PhysicsNode
	CCPhysicsNode *_physicsNode;

	// Character
//	CCSprite *_character;
	CCSprite *_characterWalk;
//	CCSprite *_characterJump;

	// Background
	CCNode *_background1;
	CCNode *_background2;
	NSArray *_backgrounds;

	// Floor
	CCNode *_floor1;
	CCNode *_floor2;
	NSArray *_floors;

	// Roof
	CCNode *_roof1;
	CCNode *_roof2;
	NSArray *_roofs;

	NSTimeInterval _sinceTouch;

	NSMutableArray *_rocks;
}

- (void)didLoadFromCCB {
	// set this class as delegate
	_physicsNode.collisionDelegate = self;

	// Context
	[self loadContextInitialSettings];

	// Uranium Rocks
	//[self loadRocksInitialSettings];

	// Character
	[self loadCharacterInitialSettings];

	self.userInteractionEnabled = TRUE;
}

- (void)loadContextInitialSettings {
	_backgrounds = @[_background1, _background2];
	_floors = @[_floor1, _floor2];
	_roofs = @[_roof1, _roof2];
}

- (void)loadCharacterInitialSettings {
	_character.physicsBody.collisionType = @"character";
	_character.zOrder = DrawingOrderCharacter;
	_character = _characterWalk;

	_characterJump.visible = false;
	[_characterJump removeFromParent];
	[_character addChild:_characterJump];
}

- (void)loadRocksInitialSettings {
	_rocks = [NSMutableArray array];
	[self spawnNewRock];
	[self spawnNewRock];
	[self spawnNewRock];
}

- (void)update:(CCTime)delta {
	_character.position = ccp(_character.position.x + delta * scrollSpeed, _character.position.y);
	_physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed * delta), _physicsNode.position.y);

	_sinceTouch += delta;

	if (_sinceTouch > 0.5f) {
//		_characterWalk.position = _character.position;
		_characterJump.visible = NO;
		_characterWalk.visible = YES;
		_character = _characterWalk;
	}

	// loop the background
	for (CCNode *background in _backgrounds) {
		// get the world position of the background
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:background.position];
		// get the screen position of the background
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		// if the left corner is one complete width off the screen, move it to the right
		if (groundScreenPosition.x <= (-1 * background.contentSize.width)) {
			background.position = ccp(background.position.x + 2 * background.contentSize.width, background.position.y);
			background.zOrder = DrawingOrderBackground;
		}
	}

	for (CCNode *floor in _floors) {
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:floor.position];
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		if (groundScreenPosition.x <= (-1 * floor.contentSize.width)) {
			floor.position = ccp(floor.position.x + 2 * (floor.contentSize.width - 1), floor.position.y);
			floor.zOrder = DrawingOrderBackground;
		}
	}

	for (CCNode *roof in _roofs) {
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:roof.position];
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		if (groundScreenPosition.x <= (-1 * roof.contentSize.width)) {
			roof.position = ccp(roof.position.x + 2 * roof.contentSize.width, roof.position.y);
			roof.zOrder = DrawingOrderBackground;
		}
	}

	NSMutableArray *rocksToBeRemoved = nil;
	for (CCNode *rock in _rocks) {
		// Generar una mejor comparación para que detecte si la agarró o no
		/*if (
		    ((rock.position.y >= _character.position.y) && (rock.position.y + rock.contentSize.height <= _character.position.y + _character.contentSize.height)) && ((rock.position.x >= _character.position.x + _character.contentSize.width) && (rock.position.x + rock.contentSize.width <= _character.position.x + _character.contentSize.width))
		    ) {
		    if (!rocksToBeRemoved) {
		        rocksToBeRemoved = [NSMutableArray array];
		    }
		    [rocksToBeRemoved addObject:rock];
		   }*/

		if (rock.position.x >= _character.position.x >= rock.position.x) {
			[[CCDirector sharedDirector] pause];
			if (!rocksToBeRemoved) {
				rocksToBeRemoved = [NSMutableArray array];
			}
			[rocksToBeRemoved addObject:rock];
		}
	}

	for (CCNode *rockToBeRemoved in rocksToBeRemoved) {
		[rockToBeRemoved removeFromParent];
		[_rocks removeObject:rocksToBeRemoved];
		//[self spawnNewRock];
	}
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//	_characterJump.position = _character.position;
	_characterWalk.visible = NO;
	_characterJump.visible = YES;
	_character = _characterJump;

	[_character.physicsBody applyImpulse:ccp(0, 4000.f)];
	_sinceTouch = 0.f;
}

- (void)spawnNewRock {
	CCNode *previousRock = [_rocks lastObject];
	CGFloat previousRockXPosition = previousRock.position.x;
	CGFloat previousRockYPosition = previousRock.position.y;

	if (!previousRock) {
		// this is the first obstacle
		previousRockXPosition = firstRockXPosition;
		previousRockYPosition = firstRockYPosition;
	}

	Rock *rock = (Rock *)[CCBReader load:@"Uranium"];
//	[rock setupPositionX:(previousRockYPosition + distanceBetweenRocks) positionY:previousRockYPosition];
	rock.position = ccp(previousRockXPosition + distanceBetweenRocks, previousRockYPosition);
	rock.zOrder = DrawingOrderRock;

	[_physicsNode addChild:rock];
	[_rocks addObject:rock];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(CCSprite *)character rock:(CCNode *)rock {
	NSLog(@"Uranium");
	return TRUE;
}

@end
