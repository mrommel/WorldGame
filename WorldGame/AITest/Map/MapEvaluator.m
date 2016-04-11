//
//  MapEvaluator.m
//  AITest
//
//  Created by Michael Rommel on 08.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MapEvaluator.h"

#import "Plot.h"

@interface MapEvaluator()

@property (nonatomic) Map *map;

@end

@implementation MapEvaluator

- (instancetype)initWithMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.map = map;
    }
    
    return self;
}

- (int)valueForPlot:(Plot *)plot
{
    return 0;
}

@end
