//
//  AISimulation.m
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AISimulation.h"

@interface AISimulation()

@property (atomic) NSInteger samples;

@end

@implementation AISimulation

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        // setup the properties
        self.foodSafety = [[AISimulationProperty alloc] initWithName:@"Food Safety" startingValue:0.8 andCategory:AISimulationCategoryProduction];
        
        //
        // Soil categories
        //
        // Very poor             0 - 18              brown
        // Poor                 18 - 35              red
        // Medium               35 - 55              orange
        // High                 55 - 75              yellow
        // Very High            75 - 100             green
        //
        // Sand                                 0 - 11
        // Sandy loam                          11 - 30
        // Heavy to clayey loam                31 - 50
        // Loam, partly with loess covering    51 - 70
        // Loam with loess covering            71 - 90
        // Loess                               91 -100
        //
        self.soilQuality = [[AISimulationProperty alloc] initWithName:@"Soil Quality" startingValue:0.7 andCategory:AISimulationCategoryStatic];
        
        //self.hygiene
        
        self.health = [[AISimulationProperty alloc] initWithName:@"Health" startingValue:0.8 andCategory:AISimulationCategoryPeople];
        // don't forget to add new properties to the calculate step too
        
        // add relations
        [self.soilQuality addStaticInputValue:0.7];
        [self.health addInputProperty:self.foodSafety withFormula:@"0.9*x"];
    }
    
    return self;
}

- (void)calculate
{
    [self.foodSafety calculate];
    [self.soilQuality calculate];
    [self.health calculate];
    
    self.samples++;
}

- (NSInteger)sampleCount
{
    return self.samples;
}

- (NSString *)description
{
    NSMutableString *str = [NSMutableString new];
    
    [str appendFormat:@"{ AISimulation, turns: %ld", (long)self.samples];
    [str appendString:@", properties: ["];
    [str appendString:[self.foodSafety description]];
    [str appendString:@", "];
    [str appendString:[self.soilQuality description]];
    [str appendString:@", "];
    [str appendString:[self.health description]];
    [str appendString:@"] }"];
    
    return str;
}

@end
