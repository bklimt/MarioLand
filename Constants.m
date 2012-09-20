//
//  Constants.m
//  MarioLand
//
//  Created by Nick Soto on 9/20/12.
//
//

#import "Constants.h"

@implementation Constants

+(CGSize)screenSize {
    return [[CCDirector sharedDirector] winSize];
}

+(CGFloat)screenTotalWidth {
    return [[CCDirector sharedDirector] winSize].width;
}

+(CGFloat)screenTotalHeight {
    return [[CCDirector sharedDirector] winSize].height;
}

+(CGFloat)playerStartingPosX {
    return [[CCDirector sharedDirector] winSize].width / 2;
}

+(CGFloat)playerStartingPosY {
    return [[CCDirector sharedDirector] winSize].height / 6;
}

+(CGPoint)playerStartingPos {
    return CGPointMake([[CCDirector sharedDirector] winSize].width / 2, [[CCDirector sharedDirector] winSize].height / 6);
}

+(NSString*)pathToArchivedGame {
    NSString *localPath = @"Documents/gamearchive";
    return [NSHomeDirectory() stringByAppendingPathComponent:localPath];
}

@end
