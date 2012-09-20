//
//  SavedGameState.h
//  MarioLand
//
//  Created by Nick Soto on 9/19/12.
//
//

#import <Foundation/Foundation.h>

@interface SavedGameState : NSObject <NSCoding>

@property (nonatomic) CGPoint playerSavedPosition;
@property (nonatomic) int playerSavedPoints;
@property (nonatomic) int playerSavedHits;
@property (nonatomic) int playerSavedSecondsPlayed;

@end
