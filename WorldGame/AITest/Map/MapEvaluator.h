//
//  MapEvaluator.h
//  AITest
//
//  Created by Michael Rommel on 08.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Map;
@class Plot;

/*!
 
 */
@interface SiteEvaluator : NSObject

- (instancetype)init;

/// Retrieve the relative fertility of this plot (alone)
- (NSInteger)plotFertilityValueForPlot:(Plot *)plot;

@end

/*!
 
 */
@interface SiteEvaluatorForStart : SiteEvaluator

- (instancetype)init;

@end

/*!
 
 */
@interface StartPositioner : NSObject

- (instancetype)initWithMap:(Map *)map andSiteEvaluator:(SiteEvaluatorForStart *)siteEvaluator;

- (NSArray *)findStartPositionsForPlayers:(NSInteger)numberOfPlayers;

@end
