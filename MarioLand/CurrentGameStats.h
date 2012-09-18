//
//  CurrentGameStats.h
//  MarioLand
//
//  Created by Mac Book on 9/14/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

NSMutableDictionary* currentGameStats;

@interface CurrentGameStats : NSObject {
    
}
@property (nonatomic, retain) NSMutableDictionary* currentGameStats;

+(NSMutableDictionary*)returnNewGameStats;

@end
