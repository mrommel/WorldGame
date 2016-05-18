//
//  PlotEconomy.m
//  WorldGame
//
//  Created by Michael Rommel on 03.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "PlotEconomy.h"

#import "Plot.h"

@interface PlotEconomy()

@property (nonatomic) Plot *plot;

@end

@implementation PlotEconomy

- (instancetype)initWithPlot:(Plot *)plot
{
    self = [super init];
    
    if (self) {
        self.plot = plot;
    }
    
    return self;
}

- (void)turn
{
    CGFloat foodDelta = [self foodProduction] - [self foodConsumption];
    
    self.foodAmount += foodDelta;
    
    if (self.foodAmount < 0) {
        if (self.delegate) {
            [self.delegate economy:self handleTooLittleFood:self.foodAmount];
        }
    } else if (self.foodAmount < 10 && foodDelta < 0) {
        if (self.delegate) {
            [self.delegate economy:self handleLittleFood:self.foodAmount];
        }
    }
}

/*!
 city spot consumes acres
 
 there 36 acres per tile/plot
 */
- (NSInteger)acreConsumptionOfHouses
{
    switch (self.plot.populationState) {
        case PlotPopulationStateNomads:
            return 0;
        case PlotPopulationStateVillage:
            return 1;
        case PlotPopulationStateTown:
            return 5;
        case PlotPopulationStateCity:
            return 12;
        case PlotPopulationStateMetropol:
            return 24;
    }
    
    return 0;
}

/*!
 food production is a function of:
 - number of people (limited by number of acres)
 - soil quality
 - river (better soil + fishing as long as the city is not too big)
 - has tile ocean access (then we can do fishing)
 
 bonuses:
 - leaders
 
 penalties:
 - as the cities grow, the number of acres will decrease
 */
- (NSInteger)foodProduction
{
    NSAssert([self.plot terrainData].acres >= self.peoplePeasants, @"It's not allowed to use more peasants than we have acres");
    
    NSInteger availableAcres = [self.plot terrainData].acres - [self acreConsumptionOfHouses];
    NSInteger possiblePeasants = self.peoplePeasants;
    
    // It's not allowed to use more peasants than we have acres
    if (availableAcres < self.peoplePeasants) {
        if (self.delegate) {
            [self.delegate economy:self handleTooLittleSoilForPeasants:self.peoplePeasants];
        }
        
        // limit peasants
        possiblePeasants = availableAcres;
    }
    
    CGFloat soilQuality = [self.plot terrainData].soil + ([self.plot hasRiver] ? 2.0 : 0.0);
    
    return soilQuality * possiblePeasants + ([self.plot isCoastal] ? 2.0 : 0.0);
}

/*!
 food consumption is a function of:
 - number of people
 */
- (NSInteger)foodConsumption
{
    return self.plot.inhabitants;
#warning please tweek here
}

- (NSInteger)materialProduction
{
    return 0;
}

- (NSInteger)materialConsumption
{
    return 0;
}

@end
