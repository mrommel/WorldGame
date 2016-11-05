//
//  AISimulation.h
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AISimulationProperty.h"

@interface AISimulation : NSObject

@property (nonatomic) AISimulationProperty *foodSafety;
@property (nonatomic) AISimulationProperty *soilQuality;
@property (nonatomic) AISimulationProperty *health;

- (instancetype)init;

- (void)calculate;

- (NSInteger)sampleCount;

@end
