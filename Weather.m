//
//  Weather.m
//  MarioLand
//
//  Created by Mac Book on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Weather.h"


@implementation Weather


-(id)init {
    
    if (self = [super init]) {
    bg1 = [CCSprite spriteWithFile:@"mariocloud1.png"];
    bg1.anchorPoint = CGPointMake(0, 0);
    bg2 = [CCSprite spriteWithFile:@"mariocloud2.png"];
    bg2.anchorPoint = CGPointMake(0, 0);
    bg3 = [CCSprite spriteWithFile:@"mariocloud3.png"];
    bg3.anchorPoint = CGPointMake(0, 0);
    bg3.position = CGPointMake(0,0);
    bg4 = [CCSprite spriteWithFile:@"mariocloud2.png"];
    bg4.anchorPoint = CGPointMake(0, 0);
    bg4.position = CGPointMake(0, 0);
    bg5 = [CCSprite spriteWithFile:@"mariocloud1.png"];
    bg5.anchorPoint = CGPointMake(0, 0);
    bg5.position = CGPointMake(0, 0);
    
    CGPoint cloudSpeed = ccp(0.2, 0.03);
    CGPoint cloudSpeed2 = ccp(0.25, 0.05);
    CGPoint cloudSpeed3 = ccp(0.22, 0.02);
    CGPoint topOffset = CGPointMake(0, [CCDirector sharedDirector].winSize.height * 0.8);
    CGPoint midOffset = CGPointMake(500, [CCDirector sharedDirector].winSize.height * 0.7);

    [self addChild:bg1 z:0 parallaxRatio:cloudSpeed positionOffset:midOffset];
    [self addChild:bg2 z:0 parallaxRatio:cloudSpeed2 positionOffset:midOffset];
    [self addChild:bg3 z:0 parallaxRatio:cloudSpeed positionOffset:topOffset];
    [self addChild:bg4 z:0 parallaxRatio:cloudSpeed2 positionOffset:topOffset];
    [self addChild:bg5 z:0 parallaxRatio:cloudSpeed3 positionOffset:topOffset];
    }
    return self;
}

@end
