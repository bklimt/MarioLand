//
//  CurrentGameStats.h
//  MarioLand
//
//  Created by Mac Book on 9/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


int pointsAccumulated;
int hitsAccumlated;
int secondsPlayed;

@interface CurrentGameStats : NSObject {
    
}
@property (nonatomic) int pointsAccumulated;
@property (nonatomic) int hitsAccumulated;
@property (nonatomic) int secondsPlayed;

@end
