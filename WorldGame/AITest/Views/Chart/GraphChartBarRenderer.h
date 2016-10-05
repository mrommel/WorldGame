//
//  GraphChartBarRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 05.10.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GraphRenderer.h"
#import "GraphChartRenderer.h"
#import "GraphData.h"
#import "GraphChartAxis.h"

@interface GraphChartBarRenderer : GraphRenderer<GraphChartRenderer>

@property (nonatomic) GraphData *data;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) UIColor *fillColor;

- (instancetype)initWithGraphData:(GraphData *)data andXAxis:(GraphChartAxis *)xaxis andYAxis:(GraphChartAxis *)yaxis;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

- (void)setAnimationProgress:(CGFloat)animationProgress;

@end
