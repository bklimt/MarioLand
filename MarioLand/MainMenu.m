//
//  MainMenu.m
//  MarioLand
//
//  Created by Mac Book on 9/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"


@implementation MainMenu

+(id)scene {
    CCScene *menu = [CCScene node];
    CCLayer* layer = [MainMenu node];
    CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(0, 120, 120, 120)];
    [menu addChild:colorLayer z:-4];
    [menu addChild:layer];
    return menu;
}

-(id)init {
    
    if (self = [super init]) {
        
        CCSprite *menubg = [CCSprite spriteWithFile:@"menubg.png"];
        [self addChild:menubg];
        menubg.position = ccp(-130,-40);
        menubg.anchorPoint = ccp(0,0);
        menubg.blendFunc = (ccBlendFunc){GL_OES_element_index_uint, GL_LUMINANCE_ALPHA};

        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CCLayer *pageOne = [[CCLayer alloc] init];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Menu" fontName:@"Delfino" fontSize:32];
        label.color = ccc3(0, 0, 0);
        label.position =  ccp( screenSize.width /2 , screenSize.height/2 );
        [pageOne addChild:label];
        CCLayer *pageTwo = [[CCLayer alloc] init];
        CCLabelTTF *tlabel = [CCLabelTTF labelWithString:@"Level 1" fontName:@"Delfino" fontSize:32];
        tlabel.color = ccc3(0,0,0);
        CCMenuItemLabel *titem = [CCMenuItemLabel itemWithLabel:tlabel target:self selector:@selector(testCallback:)];
        CCMenu *menu = [CCMenu menuWithItems: titem, nil];
        menu.position = ccp(screenSize.width/2, screenSize.height/2);
        [pageTwo addChild:menu];
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:[NSMutableArray arrayWithObjects: pageOne,pageTwo,nil] widthOffset: 230];
        [self addChild:scroller];
        
        
        
    }

    return self;
}

-(void)testCallback:(id)sender {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
}


@end
