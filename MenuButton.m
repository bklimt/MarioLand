//
//  MenuButton.m
//  MarioLand
//
//  Created by Nick Soto on 9/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuButton.h"


@implementation MenuButton

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
    isPaused ^= YES;
    return (isPaused == NO) ? [[CCDirector sharedDirector] pause] : [[CCDirector sharedDirector] resume];
}

@end
