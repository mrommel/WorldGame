//
//  RelationsNetwork.h
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Policy.h"
#import "Player.h"

@class Simulation;

/*!
 class that holds all simulations
 */
@interface RelationsNetwork : NSObject

@property (nonatomic) Simulation *birthRate;
@property (nonatomic) Simulation *deathRate;

- (instancetype)init;

- (void)setPlayer:(Player *)player withEvent:(EventType)eventType;

- (void)turn;

@end
