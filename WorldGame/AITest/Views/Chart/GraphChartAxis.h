//
//  GraphChartAxis.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphData.h"
#import <CoreGraphics/CoreGraphics.h>

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
@property (atomic) CGFloat intervalValue;

- (instancetype)initWithOrientation:(GraphChartAxisOrientation)orientation andPosition:(GraphChartAxisPosition)position;

- (void)calculateWithGraphData:(GraphData *)data;

- (NSInteger)tickCount;

- (CGFloat)scaleValue:(CGFloat)value;

@end
