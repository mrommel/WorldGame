//
//  GraphChartLineRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphRenderer.h"
#import "GraphChartRenderer.h"
#import "GraphData.h"
#import "GraphChartAxis.h"
#import <UIKit/UIKit.h>

@interface GraphChartLineRenderer : GraphRenderer<GraphChartRenderer>

@property (nonatomic) GraphData *data;
@property (nonatomic) UIColor *backgroundColor;

- (instancetype)initWithGraphData:(GraphData *)data andXAxis:(GraphChartAxis *)xaxis andYAxis:(GraphChartAxis *)yaxis;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end
