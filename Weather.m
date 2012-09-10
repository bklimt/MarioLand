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
    bg1 = [CCSprite spriteWithFile:@"trees-background.png"];
    bg1.anchorPoint = CGPointMake(0, 0);
    bg2 = [CCSprite spriteWithFile:@"trees2-background.png"];
    bg2.anchorPoint = CGPointMake(0, 0);
    bg3 = [CCSprite spriteWithFile:@"trees-background.png"];
    bg3.anchorPoint = CGPointMake(0, 0);
    bg4 = [CCSprite spriteWithFile:@"trees-background.png"];
    bg4.anchorPoint = CGPointMake(0, 0);
    bg4.position=ccp(300,0);
    bg5 = [CCSprite spriteWithFile:@"trees2-background.png"];
    bg5.anchorPoint = CGPointMake(0, 0);
    bg5.position=ccp(300,0);
    
    CGPoint cloudSpeed = ccp(0.03, 0.03);
    CGPoint cloudSpeed2 = ccp(0.05, 0.05);
    CGPoint cloudSpeed3 = ccp(0.02, 0.02);
    CGPoint topOffset = CGPointMake([CCDirector sharedDirector].winSize.height / 6, 0);
    CGPoint midOffset = CGPointMake(-30,0);

    [self addChild:bg1 z:0 parallaxRatio:cloudSpeed3 positionOffset:midOffset];
    [self addChild:bg2 z:0 parallaxRatio:cloudSpeed positionOffset:midOffset];
    [self addChild:bg3 z:0 parallaxRatio:cloudSpeed2 positionOffset:topOffset];
    [self addChild:bg4 z:0 parallaxRatio:cloudSpeed2 positionOffset:topOffset];
    [self addChild:bg5 z:0 parallaxRatio:cloudSpeed2 positionOffset:topOffset];
    }
    return self;
}

@end
