//
//  GraphChartAxis.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartAxis.h"

#import "GraphData.h"
#import "GraphDataEntry.h"

@interface GraphChartAxis()

@end

@implementation GraphChartAxis

- (instancetype)initWithOrientation:(GraphChartAxisOrientation)orientation andPosition:(GraphChartAxisPosition)position
{
    self = [super init];
    
    if (self) {
        self.orientation = orientation;
        self.position = position;
        
        self.numberOfTicks = 10;
    }
    
    return self;
}

- (void)calculateWithGraphData:(GraphData *)data
{
    CGFloat minimumValue = CGFLOAT_MAX;
    CGFloat maximumValue = CGFLOAT_MIN;
    
    for (GraphDataEntry *entry in data.values) {
        maximumValue = MAX(maximumValue, [entry.value floatValue]);
        minimumValue = MIN(minimumValue, [entry.value floatValue]);
    }
    
    CGFloat width = maximumValue - minimumValue;
    if (width == 0.0) {
        self.tickValue = 0;
        self.startValue = minimumValue;
        self.endValue = maximumValue;
    } else {
        CGFloat niceRange = [self calculateNiceNumberFromValue:width];
        self.tickValue = [self calculateNiceNumberFromValue:(niceRange / (self.numberOfTicks - 1)) andRound:YES];
        self.startValue = floor(minimumValue / niceRange) * niceRange;
        self.endValue = ceil(maximumValue / niceRange) * niceRange;
    }
}

- (CGFloat)calculateNiceNumberFromValue:(CGFloat)value
{
    return [self calculateNiceNumberFromValue:value andRound:NO];
}

- (CGFloat)calculateNiceNumberFromValue:(CGFloat)value andRound:(BOOL)round
{
    CGFloat exponent = (int)floor(log10(value));
    CGFloat fraction = value / pow(10, exponent);
    CGFloat niceFraction = 10.0;
    
    if (round) {
        if (fraction < 1.5) {
            niceFraction = 1.0;
        } else if (fraction < 3.0) {
            niceFraction = 2.0;
        } else if (fraction < 7.0) {
            niceFraction = 5.0;
        }
    } else {
        if (fraction <= 1) {
            niceFraction = 1.0;
        } else if (fraction <= 2.0) {
            niceFraction = 2.0;
        } else if (fraction <= 5.0) {
            niceFraction = 5.0;
        }
    }
                            
    return niceFraction * pow(10, exponent);
}

@end
