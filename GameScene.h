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


@interface GameScene : CCLayer {
    CCSprite* player;
    CGPoint playerVelocity;
    CGPoint newPosition;

    CGRect gameWorldSize;
    HUDLayer * _hud;
    
    CCParallaxNode *_backgroundNode;
    CCSprite *bg1;
    CCSprite *bg2;
    CCSprite *bg3;
    CCSprite *bg4;
    CCSprite *bg5;
    CCSprite *ground;
    
    CCArray* goombas;
    float goombaMoveDuration;
    int numGoombasMoved;

}

+(id)scene;

- (id)initWithHUD:(HUDLayer *)hud;

@end
