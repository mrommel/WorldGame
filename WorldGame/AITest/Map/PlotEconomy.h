//
//  PlotEconomy.h
//  WorldGame
//
//  Created by Michael Rommel on 03.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Plot;
@class PlotEconomy;

@protocol PlotEconomyDelegate <NSObject>

- (void)economy:(PlotEconomy *)economy handleTooLittleSoilForPeasants:(NSInteger)peasants;
- (void)economy:(PlotEconomy *)economy handleLittleFood:(NSInteger)foodRemaining;
- (void)economy:(PlotEconomy *)economy handleTooLittleFood:(NSInteger)foodRemaining;

@end

/*!
 
 */
@interface PlotEconomy : NSObject

@property (atomic) NSInteger peoplePeasants; // in thousands
@property (atomic) NSInteger peopleWorkers; // in thousands

@property (atomic) NSInteger foodAmount;
@property (atomic) NSInteger materialAmount;
@property (atomic) NSInteger goodsAmount;
@property (atomic) NSInteger luxuryAmount;

@property (nonatomic) id<PlotEconomyDelegate> delegate;

- (instancetype)initWithPlot:(Plot *)plot;

- (void)turn;

- (NSInteger)foodProduction;
- (NSInteger)foodConsumption;

- (NSInteger)materialProduction;
- (NSInteger)materialConsumption;

@end
