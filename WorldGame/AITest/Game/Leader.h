//
//  Leader.h
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Flavor.h"

@class Civilization;

/*!
 class that holds a leader
 */
@interface Leader : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *civilizationName;

@property (nonatomic) NSMutableArray *flavors;

- (instancetype)initWithName:(NSString *)name andCivilizationName:(NSString *)civilizationName;

- (void)addFlavorWithType:(FlavorType)flavorType andValue:(int)flavorValue;

@end

/*!
 class that provides leader objects
 */
@interface LeaderProvider : NSObject

+ (LeaderProvider *)sharedInstance;

- (Leader *)randomLeaderForCivilizationName:(NSString *)civilizationName;

@end