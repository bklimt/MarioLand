//
//  Constants.h
//  MarioLand
//
//  Created by Nick Soto on 9/20/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Constants : NSObject

+(CGSize)screenSize;
+(CGPoint)playerStartingPos;
+(CGFloat)playerStartingPosX;
+(CGFloat)playerStartingPosY;
+(CGFloat)screenTotalHeight;
+(CGFloat)screenTotalWidth;
+(NSString*)pathToArchivedGame;


@end
