//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "MainCharacter.h"
#import "Rock.h"
#import "Rocket.h"
#import "Bullet.h"
#import "Explosion.h"
#import "Enemy.h"
#import "Laser.h"

static const CGFloat cameraScrollSpeed = 80.f;
static const CGFloat characterScrollSpeed = 280.f;
static const CGFloat firstRockXPosition = 280.f;
static const CGFloat firstRockYPosition = 100.f;
static const CGFloat distanceBetweenRocks = 50.f;

typedef NS_ENUM (NSInteger, DrawingOrder) {
	DrawingOrderBackground,
	DrawingOrderRock,
	DrawingOrderEnemy,
	DrawingOrderCharacter,
	DrawingOrderBullet,
	DrawingOrderDifficulties,
	DrawingOrderParticles,
	DrawingOrderText
};

@implementation MainScene {
	double distance;

	CGSize size;

	//PhysicsNode
	CCPhysicsNode *_physicsNode;

	// Character
	MainCharacter *mainCharacter;

	// Texts
	CCLabelTTF *distanceText;
	CCLabelTTF *pauseText;
	CCLabelTTF *gamePausedText;
	CCLabelTTF *gameOverText;
	CCLabelTTF *retryText;

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
	NSTimeInterval _sinceBullet;

	// Rocks
	NSMutableArray *_rocks;

	// Weapons
	NSMutableArray *bullets;

	// Difficulties
	Rocket *rocket;
	Enemy *enemy;
	NSMutableArray *lasers;
	Laser *laser;

	// Audio
	OALSimpleAudio *audio;
}

- (void)didLoadFromCCB {
	size  = [[CCDirector sharedDirector] viewSize];

	// set this class as delegate
	_physicsNode.collisionDelegate = self;

	// Texts
	[self loadTextSettings];

	// Context
	[self loadContextInitialSettings];

	// Uranium Rocks
//	[self loadRocksInitialSettings];

	// Character
	[self loadCharacterInitialSettings];

	// Difficulties
	[self loadDifficultiesSettings];

	// Music
	[self loadMusicSettings];

	self.userInteractionEnabled = YES;

	//_physicsNode.debugDraw = YES;
}

- (void)loadTextSettings {
	distanceText = [CCLabelTTF labelWithString:@"000" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:20];
	distanceText.outlineColor = [CCColor blackColor];
	distanceText.outlineWidth = 2.0f;
	distanceText.zOrder = DrawingOrderText;
	[distanceText setPosition:ccp(40.f, 300.f)];
	[self addChild:distanceText];

	pauseText = [CCLabelTTF labelWithString:@"I I" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:20];
	pauseText.outlineColor = [CCColor blackColor];
	pauseText.outlineWidth = 2.0f;
	pauseText.zOrder = DrawingOrderText;
	[pauseText setPosition:ccp(size.width - 30, 300.f)];
	[self addChild:pauseText];

	gamePausedText = [CCLabelTTF labelWithString:@"PAUSE" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:40];
	gamePausedText.outlineColor = [CCColor blackColor];
	gamePausedText.outlineWidth = 2.0f;
	gamePausedText.zOrder = DrawingOrderText;
	[gamePausedText setPosition:ccp(size.width / 2, size.height / 2)];
	[self addChild:gamePausedText];
	gamePausedText.visible = NO;

	gameOverText = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:40];
	gameOverText.outlineColor = [CCColor blackColor];
	gameOverText.outlineWidth = 2.0f;
	gameOverText.zOrder = DrawingOrderText;
	[gameOverText setPosition:ccp(size.width / 2, size.height / 2)];
	[self addChild:gameOverText];
	gameOverText.visible = NO;

	retryText = [CCLabelTTF labelWithString:@"Tap the screen to play again" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:20];
	retryText.outlineColor = [CCColor blackColor];
	retryText.outlineWidth = 2.0f;
	retryText.zOrder = DrawingOrderText;
	[retryText setPosition:ccp(size.width / 2, (size.height / 2) - 50)];
	[self addChild:retryText];
	retryText.visible = NO;
}

- (void)loadContextInitialSettings {
	distance = 0;
	_backgrounds = @[_background1, _background2];
	_roofs = @[_roof1, _roof2];
	_spike.physicsBody.sensor = YES;
}

- (void)loadCharacterInitialSettings {
	mainCharacter = (MainCharacter *)[_physicsNode getChildByName:@"MainCharacter" recursively:YES];
	mainCharacter.zOrder = DrawingOrderCharacter;
	mainCharacter.hasAdrenaline = NO;
	[mainCharacter stop];
	[mainCharacter startWalking];
}

- (void)loadRocksInitialSettings {
	_rocks = [NSMutableArray array];
	[self spawnNewRock];
	[self spawnNewRock];
	[self spawnNewRock];
}

- (void)loadDifficultiesSettings {
	[self createRocket];
	[self createEnemy];
}

- (void)loadMusicSettings {
	audio = [OALSimpleAudio sharedInstance];
	[audio playEffect:@"Level.mp3"];
}

- (void)update:(CCTime)delta {
	if (![mainCharacter isDead]) {
		// Update rocket position.
		if (rocket) {
			rocket.physicsBody.velocity = CGPointMake(-200, 0);

			CGPoint rocketWorldPosition = [_physicsNode convertToWorldSpace:rocket.position];

			if (rocketWorldPosition.x < -200) {
				[rocket removeFromParentAndCleanup:YES];
				[self createRocket];
			}
		}

		if (enemy) {
			enemy.physicsBody.velocity = CGPointMake(-50, 0);

			CGPoint enemyWorldPosition = [_physicsNode convertToWorldSpace:enemy.position];

			if (enemyWorldPosition.x < -200) {
				[enemy removeFromParentAndCleanup:YES];
				[self createEnemy];
			}

			if (![enemy isDead] && enemy.position.x - mainCharacter.position.x < 400 && laser == nil) {
				[self createLaser];
				[enemy startShooting];
			}
		}

		// Update and destroy off screen bullets.
		if (bullets && [bullets count] > 0) {
			[self updateBullets];
		}

		// Update and destroy off screen lasers.
/*		if (lasers && [lasers count] > 0) {
            [self updateLasers];
        }
 */

		// Update character position.
		if ([mainCharacter hasAdrenaline]) {
			mainCharacter.position = ccp(mainCharacter.position.x + delta * characterScrollSpeed, mainCharacter.position.y);
			_physicsNode.position = ccp(_physicsNode.position.x - (characterScrollSpeed * delta), _physicsNode.position.y);

			distance += 0.5f;
		}
		else {
			mainCharacter.position = ccp(mainCharacter.position.x + delta * cameraScrollSpeed, mainCharacter.position.y);
			_physicsNode.position = ccp(_physicsNode.position.x - (cameraScrollSpeed * delta), _physicsNode.position.y);

			distance += 0.1f;
		}

		// Update character state.
		_sinceBullet += delta;
		if ([mainCharacter isShooting] && _sinceBullet > 0.4f) {
			_sinceBullet = 0;
			[self createBullet];
		}

		_sinceUranium += delta;
		if (_sinceUranium > 2.0f) {
			mainCharacter.hasAdrenaline = NO;
		}

		if ([mainCharacter isRunning] && ![mainCharacter hasAdrenaline]) {
			[mainCharacter startWalking];
		}

		_sinceShoot  += delta;
		if ([mainCharacter isShooting] && _sinceShoot > 1.0f) {
			[mainCharacter stopShooting];
		}

		// Update distance text.
		[distanceText setString:[NSString stringWithFormat:@"%03d%@", (int)distance, @"M"]];

		[self loopBackground];
	}
	else {
		gameOverText.visible = YES;
		retryText.visible = YES;
	}
}

- (void)updateBullets {
	NSMutableArray *removeBullets = [[NSMutableArray alloc] init];
	for (Bullet *bullet in bullets) {
		bullet.physicsBody.velocity = CGPointMake(800, 0);

		CGPoint bulletWorldPosition = [_physicsNode convertToWorldSpace:bullet.position];
		if (bulletWorldPosition.x > size.width) {
			[removeBullets addObject:bullet];
		}
	}

	if ([removeBullets count] > 0) {
		[self destroyBullets:removeBullets];
	}
}

/*
   - (void)updateLasers {
    NSMutableArray *removeLasers = [[NSMutableArray alloc] init];
    for (Laser *laser in lasers) {
        laser.physicsBody.velocity = CGPointMake(-250, 0);

        CGPoint laserWorldPosition = [_physicsNode convertToWorldSpace:laser.position];
        if (laserWorldPosition.x < -200) {
            [removeLasers addObject:laser];
        }
    }

    if ([removeLasers count] > 0) {
        [self destroyBullets:removeLasers];
    }
   }*/

- (void)destroyBullets:(NSMutableArray *)removeBullets {
	for (Bullet *bullet in removeBullets) {
		[bullet removeFromParentAndCleanup:YES];
		[bullets removeObject:bullet];
	}
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchLocation = [touch locationInView:[touch view]];
	if (![mainCharacter isDead]) {
		if ([self pauseIsTouched:touchLocation]) {
			if ([CCDirector sharedDirector].isPaused) {
				gamePausedText.visible = NO;
				[[CCDirector sharedDirector] resume];
			}
			else {
				[[CCDirector sharedDirector] pause];
				gamePausedText.visible = YES;
			}
		}
		else if (![CCDirector sharedDirector].isPaused) {
			if (touchLocation.x < 300) {
				if (![mainCharacter isJumping]) {
					[mainCharacter startJumping];
				}
			}
			else {
				[mainCharacter startShooting];
				_sinceShoot = 0.f;
				_sinceBullet = 0.f;
				[self createBullet];
			}
		}
	}
	else { // Retry
		[audio stopAllEffects];
		[[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
	}
}

- (bool)pauseIsTouched:(CGPoint)touchLocation {
	NSLog(@"x: %f, y:%f", touchLocation.x, touchLocation.y);
	if ((touchLocation.x > size.width - 45) && (touchLocation.x < size.width - 10) && (touchLocation.y > 5 && touchLocation.y < 35)) {
		return YES;
	}

	return NO;
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
	rock.position = ccp(previousRockXPosition + distanceBetweenRocks, previousRockYPosition);
	rock.zOrder = DrawingOrderCharacter;

	[_physicsNode addChild:rock];
	[_rocks addObject:rock];
}

- (void)createBullet {
	if (!bullets) {
		bullets = [[NSMutableArray alloc] init];
	}

	Bullet *bullet = (Bullet *)[CCBReader load:@"Bullet"];
	[bullet setPosition:ccp(mainCharacter.position.x + 30, mainCharacter.position.y - 8)];
	bullet.zOrder = DrawingOrderBullet;
	[_physicsNode addChild:bullet];
	[bullets addObject:bullet];
}

- (void)createLaser {
/*	if (!lasers) {
        lasers = [[NSMutableArray alloc] init];
    }
 */
	laser = (Laser *)[CCBReader load:@"Laser"];
	laser.zOrder = DrawingOrderDifficulties;
	[_physicsNode addChild:laser];
	laser.position = ccp(enemy.position.x - 15, enemy.position.y + 10);
	laser.physicsBody.velocity = CGPointMake(-200, 0);
}

- (void)createEnemy {
	enemy = (Enemy *)[CCBReader load:@"Enemy"];
	enemy.zOrder = DrawingOrderEnemy;
	[enemy setPosition:ccp(mainCharacter.position.x + 500.f, 65.f)];
	[_physicsNode addChild:enemy];
}

- (void)killEnemy {
	[enemy die];
	CCSprite *defeatedEnemy = (CCSprite *)[CCBReader load:@"EnemyDefeated"];
	[enemy addChild:defeatedEnemy];
	defeatedEnemy.position = ccp(0, 0);
	defeatedEnemy.visible = YES;
}

- (void)createRocket {
	rocket = (Rocket *)[CCBReader load:@"RocketExplosion"];
	rocket.zOrder = DrawingOrderDifficulties;
	[rocket setPosition:ccp(mainCharacter.position.x + 1000.f, 50.f)];
	[_physicsNode addChild:rocket];
}

- (void)explodeRocket {
	Explosion *explosion = (Explosion *)[CCBReader load:@"Explosion"];
	[_physicsNode addChild:explosion];
	explosion.position = rocket.position;
	[rocket removeFromParentAndCleanup:YES];
}

- (void)defeat {
	[mainCharacter die];
	CCSprite *defeatedSprite = (CCSprite *)[CCBReader load:@"MainCharacterDefeated"];
	[mainCharacter addChild:defeatedSprite];
	defeatedSprite.position = ccp(0, 0);
	defeatedSprite.visible = YES;
}

// >>> Collisions

// Uranium rocks
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision rock:(Rock *)rock {
	NSLog(@"Character and rock collision");
	rock.visible = NO;
	[rock removeFromParentAndCleanup:YES];
	[_rocks removeObject:rock];

	_sinceUranium = 0.f;
	mainCharacter.hasAdrenaline = YES;
	[mainCharacter startRunning];
	return YES;
}

// Play blood particle.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision spike:(CCNode *)spike {
	NSLog(@"Character and spike collision");
	[mainCharacter bleed];

	return YES;
}

// Stop jumping.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision floor:(CCNode *)floor {
	NSLog(@"Character and floor collision");
	if ([mainCharacter isJumping]) {
		[mainCharacter startWalking];
	}
	return YES;
}

// Explode and die.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision rocket:(Rocket *)rocketCollision {
	NSLog(@"Character and rocket collision");
	if (![characterCollision isDead]) {
		[self defeat];
		[self explodeRocket];
	}
	return YES;
}

// Explode and remove bullet.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(Bullet *)bulletCollision rocket:(Rocket *)rocketCollision {
	NSLog(@"Bullet and rocket collision");
	[self explodeRocket];
	[self createRocket];
	[bullets removeObject:bulletCollision];
	[bulletCollision removeFromParentAndCleanup:YES];

	return YES;
}

// Kill enemy and disable collision with body.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(Bullet *)bulletCollision enemy:(Enemy *)enemyCollision {
	NSLog(@"Bullet and enemy collision");
	if (![enemyCollision isDead]) {
		[self killEnemy];
		[bullets removeObject:bulletCollision];
		[bulletCollision removeFromParentAndCleanup:YES];
	}
	return YES;
}

// Kill enemy and disable collision with body.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision enemy:(Enemy *)enemyCollision {
	NSLog(@"Main character and enemy collision");
	if (![enemyCollision isDead] && ![characterCollision isDead]) {
		[self defeat];
	}
	return YES;
}

// Kill enemy and disable collision with body.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision laser:(Laser *)laserCollision {
	NSLog(@"Main character and laser collision");
	if (![characterCollision isDead]) {
		[characterCollision bleed];
//		[self defeat];
	}
	return YES;
}

@end
