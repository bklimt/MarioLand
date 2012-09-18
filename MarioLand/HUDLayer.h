//
//  HUDLayer.h
//  MarioLand
//
//  Created by Mac Book on 8/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedBase.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "MenuButton.h"

SneakyJoystick* leftJoystick;
SneakyButton* firstButton;
MenuButton* menuButton;

@interface HUDLayer : CCLayer {
}

-(void)initJoystick;
-(void)initFirstButton;
-(void)initMenuButton;

@end
