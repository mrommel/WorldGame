//
//  PlotEconomy.h
//  WorldGame
//
//  Created by Michael Rommel on 03.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plot;

/*!
 
 */
@interface PlotEconomy : NSObject

@property (atomic) NSInteger peoplePeasants; // in hundreds
@property (atomic) NSInteger peopleWorkers; // in hundreds

@property (atomic) NSInteger foodAmount;
@property (atomic) NSInteger materialAmount;
@property (atomic) NSInteger goodsAmount;
@property (atomic) NSInteger luxuryAmount;

- (instancetype)initWithPlot:(Plot *)plot;

- (NSInteger)foodProduction;
- (NSInteger)foodConsumption;

- (NSInteger)materialProduction;
- (NSInteger)materialConsumption;

@end
