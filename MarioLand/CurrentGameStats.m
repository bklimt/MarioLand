//
//  CurrentGameStats.m
//  MarioLand
//
//  Created by Mac Book on 9/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CurrentGameStats.h"


@implementation CurrentGameStats

@synthesize currentGameStats;


+(NSMutableDictionary*)returnNewGameStats{
    currentGameStats = [NSMutableDictionary new];
    [currentGameStats setValue:@"0" forKey:@"pointsAccumulated"];
    [currentGameStats setValue:@"0" forKey:@"hitsAccumulated"];
    [currentGameStats setValue:@"0" forKey:@"secondsPlayed"];
    [currentGameStats setValue:@"0" forKey:@"currentGameStats"];
    return currentGameStats;
}

@end
