//
//  GoombaBasic.m
//  MarioLand
//
//  Created by Mac Book on 9/8/12.
//
//

#import "GoombaBasic.h"

@implementation GoombaBasic
@synthesize collided;

-(id) init {
    if (self = [super init]) {
        return [GoombaBasic spriteWithFile:@"goomba.png"];
    }
    return self;
}

@end
