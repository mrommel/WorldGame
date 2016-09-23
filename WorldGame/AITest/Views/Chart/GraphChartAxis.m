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

@implementation GraphChartAxis

- (instancetype)initWithOrientation:(GraphChartAxisOrientation)orientation andPosition:(GraphChartAxisPosition)position
{
    self = [super init];
    
    if (self) {
        self.orientation = orientation;
        self.position = position;
    }
    
    return self;
}

- (void)calculateWithGraphData:(GraphData *)data
{
    self.minimumValue = CGFLOAT_MAX;
    self.maximumValue = CGFLOAT_MIN;
    
    for (GraphDataEntry *entry in data.values) {
        self.maximumValue = MAX(self.maximumValue, [entry.value floatValue]);
        self.minimumValue = MIN(self.minimumValue, [entry.value floatValue]);
    }
}

@end
