//
//  GameScene.h
//  MarioLand
//
//  Created by Mac Book on 8/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HUDLayer.h"
#import "Weather.h"
#import "Constants.h"

CCSprite* player;

@interface GameScene : CCLayer {

    CGPoint playerVelocity;
    CGPoint newPosition;
    CGRect gameWorldSize;
    HUDLayer * _hud;
    
    Weather *_backgroundNode;
    CCSprite *ground;
    
    CCArray* goombas;
    float goombaMoveDuration;
    int numGoombasMoved;
}

@property (nonatomic, assign) CCAnimation *anim;
@property (nonatomic, copy) CCSprite *player;

+(id)scene;

- (id)initWithHUD:(HUDLayer *)hud;

@end
