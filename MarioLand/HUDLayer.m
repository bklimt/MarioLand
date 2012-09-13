//
//  HUDLayer.m
//  MarioLand
//
//  Created by Mac Book on 8/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer

-(void)initFirstButton {
    SneakyButtonSkinnedBase *firstButtonBase = [[SneakyButtonSkinnedBase alloc] init];
    firstButtonBase.defaultSprite = [CCSprite spriteWithFile:@"firstbutton.png"];
    firstButtonBase.defaultSprite.blendFunc = (ccBlendFunc){GL_ONE, GL_ONE};
    firstButtonBase.pressSprite = [CCSprite spriteWithFile:@"firstbutton-pressed.png"];
    firstButtonBase.pressSprite.blendFunc = (ccBlendFunc){GL_ONE, GL_ONE_MINUS_CONSTANT_ALPHA};
    firstButtonBase.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 120, 120)];
    firstButtonBase.position = ccp(450, 55);
    [self addChild:firstButtonBase];
    firstButton = [firstButtonBase.button retain];
}

-(void)initJoystick {
    
    SneakyJoystickSkinnedBase *joystickBase = [[SneakyJoystickSkinnedBase alloc] init];
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"joystick.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0, 0, 128, 128)];
    joystickBase.backgroundSprite.blendFunc = (ccBlendFunc){GL_ONE, GL_ONE};
    joystickBase.position = ccp(55, 55);
    [self addChild:joystickBase];
    leftJoystick = [joystickBase.joystick retain];
}

@end
