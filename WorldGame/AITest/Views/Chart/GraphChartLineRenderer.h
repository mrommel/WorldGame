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

/*!
 *
 */
typedef NS_ENUM(NSInteger, GraphChartLineSmoothing) {
    GraphChartLineSmoothingDefault = 0,
    GraphChartLineSmoothingNone = 0,
    GraphChartLineSmoothingAppealling = 1
};

@interface GraphChartLineRenderer : GraphRenderer<GraphChartRenderer>

@property (nonatomic) GraphData *data;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) UIColor *fillColor;
@property (atomic) GraphChartLineSmoothing smoothing;

- (instancetype)initWithGraphData:(GraphData *)data andXAxis:(GraphChartAxis *)xaxis andYAxis:(GraphChartAxis *)yaxis;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

- (void)setAnimationProgress:(CGFloat)animationProgress;

@end
