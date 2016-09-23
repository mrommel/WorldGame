//
//  GraphChartAxis.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphData.h"

typedef NS_ENUM(NSInteger, GraphChartAxisOrientation) {
    GraphChartAxisOrientationVertical,  // | y
    GraphChartAxisOrientationHorizontal // - x
};

typedef NS_ENUM(NSInteger, GraphChartAxisPosition) {
    GraphChartAxisPositionBottom,  // x
    GraphChartAxisPositionLeft, // y
    GraphChartAxisPositionRight // y
};

@interface GraphChartAxis : NSObject

@property (nonatomic) GraphChartAxisOrientation orientation;
@property (nonatomic) GraphChartAxisPosition position;

@property (atomic) NSInteger numberOfTicks;
@property (atomic) CGFloat startValue;
@property (atomic) CGFloat endValue;
@property (atomic) CGFloat tickValue;

- (instancetype)initWithOrientation:(GraphChartAxisOrientation)orientation andPosition:(GraphChartAxisPosition)position;

- (void)calculateWithGraphData:(GraphData *)data;

@end
