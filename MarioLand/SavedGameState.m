//
//  SavedGameState.m
//  MarioLand
//
//  Created by Nick Soto on 9/19/12.
//
//

#import "SavedGameState.h"
#import "CurrentGameStats.h"

@implementation SavedGameState

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeCGPoint:currentPlayerPoint forKey:@"playerPosition"];
    [aCoder encodeInt:points forKey:@"playerPoints"];
    [aCoder encodeInt:hits forKey:@"playerHits"];
    [aCoder encodeInt:secondsPlayed forKey:@"playerSecondsPlayed"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {        
        self.playerSavedPosition = [aDecoder decodeCGPointForKey:@"playerPosition"];
        self.playerSavedPoints = [aDecoder decodeIntForKey:@"playerPoints"];
        self.playerSavedHits = [aDecoder decodeIntForKey:@"playerHits"];
        self.playerSavedSecondsPlayed = [aDecoder decodeIntForKey:@"playerSecondsPlayed"];
    }
    
    return self;
}

@end