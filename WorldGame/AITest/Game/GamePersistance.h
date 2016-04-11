//
//  GamePersistance.h
//  AITest
//
//  Created by Michael Rommel on 08.04.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GamePersistance : NSObject

+ (NSMutableArray *)loadGames;
+ (NSString *)nextGamePath;

@end
