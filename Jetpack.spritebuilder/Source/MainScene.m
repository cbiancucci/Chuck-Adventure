//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "MainCharacter.h"
#import "UraniumRock.h"
#import "Rocket.h"
#import "Bullet.h"
#import "Explosion.h"
#import "Enemy.h"
#import "Laser.h"
#import "Pause.h"
#import "Spike.h"
#import "Gun.h"
#import "Cannonball.h"

typedef NS_ENUM (NSInteger, DrawingOrder) {
	DrawingOrderBackground,
	DrawingOrderUraniumRock,
	DrawingOrderEnemy,
	DrawingOrderCharacter,
	DrawingOrderBullet,
	DrawingOrderDifficulties,
	DrawingOrderParticles,
	DrawingOrderText
};

@implementation MainScene {
	int level;
	double distance;
	int uraniumCount;
	BOOL levelOneFlag;
	BOOL levelTwoFlag;
	BOOL levelThreeFlag;
	BOOL lifeSupplyDelivered;
	BOOL uraniumRockWasCreated;

	CGFloat cameraScrollSpeed;

	CGSize size;

	CGPoint initialTouchLocation;
	CGPoint finalTouchLocation;

	//PhysicsNode
	CCPhysicsNode *_physicsNode;

	// Character
	MainCharacter *mainCharacter;

	// Texts
	CCLabelTTF *distanceText;
	CCLabelTTF *uraniumCountText;
	CCLabelTTF *pauseText;
	CCLabelTTF *gamePausedText;
	CCLabelTTF *gameOverText;
	CCLabelTTF *retryText;
	CCLabelTTF *recordText;

	// Background
	CCNode *_background1;
	CCNode *_background2;
	CCNode *_backgroundlvl2_1;
	CCNode *_backgroundlvl2_2;
	NSMutableArray *_backgrounds;

	// UI
	CCNode *_lifeBar;
	float lifeScale;

	Pause *pauseDialog;

	// Floor
	CCNode *_floors;

	// Roof
	CCNode *_roof1;
	CCNode *_roof2;
	NSArray *_roofs;

	NSTimeInterval _sinceTouch;
	NSTimeInterval _sinceShoot;
	NSTimeInterval _sinceBullet;
	NSTimeInterval _sinceLaser;
	NSTimeInterval _sinceCannonball;
	NSTimeInterval _sincePlayStep;
	NSTimeInterval _sinceUraniumWasPicked;
	NSTimeInterval _sinceAdrenaline;

	// Weapons
	NSMutableArray *bullets;

	// Difficulties
	Rocket *rocket;
	Enemy *enemy;
	Spike *spike;
	Gun *gun;
	NSMutableArray *cannonballs;
	Cannonball *cannonball;
	NSMutableArray *lasers;
	Laser *laser;

	UraniumRock *uraniumRock;

	// Audio
	OALSimpleAudio *audio;
}

- (void)didLoadFromCCB {
	size  = [[CCDirector sharedDirector] viewSize];
	levelOneFlag = NO;
	levelTwoFlag = NO;
	levelThreeFlag = NO;
	lifeSupplyDelivered = NO;
	uraniumRockWasCreated = NO;

	// set this class as delegate
	_physicsNode.collisionDelegate = self;

	// Texts
	[self loadTextSettings];

	// Context
	[self loadContextInitialSettings];

	// Character
	[self loadCharacterInitialSettings];

	// Difficulties
	[self loadDifficultiesSettings];

	// Music
	[self loadMusicSettings];

	// UI
	[self loadPauseDialog];

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

	uraniumCountText = [CCLabelTTF labelWithString:@"000" fontName:@"heiTOLENOVOLEPhone.ttf" fontSize:20];
	uraniumCountText.outlineColor = [CCColor blackColor];
	uraniumCountText.outlineWidth = 2.0f;
	uraniumCountText.zOrder = DrawingOrderText;
	[uraniumCountText setPosition:ccp(47.f, 275.f)];
	[self addChild:uraniumCountText];

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
	cameraScrollSpeed = 100.f;
	distance = 0;

	uraniumCount = 0;
	_sinceUraniumWasPicked = 0.f;

	_backgrounds = [[NSMutableArray alloc] init];
	[_backgrounds addObject:_background1];
	[_backgrounds addObject:_background2];

	_backgroundlvl2_1.visible = NO;
	_backgroundlvl2_2.visible = NO;

	_roofs = @[_roof1, _roof2];

	lifeScale = 1.f;
}

- (void)loadCharacterInitialSettings {
	mainCharacter = (MainCharacter *)[_physicsNode getChildByName:@"MainCharacter" recursively:YES];
	mainCharacter.zOrder = DrawingOrderCharacter;
	mainCharacter.hasAdrenaline = NO;
	[mainCharacter stop];
	[mainCharacter startWalking];
}

- (void)loadDifficultiesSettings {
	[self createSpike];
}

- (void)loadMusicSettings {
	audio = [OALSimpleAudio sharedInstance];
	[audio playBg:@"Level.mp3" loop:YES];
	_sincePlayStep = 0;
}

- (void)loadPauseDialog {
	pauseDialog = (Pause *)[CCBReader load:@"Pause"];
	[pauseDialog setPosition:ccp(size.width / 2, size.height / 2)];
	[self addChild:pauseDialog];
	pauseDialog.visible = NO;
}

- (void)update:(CCTime)delta {
	if (cameraScrollSpeed < 200.f) {
		cameraScrollSpeed += distance * 0.001f;
	}
	if (![mainCharacter isDead]) {
		// Update character position.
		mainCharacter.position = ccp(mainCharacter.position.x + delta * cameraScrollSpeed, mainCharacter.position.y);
		_physicsNode.position = ccp(_physicsNode.position.x - (cameraScrollSpeed * delta), _physicsNode.position.y);
		_sinceAdrenaline += delta;

		if ([mainCharacter hasAdrenaline] && _sinceAdrenaline > 25.f) {
			[mainCharacter stopAdrenaline];
			cameraScrollSpeed = 200.f;
		}

		_sincePlayStep += delta;
		if (_sincePlayStep > 0.3f) {
			[audio playEffect:@"Step.mp3" loop:NO];
			_sincePlayStep = 0;
		}

		distance += 0.1f;

		level = distance / 100;

		if (level == 1 && !levelOneFlag) {
			[self createRocket];
			levelOneFlag = YES;
		}

		if (level == 2 && !levelTwoFlag) {
			[self updateLevelBackground];
			[self createGun];
			levelTwoFlag = YES;
		}

		if (level == 3 && !levelThreeFlag) {
			[self createEnemy];
			levelThreeFlag = YES;
		}

		// Update spike.
		if (spike) {
			CGPoint spikeWorldPosition = [_physicsNode convertToWorldSpace:spike.position];

			if (spikeWorldPosition.x < -200) {
				[spike removeFromParentAndCleanup:YES];
				[self createSpike];
			}
		}

		// Update rocket.
		if (rocket && level >= 1) {
			rocket.physicsBody.velocity = CGPointMake(-200, 0);

			CGPoint rocketWorldPosition = [_physicsNode convertToWorldSpace:rocket.position];

			if (rocketWorldPosition.x < -200) {
				[rocket removeFromParentAndCleanup:YES];
				[self createRocket];
			}
		}

		// Update gun.
		if (gun && level >= 2) {
			CGPoint gunWorldPosition = [_physicsNode convertToWorldSpace:gun.position];

			if (gunWorldPosition.x < -200) {
				[gun removeFromParentAndCleanup:YES];
				[self createGun];
			}

			if (![gun isBroken] && gun.position.x - mainCharacter.position.x <400 && [cannonballs count] == 0 && _sinceCannonball> 1.5f) {
				_sinceCannonball = 0.f;
				[self createCannonball];
			}
		}

		// Update enemies.
		if (enemy && level >= 3) {
			if (![enemy isDead]) {
				enemy.physicsBody.velocity = CGPointMake(-50, 0);
			}
			else {
				enemy.physicsBody.velocity = CGPointMake(0, 0);
			}

			CGPoint enemyWorldPosition = [_physicsNode convertToWorldSpace:enemy.position];

			if (enemyWorldPosition.x < -200) {
				[enemy removeFromParentAndCleanup:YES];
				[self createEnemy];
			}

			if (![enemy isDead] && enemy.position.x - mainCharacter.position.x < 400 && [lasers count] == 0) {
				_sinceLaser = 0.f;
				[self createLaser];
				[enemy startShooting];
			}
		}

		// Create uranium rocks
		if ((int)distance % 50 == 0 && !uraniumRockWasCreated && ![mainCharacter hasAdrenaline]) {
			[self createUraniumRock];
			uraniumRockWasCreated = YES;
		}

		// Create life supply once.
		if ((int)distance == 400 && !lifeSupplyDelivered) {
			[self createLifeSupply];
			lifeSupplyDelivered = YES;
		}

		// Update and destroy off screen bullets.
		if (bullets && [bullets count] > 0) {
			[self updateBullets];
		}

		// Update and destroy off screen lasers.
		_sinceLaser += delta;
		if (![enemy isDead] && [lasers count] > 0 && _sinceLaser > 2.f) {
			_sinceLaser = 0.f;
			[self createLaser];
		}

		// Update and destroy off screen cannonballs.
		_sinceCannonball += delta;
		if (![gun isBroken] && [cannonballs count] > 0 && _sinceCannonball > 2.f) {
			_sinceCannonball = 0.f;
			[self createCannonball];
		}

		// Update and destroy uranium rocks.
		_sinceUraniumWasPicked += delta;
		if (uraniumRock.position.x < -200) {
			[uraniumRock removeFromParentAndCleanup:YES];
			uraniumRockWasCreated = NO;
		}

		// Update character state.
		_sinceBullet += delta;
		if ([mainCharacter isShooting] && _sinceBullet > 0.4f) {
			_sinceBullet = 0;
		}

		if ([mainCharacter isRunning] && ![mainCharacter hasAdrenaline]) {
			[mainCharacter startWalking];
		}

		_sinceShoot  += delta;
		if ([mainCharacter isShooting] && _sinceShoot > 0.2f) {
			[mainCharacter stopShooting];
		}

		// Update distance text.
		[distanceText setString:[NSString stringWithFormat:@"%03d%@", (int)distance, @"M"]];

		[self loopBackground];
	}
	else {
		if (![enemy isDead]) {
			[enemy stopShooting];
		}
		gameOverText.visible = YES;
		retryText.visible = YES;
	}
}

- (void)updateBullets {
	NSMutableArray *removeBullets = [[NSMutableArray alloc] init];
	for (Bullet *bullet in bullets) {
		bullet.physicsBody.velocity = CGPointMake(cameraScrollSpeed + 800, 0);

		CGPoint bulletWorldPosition = [_physicsNode convertToWorldSpace:bullet.position];
		if (bulletWorldPosition.x > size.width) {
			[removeBullets addObject:bullet];
		}
	}

	if ([removeBullets count] > 0) {
		[self destroyBullets:removeBullets];
	}
}

- (void)destroyBullets:(NSMutableArray *)removeBullets {
	for (Bullet *bullet in removeBullets) {
		[bullet removeFromParentAndCleanup:YES];
		[bullets removeObject:bullet];
	}
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	initialTouchLocation = [touch locationInView:[touch view]];
	if (![mainCharacter isDead]) {
		// Pause Dialog
		if (pauseDialog.visible && [self pauseDialogIsTouched:initialTouchLocation]) {
			[pauseDialog touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event];
		}
		// Pause (up-right corner) is pressed.
		else if ([self pauseIsTouched:initialTouchLocation]) {
			[self pause];
		}
		// Main character shoot
		else {
			if (![CCDirector sharedDirector].isPaused) {
				// Si toco la mitad derecha de la pantalla.
				if ((initialTouchLocation.x > 300)) {
					[mainCharacter startShooting];
					_sinceShoot = 0.f;
					_sinceBullet = 0.f;
					[self createBullet];
				}
			}
		}
	}
	else { // Retry after main character is dead.
		[audio stopAllEffects];
		[[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"]];
	}
}

// Swipe movement to make Main Character jump.
- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
	finalTouchLocation = [touch locationInView:[touch view]];

	if (![CCDirector sharedDirector].isPaused) {
		if (![mainCharacter isDead]) {
			// Si toco la mitad izquierda de la pantalla.
			if ((initialTouchLocation.x < 300)) {
				// Si hago swipe hacia arriba.
				if (initialTouchLocation.y - finalTouchLocation.y > 50) {
					initialTouchLocation = finalTouchLocation;
					if (![mainCharacter isJumping]) {
						[mainCharacter startJumping];
					}
				}
			}
		}
	}
}

- (void)pause {
	if ([CCDirector sharedDirector].isPaused) {
		pauseDialog.visible = NO;
		[[CCDirector sharedDirector] resume];
	}
	else {
		[[CCDirector sharedDirector] pause];
		pauseDialog.visible = YES;
	}
}

- (bool)pauseDialogIsTouched:(CGPoint)touchLocation {
	float left = pauseDialog.position.x - ([pauseDialog size].width / 2);
	float right = pauseDialog.position.x + ([pauseDialog size].width / 2);

	float up = pauseDialog.position.y - ([pauseDialog size].height / 2);
	float down = pauseDialog.position.y + ([pauseDialog size].height / 2);

	if ((touchLocation.x >= left && touchLocation.x <= right) && (touchLocation.y >= up && touchLocation.y <= down)) {
		return YES;
	}
	return NO;
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
			roof.position = ccp(roof.position.x + 2 * (roof.contentSize.width - 2), roof.position.y);
			roof.zOrder = DrawingOrderBackground;
		}
	}
}

- (void)updateLevelBackground {
	_backgroundlvl2_1.position = _background1.position;
	_backgroundlvl2_2.position = _background2.position;

	_backgrounds[0] = _backgroundlvl2_1;
	_backgrounds[1] = _backgroundlvl2_2;

	_backgroundlvl2_1.visible = YES;
	_backgroundlvl2_2.visible = YES;

	_background1.visible = NO;
	_background2.visible = NO;
}

- (void)createUraniumRock {
	uraniumRock = (UraniumRock *)[CCBReader load:@"Uranium"];
	uraniumRock.zOrder = DrawingOrderEnemy;
	[uraniumRock setPosition:ccp(mainCharacter.position.x + 500.f, 65.f)];
	[_physicsNode addChild:uraniumRock];
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

	[audio playEffect:@"MissileLaunch.mp3" volume:0.5 pitch:1 pan:1 loop:NO];
}

- (void)createLaser {
	if (!lasers) {
		lasers = [[NSMutableArray alloc] init];
	}

	laser = (Laser *)[CCBReader load:@"Laser"];
	laser.zOrder = DrawingOrderDifficulties;
	[_physicsNode addChild:laser];
	laser.position = ccp(enemy.position.x - 15, enemy.position.y + 10);
	laser.physicsBody.velocity = CGPointMake(-200, 0);

	[lasers addObject:laser];
	[audio playEffect:@"CreateLaser.mp3" loop:NO];
}

- (void)createCannonball {
	if (!cannonballs) {
		cannonballs = [[NSMutableArray alloc] init];
	}

	cannonball = (Cannonball *)[CCBReader load:@"Cannonball"];
	cannonball.zOrder = DrawingOrderDifficulties;
	[_physicsNode addChild:cannonball];
	cannonball.position = ccp(gun.position.x - 25, gun.position.y + 10);
	cannonball.physicsBody.velocity = CGPointMake(-200, 0);

	[cannonballs addObject:cannonball];

	[audio playEffect:@"Cannonball.mp3" volume:0.5 pitch:1 pan:1 loop:NO];
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
	explosion.zOrder = DrawingOrderParticles;
	explosion.position = rocket.position;
	[rocket removeFromParentAndCleanup:YES];
	[audio playEffect:@"RocketExplosion.mp3" loop:NO];
}

- (void)createSpike {
	spike = (Spike *)[CCBReader load:@"Spike"];
	spike.zOrder = DrawingOrderDifficulties;
	[spike setPosition:ccp(mainCharacter.position.x + 700.f, 50.f)];
	[_physicsNode addChild:spike];
}

- (void)createGun {
	gun = (Gun *)[CCBReader load:@"Gun"];
	gun.zOrder = DrawingOrderDifficulties;
	[gun setPosition:ccp(mainCharacter.position.x + 1500.f, 50.f)];
	[_physicsNode addChild:gun];
}

- (void)createLifeSupply {
	CCNode *lifePack = (CCNode *)[CCBReader load:@"LifeSupply"];
	lifePack.zOrder = DrawingOrderDifficulties;
	[lifePack setPosition:ccp(mainCharacter.position.x + 700.f, 45.f)];
	[_physicsNode addChild:lifePack];
}

- (void)defeat {
	[mainCharacter die];
	CCSprite *defeatedSprite = (CCSprite *)[CCBReader load:@"MainCharacterDefeated"];
	[mainCharacter addChild:defeatedSprite];
	defeatedSprite.position = ccp(0, 0);
	defeatedSprite.visible = YES;

	[audio playEffect:@"Hurt.mp3" loop:NO];
}

// >>> Collisions

// Uranium rocks
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision uraniumRock:(UraniumRock *)uraniumRockCollision {
	NSLog(@"Character and uranium rock collision");
	if (_sinceUraniumWasPicked > 1.f) {
		uraniumCount++;
		uraniumRockWasCreated = NO;
		[uraniumCountText setString:[NSString stringWithFormat:@"%03d", uraniumCount]];
		[uraniumRockCollision removeFromParentAndCleanup:YES];
		[audio playEffect:@"GemPickup.mp3" loop:NO];

		_sinceUraniumWasPicked = 0.f;

		if (uraniumCount % 10 == 0 && ![characterCollision hasAdrenaline]) {
			[characterCollision startAdrenaline];
			cameraScrollSpeed = 500.f;
			_sinceAdrenaline = 0;
		}
	}

	return YES;
}

// Play blood particle.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision spike:(CCNode *)spike {
	NSLog(@"Character and spike collision");
	if (![characterCollision isDead] && ![characterCollision hasAdrenaline]) {
		[mainCharacter bleed];
		lifeScale -= 0.02f;
		[_lifeBar setScaleX:lifeScale];

		if (lifeScale <= 0) {
			lifeScale = 0.f;
			[self defeat];
		}
	}
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
	if (![characterCollision isDead] && ![characterCollision hasAdrenaline]) {
		[self defeat];
		[_lifeBar setScaleX:0];
		[self explodeRocket];
	}

	if (![characterCollision isDead] && [characterCollision hasAdrenaline]) {
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
	if (![enemyCollision isDead] && ![characterCollision isDead] && ![characterCollision hasAdrenaline]) {
		[_lifeBar setScaleX:0];
		[self defeat];
	}

	if (![enemyCollision isDead] && ![characterCollision isDead] && [characterCollision hasAdrenaline]) {
		[self killEnemy];
	}
	return YES;
}

// Harm Main Character and destroy laser.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision laser:(Laser *)laserCollision {
	NSLog(@"Main character and laser collision");
	if (![characterCollision isDead] && ![characterCollision hasAdrenaline]) {
		[characterCollision bleed];
		lifeScale -= 0.05f * level;
		[_lifeBar setScaleX:lifeScale];

		if (lifeScale <= 0) {
			lifeScale = 0.f;
			[self defeat];
		}
		[lasers removeObject:laserCollision];
		[laserCollision removeFromParentAndCleanup:YES];
	}

	if (![characterCollision isDead] && [characterCollision hasAdrenaline]) {
		[lasers removeObject:laserCollision];
		[laserCollision removeFromParentAndCleanup:YES];
	}
	return YES;
}

// Destroy gun.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(Bullet *)bulletCollision gun:(Gun *)gunCollision {
	NSLog(@"Bullet and gun collision");
	if (![gunCollision isBroken]) {
		[gunCollision destroy];
		[bulletCollision removeFromParentAndCleanup:YES];
	}
	return YES;
}

// Cannonballs harm main character.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision cannonball:(Cannonball *)cannonballCollision {
	NSLog(@"Main Character and cannonball collision");
	if (![characterCollision isDead] && ![characterCollision hasAdrenaline]) {
		[characterCollision bleed];
		lifeScale -= 0.05f * level;
		[_lifeBar setScaleX:lifeScale];

		if (lifeScale <= 0) {
			lifeScale = 0.f;
			[self defeat];
		}
		[cannonballs removeObject:cannonballCollision];
		[cannonballCollision removeFromParentAndCleanup:YES];
	}

	if (![characterCollision isDead] && [characterCollision hasAdrenaline]) {
		[cannonballs removeObject:cannonballCollision];
		[cannonballCollision removeFromParentAndCleanup:YES];
	}
	return YES;
}

// Bullets destroy cannonballs.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair bullet:(Bullet *)bulletCollision cannonball:(Cannonball *)cannonballCollision {
	NSLog(@"Bullet and cannonball collision");
	[cannonballs removeObject:cannonballCollision];
	[cannonballCollision removeFromParentAndCleanup:YES];

	[bullets removeObject:bulletCollision];
	[bulletCollision removeFromParentAndCleanup:YES];

	return YES;
}

// Restore life from life supply.
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision life:(CCNode *)lifeCollision {
	NSLog(@"Main Character and life supply collision");
	if (![characterCollision isDead]) {
		[_lifeBar setScaleX:1.03];
		[audio playEffect:@"Resurrect.mp3" loop:NO];
	}

	return YES;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair character:(MainCharacter *)characterCollision gun:(Gun *)gunCollision {
	if (![characterCollision isDead] && [characterCollision hasAdrenaline]) {
		[gunCollision destroy];
	}

	return YES;
}

@end
