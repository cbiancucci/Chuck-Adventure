//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Character.h"
#import "Rock.h"

static const CGFloat cameraScrollSpeed = 80.f;
static const CGFloat characterScrollSpeed = 280.f;
static const CGFloat firstRockXPosition = 280.f;
static const CGFloat firstRockYPosition = 100.f;
static const CGFloat distanceBetweenRocks = 50.f;

typedef NS_ENUM (NSInteger, DrawingOrder) {
	DrawingOrderBackground,
	DrawingOrderRock,
	DrawingOrderCharacter,
	DrawingOrderParticles
};

@implementation MainScene {
	//PhysicsNode
	CCPhysicsNode *_physicsNode;

	// Character
	Character *character;

	// Background
	CCNode *_background1;
	CCNode *_background2;
	CCNode *_spike;
	NSArray *_backgrounds;

	// Floor
	CCNode *_floors;

	// Roof
	CCNode *_roof1;
	CCNode *_roof2;
	NSArray *_roofs;

	NSTimeInterval _sinceTouch;
	NSTimeInterval _sinceUranium;
	NSTimeInterval _sinceShoot;

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

	self.userInteractionEnabled = YES;
}

- (void)loadContextInitialSettings {
	_backgrounds = @[_background1, _background2];
	_roofs = @[_roof1, _roof2];
	_spike.physicsBody.sensor = YES;
}

- (void)loadCharacterInitialSettings {
	character = (Character *)[_physicsNode getChildByName:@"Character" recursively:YES];
	character.zOrder = DrawingOrderCharacter;
	character.hasAdrenaline = NO;
	[character stop];
	[character startWalking];
}

- (void)loadRocksInitialSettings {
	_rocks = [NSMutableArray array];
	[self spawnNewRock];
	[self spawnNewRock];
	[self spawnNewRock];
}

- (void)update:(CCTime)delta {
	if ([character hasAdrenaline]) {
		character.position = ccp(character.position.x + delta * characterScrollSpeed, character.position.y);
		_physicsNode.position = ccp(_physicsNode.position.x - (characterScrollSpeed * delta), _physicsNode.position.y);
	}
	else {
		character.position = ccp(character.position.x + delta * cameraScrollSpeed, character.position.y);
		_physicsNode.position = ccp(_physicsNode.position.x - (cameraScrollSpeed * delta), _physicsNode.position.y);
	}

	_sinceUranium += delta;
	_sinceShoot += delta;

	if (_sinceUranium > 2.0f) {
		character.hasAdrenaline = NO;
	}

	if ([character isRunning] && _sinceUranium > 1.0f) {
		[character startWalking];
	}

	if ([character isShooting] && _sinceShoot > 1.0f) {
		[character stopShooting];
	}

	[self loopBackground];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if (touch.locationInWorld.x < 300) {
		if (![character isJumping]) {
			[character startJumping];
		}
	}
	else {
		[character startShooting];
		_sinceShoot = 0.f;
	}
}

- (void)loopBackground {
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

	for (CCNode *floor in _floors.children) {
		CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:floor.position];
		CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
		if (groundScreenPosition.x <= (-1 * floor.contentSize.width)) {
			floor.position = ccp(floor.position.x + 2 * (floor.contentSize.width - 2), floor.position.y);
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
	rock.zOrder = DrawingOrderCharacter;

	[_physicsNode addChild:rock];
	[_rocks addObject:rock];
}

// >>> Collisions

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)characterCollision rock:(Rock *)rock {
	NSLog(@"Character and rock collision");
	rock.visible = NO;
	[rock removeFromParent];
	[_rocks removeObject:rock];

	_sinceUranium = 0.f;
	character.hasAdrenaline = YES;
	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)characterCollision spike:(CCNode *)spike {
	NSLog(@"Character and spike collision");
	CCParticleSystem *blood = (CCParticleSystem *)[CCBReader load:@"Blood"];
	blood.autoRemoveOnFinish = YES;
	blood.position = character.position;
	blood.zOrder = DrawingOrderParticles;
	[character.parent addChild:blood];

//    explosion.position = seal.position;
	// add the particle effect to the same node the seal is on [seal.parent addChild:explosion]; // finally, remove the destroyed seal [seal removeFromParent];
	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(Character *)characterCollision floor:(CCNode *)floor {
	NSLog(@"Character and floor collision");
	if ([character isJumping]) {
		[character startWalking];
	}
	return YES;
}

@end
