//
//  GraphChartLineRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartLineRenderer.h"

#import "GraphDataEntry.h"

static CGFloat const kLineSmoothness = 0.1f;

@interface GraphChartLineRenderer()

@property (nonatomic) GraphChartAxis *xAxis;
@property (nonatomic) GraphChartAxis *yAxis;
@property (atomic) CGFloat _animationProgress; // 0..1

@end

@implementation GraphChartLineRenderer

- (instancetype)initWithGraphData:(GraphData *)data andXAxis:(GraphChartAxis *)xAxis andYAxis:(GraphChartAxis *)yAxis
{
    self = [super init];
    
    if (self) {
        self.data = data;
        self.xAxis = xAxis;
        self.yAxis = yAxis;
        self._animationProgress = 1.0;
        self.lineColor = [UIColor whiteColor];
        self.smoothing = GraphChartLineSmoothingDefault;
    }
    
    return self;
}

- (void)setAnimationProgress:(CGFloat)animationProgress
{
    self._animationProgress = animationProgress;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    if (self.smoothing == GraphChartLineSmoothingDefault ||
        self.smoothing == GraphChartLineSmoothingNone) {
        // unsmoothed line
        [self drawUnsmoothedWithContext:ctx andCanvasRect:rect];
    } else if (self.smoothing == GraphChartLineSmoothingAppealling) {
        // smoothed line
        [self drawSmoothedWithContext:ctx andCanvasRect:rect];
    }
}

- (void)drawUnsmoothedWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGMutablePathRef unsmoothedPath = CGPathCreateMutable();
    
    CGFloat graphWidth = rect.size.width;
    CGFloat graphHeight = rect.size.height;
    
    GraphDataEntry *dataEntry = [self.data.values objectAtIndex:0];
    CGFloat x = [self.xAxis scaleValue:0];
    CGFloat y = [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress;
    
    CGPathMoveToPoint(unsmoothedPath, nil, rect.origin.x + x * graphWidth, rect.origin.y + (1.0 - y ) * graphHeight);
    
    for (int i = 1; i < self.data.values.count; i++) {
        dataEntry = [self.data.values objectAtIndex:i];
        x = [self.xAxis scaleValue:i];
        y = [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress;
        
        CGPathAddLineToPoint(unsmoothedPath, NULL, rect.origin.x + x * graphWidth, rect.origin.y + (1.0 - y ) * graphHeight);
    }
    
    CGContextAddPath(ctx, unsmoothedPath);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(unsmoothedPath);
}

- (void)drawSmoothedWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGMutablePathRef smoothedPath = CGPathCreateMutable();
    
    CGFloat graphWidth = rect.size.width;
    CGFloat graphHeight = rect.size.height;
    
    CGPathMoveToPoint(smoothedPath, nil, rect.origin.x, rect.origin.y + graphHeight);
    
    GraphDataEntry *dataEntry = [self.data.values firstObject];
    
    CGPoint prePreviousPoint = CGPointMake([self.xAxis scaleValue:0], [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress);
    CGPoint previousPoint = CGPointMake([self.xAxis scaleValue:0], [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress);
    CGPoint currentPoint = CGPointMake([self.xAxis scaleValue:0], [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress);
    CGPoint nextPoint = CGPointZero;
    
    for (int i = 1; i < self.data.values.count; i++) {
        // limit
        if (i < self.data.values.count - 1) {
            // get next value
            dataEntry = [self.data.values objectAtIndex:i + 1];
            nextPoint = CGPointMake([self.xAxis scaleValue:i + 1], [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress);
        } else {
            nextPoint = currentPoint;
        }
        
        // Calculate control points.
        CGFloat firstDiffX = (currentPoint.x - prePreviousPoint.x);
        CGFloat firstDiffY = (currentPoint.y - prePreviousPoint.y);
        CGFloat secondDiffX = (nextPoint.x - previousPoint.x);
        CGFloat secondDiffY = (nextPoint.y - previousPoint.y);
        CGFloat firstControlPointX = previousPoint.x + (kLineSmoothness * firstDiffX);
        CGFloat firstControlPointY = previousPoint.y + (kLineSmoothness * firstDiffY);
        CGFloat secondControlPointX = currentPoint.x - (kLineSmoothness * secondDiffX);
        CGFloat secondControlPointY = currentPoint.y - (kLineSmoothness * secondDiffY);
        
        // Draw the curve rect.origin.y + (1.0 - y ) * graphHeight
        CGPathAddCurveToPoint(smoothedPath, nil,
                              rect.origin.x + firstControlPointX * graphWidth, rect.origin.y + (1.0 - firstControlPointY ) * graphHeight,
                              rect.origin.x + secondControlPointX * graphWidth, rect.origin.y + (1.0 - secondControlPointY ) * graphHeight,
                              rect.origin.x + currentPoint.x * graphWidth, rect.origin.y + (1.0 - currentPoint.y ) * graphHeight);
        
        prePreviousPoint = previousPoint;
        previousPoint = currentPoint;
        currentPoint = nextPoint;
    }
    
    CGContextAddPath(ctx, smoothedPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(smoothedPath);
}

@end
