//
//  CurrentGameStats.h
//  MarioLand
//
//  Created by Mac Book on 9/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

int hits;
int points;
int secondsPlayed;
CGPoint currentPlayerPoint;
bool userSelectedResumeGame;

@interface CurrentGameStats : NSObject {

}

@property (nonatomic) CGPoint currentPlayerPoint;
@property (nonatomic, assign) int hits;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) int secondsPlayed;
@property (nonatomic) bool userSelectedResumeGame;

@end
