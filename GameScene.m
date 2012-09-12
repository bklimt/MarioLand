//
//  GameScene.m
//  MarioLand
//
//  Created by Mac Book on 8/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "GoombaBasic.h"

CCTexture2D* tex1;
CCTexture2D* tex2;
GoombaBasic* goomba;
CCParticleRain* rain;
CCTMXObjectGroup* objectLayer;
CCTMXTiledMap *map;
bool isColliding;

@implementation GameScene

+(id) scene {
    CCScene *scene = [CCScene node];
    HUDLayer *hud = [HUDLayer node];
    [scene addChild:hud z:1];
    CCLayer* layer = [[[GameScene node] initWithHUD:hud] autorelease];
    CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(244, 234, 234, 244)];
    [scene addChild:colorLayer z:-4];
    [scene addChild:layer];
    return scene;
}

- (id)initWithHUD:(HUDLayer *)hud
{
    if ((self = [super init])) {
        
        CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:@"level1.tmx"];
        [self addChild:map z:10 tag:666];
        for( CCTMXLayer* child in [map children] ) {
            [[child texture] setAntiAliasTexParameters];
        }
        
        objectLayer = [map objectGroupNamed:@"ObjectLayer1"];
        
        _hud = hud;
        CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"ghosts3.mp3" loop:YES]; 
        self.isAccelerometerEnabled = YES;
        tex1 = [[CCTextureCache sharedTextureCache] addImage:@"mario.png"];
        tex2 = [[CCTextureCache sharedTextureCache] addImage:@"mario3.png"];
        player = [CCSprite spriteWithTexture:tex1];

        [self addChild:player z:10 tag:1];
        gameWorldSize = CGRectMake(0, 0, 4000, 1000);
        CCFollow *followmario = [CCFollow actionWithTarget:player worldBoundary:gameWorldSize];
        [self runAction:followmario];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
//        float imageHeight = [player texture].contentSize.height / 3;
        //player original position height needs to be adjusted below
        player.position = CGPointMake(screenSize.width / 2, screenSize.height/ 6);
        
        // add parallaxing background with sprites //
        
        _backgroundNode = [Weather node];
        ground = [CCSprite spriteWithFile:@"ground-image.png"];
        ground.anchorPoint = CGPointMake(0, 0);
        [self addChild:ground];
        [self addChild:_backgroundNode z:-4 tag:100];
        
        CCMoveBy* move1 = [CCMoveBy actionWithDuration:12 position:CGPointMake(-4000, 0)];
        CCMoveBy* move2 = [CCMoveBy actionWithDuration:0 position:CGPointMake(4000, 0)];
        CCSequence* sequence = [CCSequence actions:move1, move2, nil]; //add extra actions here
        CCRepeatForever* repeat = [CCRepeatForever actionWithAction:sequence];
        [_backgroundNode runAction:repeat];
        
        rain = [CCParticleRain node];
        rain.texture = [[CCTextureCache sharedTextureCache] addImage:@"drop.png"];
        rain.totalParticles = 400;
        rain.speed = 300;
        rain.startSize = 8;
        rain.duration = 100000;
        [self addChild:rain z:90];

        [_hud initFirstButton];
        [_hud initJoystick];
        [self scheduleUpdate];
        [self initGoombas];
    }
    return self;
}
-(void) dealloc {
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [goombas release];
    goombas = nil;
    [super dealloc]; }

-(void)update:(ccTime)deltaTime {
    CGPoint pos = player.position;
    CGPoint scaledVelocity = ccpMult(leftJoystick.velocity, 12);
    
    // The Player should also be stopped from going outside the screen
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float imageWidthHalved = [player texture].contentSize.width * 0.5f;
    float leftBorderLimit = imageWidthHalved;
    float rightBorderLimit = gameWorldSize.size.width - imageWidthHalved;
    
    // preventing the player sprite from moving outside the screen
    
    if (pos.x < leftBorderLimit)
    {
        newPosition = ccp(leftBorderLimit, player.position.y);
        playerVelocity = CGPointZero; }
    else if (pos.x > rightBorderLimit) {
        newPosition = ccp(rightBorderLimit, player.position.y);
        playerVelocity = CGPointZero; }
    else {
        rain.position = CGPointMake(player.position.x, screenSize.height);
        [self spritePosition];
        [self checkForCollidableBlock];
        if (isColliding == NO) {
            newPosition = ccp(player.position.x + scaledVelocity.x + deltaTime, player.position.y);
        }
        else if (isColliding == YES && player.position.y == [CCDirector sharedDirector].winSize.height / 6 && scaledVelocity.x > 0) {
            newPosition = ccp(player.position.x - 4, player.position.y);
        }
        else if (isColliding == YES && player.position.y == [CCDirector sharedDirector].winSize.height / 6 && scaledVelocity.x < 0) {
            newPosition = ccp(player.position.x + 4, player.position.y);
        }
        else {
            newPosition = ccp(player.position.x + scaledVelocity.x + deltaTime, player.position.y);
        }
}
    
    if (firstButton.value == 1 && ![player numberOfRunningActions]) {
        NSLog(@"got to jump");
        [self jumpMario];
    }
    
    if (firstButton.value == 1 && [player numberOfRunningActions] == 1 && firstButton.doubleTapEnabled >= 2) {
        NSLog(@"jump enabled");
    }

    [player setPosition:newPosition];
    [self checkForCollision];
    [self checkMarioJumpFinished];
    [self checkGroundChange];
}

-(void)checkGroundChange {
    int groundWidth = [ground boundingBox].size.width;
    if ((int)player.position.x - ground.position.x > (2 * (groundWidth / 3))) {
        self->ground.position = ccp(player.position.x - 300, 0);
    }
    else if ((int)player.position.x - ground.position.x <= (groundWidth / 3)) {
        self->ground.position = ccp(player.position.x - 480, 0);
    }
}


-(void) initGoombas {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    GoombaBasic* tempGoomba = [GoombaBasic new];
    float imageWidth = [tempGoomba texture].contentSize.width;
    int numGoombas = screenSize.width / imageWidth;
    // Initialize the goombas array using alloc.
    
    goombas = [[CCArray alloc] initWithCapacity:numGoombas];
    for (int i = 0; i < numGoombas; i++) {
        GoombaBasic* goomba = [GoombaBasic new];
        [self addChild:goomba z:0 tag:2];
        // Also add the goomba to the goombas array.
        [goombas addObject:goomba]; }
    // call the method to reposition all goombas
    [self resetGoombas];
}

-(void) resetGoombas {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    // Get any goomba to get its image width
    int numGoombas = [goombas count];
    for (int i = 0; i < numGoombas; i++) {
        goomba = [goombas objectAtIndex:i];
        goomba.position = CGPointMake(player.position.x + 700,
        screenSize.height / 7);
        [goomba stopAllActions];
    }
    [self unschedule:@selector(goombasUpdate:)];
    [self schedule:@selector(goombasUpdate:) interval:3.0f];
    numGoombasMoved = 0;
    goombaMoveDuration = 6.0f;
}

-(void) goombasUpdate:(ccTime)delta {
    for (int i = 0; i < 10; i++)
    {
        int randomGoombaIndex = CCRANDOM_0_1() * [goombas count];
        goomba = [goombas objectAtIndex:randomGoombaIndex];
        if ([goomba numberOfRunningActions] == 0) {
            [self runGoombaMoveSequence:goomba];
            break;
        }
    }
}

-(void) runGoombaMoveSequence:(CCSprite*)goomba {
    numGoombasMoved++;
    if (numGoombasMoved % 8 == 0 && goombaMoveDuration > 2.0f) {
    goombaMoveDuration -= 0.1f; }
    CGPoint belowScreenPosition = CGPointMake(-[goomba texture].contentSize.width,
    goomba.position.y);
CCMoveTo* move = [CCMoveTo actionWithDuration:goombaMoveDuration
position:belowScreenPosition];
    CCCallFuncN* callDidDrop = [CCCallFuncN actionWithTarget:self
selector:@selector(goombaDidDrop:)];
    CCSequence* sequence = [CCSequence actions:move, callDidDrop, nil];
[goomba runAction:sequence];
}

-(void) goombaDidDrop:(id)sender {
    NSAssert([sender isKindOfClass:[CCSprite class]], @"sender is not a CCSprite!");
    goomba = (GoombaBasic*)sender;
    CGPoint pos = goomba.position;
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    pos.x = screenSize.width;
//    pos.y = screenSize.height + [goomba texture].contentSize.height;
    goomba.position = pos;
}

-(void) checkForCollision {
    float playerImageSize = [player texture].contentSize.height / 3;
    float goombaImageSize = ([[goombas lastObject] texture].contentSize.height) / 2;
    float playerCollisionRadius = playerImageSize * 0.4f;
    float goombaCollisionRadius = goombaImageSize * 0.4f;
    float maxCollisionDistance = playerCollisionRadius + goombaCollisionRadius;
    int numGoombas = [goombas count];
    for (int i = 0; i < numGoombas; i++) {
        goomba = [goombas objectAtIndex:i];
        if ([goomba numberOfRunningActions] == 0) {
        }
        
        bool skipMarioHitByGoombaCheck = false;
        float actualDistance = ccpDistance(player.position, goomba.position);
        
        if (CGRectContainsPoint([player boundingBox], CGPointMake(goomba.position.x + 20, goomba.position.y))) {
            [goomba stopAllActions];
            id blinker = [CCBlink actionWithDuration: 2.0 blinks: 20];
            id callback = [CCCallFuncN actionWithTarget:self selector:@selector(removeGoomba:)];
            id sequence = [CCSequence actions:blinker, callback, nil];
            [[SimpleAudioEngine sharedEngine] playEffect:@"stomp.mp3"];
            [goomba runAction:sequence];
            goomba.collided = true;
            goomba.scaleY = 0.6;
            goomba.position = CGPointMake(goomba.position.x, goomba.position.y - 5);
            id jumpOff = [CCJumpTo actionWithDuration:.4 position:ccp(player.position.x + 70, [CCDirector sharedDirector].winSize.height / 6) height:80 jumps:1];
            id returnMario = [CCCallFuncN actionWithTarget:self selector:@selector(returnM:)];
            id sequence4 = [CCSequence actions:jumpOff, returnMario, nil];
            [player runAction:sequence4];
            //goomba should actually be flipped along x axis and animated to drop off screen/
            
            skipMarioHitByGoombaCheck = true;
            break;
        }
        if ((actualDistance < maxCollisionDistance) && skipMarioHitByGoombaCheck == false && goomba.collided == false) {
            // restart the game for now
            [self resetGoombas];
            [self marioHitFlash];
            break;
        }
    }
}

-(void)returnM:(CCSprite*)sender {
    [sender stopAllActions];
}

-(void)removeGoomba:(id)sender {
    [self removeChild:sender cleanup:false];
}

-(void)jumpMario {
    NSLog(@"inside jumpmario method");
    id jump1 = [CCJumpTo actionWithDuration:0.6 position:ccp (player.position.x + 70, [CCDirector sharedDirector].winSize.height / 6) height:240 jumps:1];
    [[SimpleAudioEngine sharedEngine] playEffect:@"jumping.mp3"];
    CCSequence* jumpSequence = [CCSequence actions:jump1, nil];
    [player runAction:jumpSequence];
    player.texture = tex2;
}

-(void)marioHitFlash {
    CCFiniteTimeAction* blinker = [CCBlink actionWithDuration: 1 blinks: 10];
    CCCallBlock *renewMarioTex = [CCCallBlock actionWithBlock:^{[player setTexture:tex1];}];
    id flashSequence = [CCSequence actions:blinker, renewMarioTex, nil];
    [player runAction: flashSequence];

}

-(void)checkMarioJumpFinished {
    if (![player numberOfRunningActions]) {
        player.texture = tex1;
    }
}

-(void)spritePosition {
    if (leftJoystick.degrees > 90 && leftJoystick.degrees < 270) {
        player.flipX = YES;
    }
    else if (leftJoystick.degrees < 90 && leftJoystick.degrees > 0) {
        player.flipX = NO;
    }
    else {
        isColliding = NO;
    }
}

-(void)checkForCollidableBlock {
    int numObjects = objectLayer.objects.count;
    for (int i = 0; i < numObjects; i++) {
        NSDictionary* properties = [objectLayer.objects objectAtIndex:i];
        CGRect rect = [self getRectFromObjectProperties:properties tileMap:map];
        if (CGRectIntersectsRect(rect, player.boundingBox)) {
            isColliding = YES;
            [player stopAllActions];

            
            if (rect.origin.y < player.position.y && player.position.y > [CCDirector sharedDirector].winSize.height / 6) {
                player.position = ccp(player.position.x, rect.origin.y + rect.size.height * 1.6);
            }
            else {
                break;
            }
            
            
            break; }
    }
}

-(CGRect) getRectFromObjectProperties:(NSDictionary*)dict tileMap:(CCTMXTiledMap*)tileMap {
    float x, y, width, height;
    x = [[dict valueForKey:@"x"] floatValue] + tileMap.position.x;
    y = [[dict valueForKey:@"y"] floatValue] + tileMap.position.y;
    width = [[dict valueForKey:@"width"] floatValue];
    height = [[dict valueForKey:@"height"] floatValue];
    return CGRectMake(x, y, width, height);
}

@end
