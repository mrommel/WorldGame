//
//  GraphAxisRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphChartAxis.h"

@interface GraphAxisRenderer : NSObject

// properties
@property (nonatomic) GraphChartAxis *axis;
@property (nonatomic) UIColor* backgroundColor;

// methods
- (instancetype)initWithAxis:(GraphChartAxis *)axis;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end