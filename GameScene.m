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
#import "CurrentGameStats.h"

CCTexture2D* tex1;
CCTexture2D* tex2;
CCTexture2D* tex3;
CCTexture2D* tex4;
GoombaBasic* goomba;
CCParticleSnow* snow;
CCTMXObjectGroup* objectLayer;
CCTMXTiledMap *map;
bool isColliding;
CCParticleMeteor *breath;
CCSprite* marioFeet;
CCSprite* marioFullImage;
CCRepeatForever *repeat;
int points;

@implementation GameScene
@synthesize anim;
@synthesize player;

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
        NSMutableDictionary* newdictionary = [CurrentGameStats returnNewGameStats];
        NSLog(@"%@", newdictionary);
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
        tex3 = [[CCTextureCache sharedTextureCache] addImage:@"mariok.png"];
        tex1 = [[CCTextureCache sharedTextureCache] addImage:@"mario.png"];
        tex2 = [[CCTextureCache sharedTextureCache] addImage:@"mario3.png"];
        tex4 = [[CCTextureCache sharedTextureCache] addImage:@"mariostomp.png"];
        player = [CCSprite spriteWithTexture:tex1];

        [self addChild:player z:10 tag:1];
        gameWorldSize = CGRectMake(0, 0, 4000, 1000);
        CCFollow *followmario = [CCFollow actionWithTarget:player worldBoundary:gameWorldSize];
        [self runAction:followmario];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        player.position = CGPointMake(screenSize.width / 2, screenSize.height/ 6);
        
        _backgroundNode = [Weather node];
        ground = [CCSprite spriteWithFile:@"ground-image.png"];
        ground.anchorPoint = CGPointMake(0, 0);
        [self addChild:ground z:5];
        [self addChild:_backgroundNode z:0 tag:100];
        CCSprite* gameLevelBackground = [CCSprite spriteWithFile:@"menubg2.png"];

        for (int i = 0; i < gameWorldSize.size.width; i += gameLevelBackground.textureRect.size.width) {
        CCSprite* gameLevelBackground = [CCSprite spriteWithFile:@"menubg2.png"];
        gameLevelBackground.position = ccp(i,-20);
        gameLevelBackground.anchorPoint = ccp(0,0);
        [self addChild:gameLevelBackground z:1];
        }
        
        snow = [CCParticleRain node];
        snow.texture = [[CCTextureCache sharedTextureCache] addImage:@"drop.png"];
        snow.totalParticles = 100;
        snow.speed = 200;
        snow.startSize = 8;
        snow.duration = 100000;
        [self addChild:snow z:90];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"runningfeet.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"runningfeet.png"];
        [self addChild:spriteSheet z:200];
        
        
        NSMutableArray *animFrames = [NSMutableArray array];
        for (int i = 1; i <= 5; i++) {
            NSString *file = [NSString stringWithFormat:@"foot%d.png", i];
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:file];
            [animFrames addObject:frame];
        }
        
        marioFeet = [CCSprite spriteWithSpriteFrameName:@"foot1.png"];
        marioFeet.position = ccp(300.0f, screenSize.height / 6 + 5);
        [spriteSheet addChild:marioFeet z:50];
        anim = [CCAnimation animationWithSpriteFrames:animFrames delay:0.05f];
        repeat = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:anim]];
        [marioFeet runAction:repeat];
        marioFeet.flipX = YES;
        marioFeet.visible = NO;
        
        marioFullImage = [CCSprite spriteWithTexture:tex3];
        marioFullImage.position = CGPointMake(screenSize.width / 2, screenSize.height/ 6);
        [self addChild:marioFullImage z:11];

        
        breath = [CCParticleMeteor node];
        breath.texture = [[CCTextureCache sharedTextureCache] addImage:@"particle1.png"];
        [marioFullImage addChild:breath];
        breath.totalParticles = 0;
        breath.position = ccp(player.position.x - 200, player.position.y);

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
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float imageWidthHalved = [player texture].contentSize.width * 0.5f;
    float leftBorderLimit = imageWidthHalved;
    float rightBorderLimit = gameWorldSize.size.width - imageWidthHalved;

    if (pos.x < leftBorderLimit)
    {
        newPosition = ccp(leftBorderLimit, player.position.y);
        playerVelocity = CGPointZero; }
    else if (pos.x > rightBorderLimit) {
        newPosition = ccp(rightBorderLimit, player.position.y);
        playerVelocity = CGPointZero; }
    else {
        marioFullImage.position = CGPointMake(player.position.x, player.position.y);
        marioFeet.position = ccp(player.position.x + scaledVelocity.x, player.position.y - player.boundingBox.size.height / 2.4);
        [repeat step:0.02];
        snow.position = CGPointMake(player.position.x, screenSize.height);
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
        float flippedDirection = ((player.flipX == YES) ? -360 : 360);
        [[SimpleAudioEngine sharedEngine] playEffect:@"yah.wav"];
        id rotate = [CCRotateBy actionWithDuration:0.2 angle:flippedDirection];
        [player runAction:rotate];
        player.texture = tex4;
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
        [self addChild:goomba z:3 tag:2];
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
            id blinker = [CCBlink actionWithDuration: 1.0 blinks: 10];
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
            
            skipMarioHitByGoombaCheck = true;
            break;
        }
        if ((actualDistance < maxCollisionDistance) && skipMarioHitByGoombaCheck == false && goomba.collided == false) {
            [self resetGoombas];
            [self marioHitFlash];
            break;
        }
    }
}

-(void)returnM:(id)sender {
    [sender stopAllActions];
}

-(void)removeGoomba:(id)sender {
    [sender removeFromParentAndCleanup:true];
}

-(void)jumpMario {
    float movePlayerPosition = ((player.flipX == YES) ? player.position.x - 100 : player.position.x + 100);
    id jump1 = [CCJumpTo actionWithDuration:0.6 position:ccp (movePlayerPosition, [CCDirector sharedDirector].winSize.height / 6) height:240 jumps:1];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"jumping.mp3"];
    CCSequence* jumpSequence = [CCSequence actions:jump1, nil];
    marioFullImage.visible = NO;
    marioFeet.visible = NO;
    [player runAction:jumpSequence];
    player.texture = tex2;
}

-(void)marioHitFlash {
    CCFiniteTimeAction* blinker = [CCBlink actionWithDuration: 2 blinks: 10];
    id showMario = [CCShow action];
    id sequence = [CCSequence actions:blinker, showMario, nil];
    player.texture = tex3;
    [player runAction: sequence];
    marioFeet.visible = YES;
    marioFullImage.visible = NO;
}

-(void)checkMarioJumpFinished {
    if (![player numberOfRunningActions]) {
        marioFeet.visible = YES;
        marioFullImage.visible = YES;
        player.texture = tex1;
        player.rotation = 0;
    }
}

-(void)spritePosition {
    if (leftJoystick.degrees >= 90 && leftJoystick.degrees < 270) {
        player.flipX = YES;
        marioFullImage.flipX = YES;
        marioFullImage.opacity = 0;
        marioFeet.opacity = 255;
        marioFeet.flipX = NO;
        breath.totalParticles = 0;
    }
    
    else if (leftJoystick.degrees == 0){
        [repeat step:0.4];
        marioFullImage.opacity = 255;
        marioFeet.opacity = 0;
        isColliding = NO;
        breath.totalParticles = (arc4random() % (3));
        breath.emissionRate = 12;
        
    }
    else {
        player.flipX = NO;
        marioFullImage.flipX = NO;
        marioFullImage.opacity = 0;
        marioFeet.opacity = 255;
        marioFeet.flipX = YES;
        breath.totalParticles = 0;
    }

}

-(void)checkForCollidableBlock {
    int numObjects = objectLayer.objects.count;
    for (int i = 0; i < numObjects; i++) {
        NSString *matchedObject = [[objectLayer.objects objectAtIndex:i] objectForKey:@"type"];
        
        if ([matchedObject isEqualToString:@"Tunnel"] == TRUE) {
            [self checkTunnelCollision:[objectLayer.objects objectAtIndex:i]];
            continue;
        }

        NSMutableDictionary* properties = [objectLayer.objects objectAtIndex:i];
        CGRect rect = [self getRectFromObjectProperties:properties tileMap:map];
        
        if (CGRectContainsPoint(rect, CGPointMake(player.position.x, player.position.y + player.boundingBox.size.height))){
            player.position = ccp(player.position.x, player.position.y - 4);
            id moveBackToLevelGround = [CCJumpTo actionWithDuration:0.1 position:CGPointMake(player.position.x - 6, ([CCDirector sharedDirector].winSize.height / 6)) height:5 jumps:1];
            [player runAction:moveBackToLevelGround];
        }
        
        else if (CGRectIntersectsRect(rect, player.boundingBox)) {
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

-(void)checkTunnelCollision:(id)sender {
    CGRect rect = [self getRectFromObjectProperties:sender tileMap:map];
    if (CGRectIntersectsRect(rect, player.boundingBox)) {
        isColliding = YES;
        marioFullImage.visible = NO;
        [player stopAllActions];
        player.position = ccp(player.position.x, player.position.y - 4);
        
        if (rect.origin.y < player.position.y && player.position.y > [CCDirector sharedDirector].winSize.height / 6) {
            player.position = ccp(player.position.x, rect.origin.y + rect.size.height * 1.2);
        }
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
