//
//  MenuButton.m
//  MarioLand
//
//  Created by Nick Soto on 9/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuButton.h"


@implementation MenuButton
@synthesize overlay;

- (void) onEnterTransitionDidFinish
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

-(id)initWithRect:(CGRect)rect{
	self = [super init];
	if(self){
		bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
		center = CGPointMake(rect.size.width/2, rect.size.height/2);
        position_ = rect.origin;
	}
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = [self convertToNodeSpace:location];
	if(fabsf(location.x) > 30 || fabsf(location.y) > 30){
		return NO;
	}else{
        [self openGameMenu];
        return YES;
        }
        return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];
	location = [self convertToNodeSpace:location];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
}

-(void)openGameMenu {
    
//    if ([VGVunglePub adIsAvailable] == TRUE) {
//        UIViewController* myView = [[UIViewController alloc]init];
//        [myView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//        [VGVunglePub playModalAd:myView animated:FALSE];
//    }
//    else {
//        NSLog(@"NO AD YET");
//    }
    
    isPaused ^= YES;
    [self toggleGameOverlay];
    return (isPaused == YES) ? [[CCDirector sharedDirector] pause] : [[CCDirector sharedDirector] resume];

}

-(void)toggleGameOverlay {
    self.overlay = [CCSprite spriteWithFile:@"bluebox.png"];
    self.overlay.opacity = 200;
    self.overlay.position = CGPointMake(240, 160);
    if (self.overlay != nil) {
    (isPaused == NO) ? [self.parent removeChildByTag:10 cleanup:false] : [self.parent addChild:self.overlay z:20 tag:10];
    }
    
    CCMenuItem *saveButton = [CCMenuItemImage
                                itemWithNormalImage:@"toad.png" selectedImage:@"toad.png"
                                target:self selector:@selector(saveButtonTapped:)];
    saveButton.position = ccp(240, 160);
    CCLabelTTF* labelForMenu = [CCLabelTTF labelWithString:@"Save" fontName:@"Delfino" fontSize:18];
    labelForMenu.anchorPoint = ccp(0,0);
    labelForMenu.position = ccp(32, -20);
    [saveButton addChild:labelForMenu];
    CCMenu *PauseMenu = [CCMenu menuWithItems:saveButton, nil];
    PauseMenu.position = CGPointZero;
    [self.parent addChild:PauseMenu z:30];
}

-(void)saveButtonTapped:(id)sender {
    NSLog(@"got to save button.");
    SavedGameState* newSavedState = [SavedGameState new];
    NSString *localPath = @"Documents/gamearchive";
    NSString *fullPath = [NSHomeDirectory() stringByAppendingPathComponent:localPath];
    [NSKeyedArchiver archiveRootObject:newSavedState toFile:fullPath];
}

@end
