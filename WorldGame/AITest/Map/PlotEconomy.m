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

- (NSInteger)foodProduction
{
    NSAssert([self.plot terrainData].acres >= self.peoplePeasants, @"It's not allowed to use more peasants than we have acres");
    
    return [self.plot terrainData].soil;
#warning please tweek here
}

- (NSInteger)foodConsumption
{
    return 0;
#warning please tweek here
}

@end
