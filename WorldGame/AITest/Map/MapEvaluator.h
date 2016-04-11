//
//  MapEvaluator.h
//  AITest
//
//  Created by Michael Rommel on 08.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Map;

@interface MapEvaluator : NSObject

- (instancetype)initWithMap:(Map *)map;

/*- (int)plotFertilityValue(CvPlot *pPlot);
- (int)bestFoundValueForSpecificYield:(YieldType)yieldType;

// Each of these routines computes a number from 0 (no value) to 100 (best possible value)
- (int)computeFoodValue(CvPlot *pPlot, CvPlayer *pPlayer);
- (int)computeHappinessValue(CvPlot *pPlot, CvPlayer *pPlayer);
- (int)computeProductionValue(CvPlot *pPlot, CvPlayer *pPlayer);
- (int)computeGoldValue(CvPlot *pPlot, CvPlayer *pPlayer);
- (int)computeScienceValue(CvPlot *pPlot, CvPlayer *pPlayer);
- (int)computeTradeableResourceValue(CvPlot *pPlot, CvPlayer *pPlayer);
- (int)computeStrategicValue(CvPlot *pPlot, CvPlayer *pPlayer, int iPlotsFromCity);*/

@end
