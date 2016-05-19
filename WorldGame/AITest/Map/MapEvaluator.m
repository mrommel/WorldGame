//
//  MapEvaluator.m
//  AITest
//
//  Created by Michael Rommel on 08.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MapEvaluator.h"

#import "Plot.h"

@implementation SiteEvaluator

- (instancetype)init
{
    self = [super init];
    
    return self;
}

/// Retrieve the relative fertility of this plot (alone)
- (NSInteger)plotFertilityValueForPlot:(Plot *)plot
{
    NSInteger rtnValue = 0;
    
    if (![plot isOcean]) {
        rtnValue += [self computeFoodValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeProductionValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeGoldValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeScienceValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeTradeableResourceValueForPlot:plot andPlayer:nil];
    }
    
    if (rtnValue < 0) {
        rtnValue = 0;
    }
    
    return rtnValue;
}

- (NSInteger)computeFoodValueForPlot:(Plot *)plot andPlayer:(Player *)player
{
    NSInteger rtnValue = 0;
    
    // From tile yield
    rtnValue += [plot calculateNatureYield:YieldTypeFood forPlayer:player];
    
    // From resource
    /*ResourceTypes eResource = [plot resourceTypeForPlayer:player];
    
    if (eResource != NO_RESOURCE)
    {
        rtnValue += GC.getResourceInfo(eResource)->getYieldChange(YIELD_FOOD);
        
        CvImprovementEntry *pImprovement = GC.GetGameImprovements()->GetImprovementForResource(eResource);
        if (pImprovement)
        {
            rtnValue += pImprovement->GetImprovementResourceYield(eResource, YIELD_FOOD);
        }
    }*/
    
    return rtnValue; // * m_iFlavorMultiplier[YIELD_FOOD];
}

@end
