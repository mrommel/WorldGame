//
//  AISimulation.h
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AISimulationProperty.h"
#import "AISimulationGroup.h"
#import "AISimulationInput.h"

@interface AISimulation : NSObject

@property (nonatomic) AISimulationProperty *foodSafety;
@property (nonatomic) AISimulationProperty *soilQuality;
@property (nonatomic) AISimulationProperty *health;
@property (nonatomic) AISimulationProperty *education;
@property (nonatomic) AISimulationProperty *externalAttraction;
@property (nonatomic) AISimulationProperty *poverty;
@property (nonatomic) AISimulationProperty *equality;
@property (nonatomic) AISimulationProperty *crimeRate;

@property (nonatomic) AISimulationInput *propertyTax;

@property (nonatomic) AISimulationGroup *all;
@property (nonatomic) AISimulationGroup *poor;
@property (nonatomic) AISimulationGroup *middle;
@property (nonatomic) AISimulationGroup *wealthy;

- (instancetype)init;

- (void)calculate;

- (NSInteger)sampleCount;

- (NSMutableArray *)voter;

@end
