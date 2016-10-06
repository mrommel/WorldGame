//
//  GraphChartPieRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 06.10.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GraphRenderer.h"
#import "GraphChartRenderer.h"
#import "GraphData.h"

@interface GraphChartPieRenderer : GraphRenderer<GraphChartRenderer>

@property (nonatomic) GraphData *data;
@property (nonatomic) UIColor *lineColor;
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *textColor;

@property (nonatomic) BOOL showLabels;

- (instancetype)initWithGraphData:(GraphData *)data;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

- (void)setAnimationProgress:(CGFloat)animationProgress;

@end
