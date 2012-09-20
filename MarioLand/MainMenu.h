//
//  MainMenu.h
//  MarioLand
//
//  Created by Mac Book on 9/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"

@interface MainMenu : CCLayer {
    CCScrollLayer *scroller;
    CCLayer *pageThree;
    CCLabelTTF *resumeGameLabel;
    NSMutableArray* menuLayers;
    NSMutableArray* menuItems;
}

@property (nonatomic, assign) CCScrollLayer* scroller;
@property (nonatomic, assign) CCLayer* pageThree;
@property (nonatomic, assign) CCLabelTTF* resumeGameLabel;

+(id)scene;

@end
