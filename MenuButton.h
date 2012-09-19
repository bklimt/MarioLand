//
//  MenuButton.h
//  MarioLand
//
//  Created by Nick Soto on 9/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface MenuButton : CCNode <CCTargetedTouchDelegate> {
    CGPoint center;
	CGRect bounds;
    bool isPaused;
    CCSprite* overlay;
}

@property (nonatomic, retain) CCSprite* overlay;
-(id)initWithRect:(CGRect)rect;


@end
