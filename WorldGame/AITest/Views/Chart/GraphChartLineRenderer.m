//
//  GraphChartLineRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartLineRenderer.h"

#import "GraphDataEntry.h"

#define SQR(x) ((x) * (x))

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
    // unsmoothed line
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
    
    // smoothed line
    CGMutablePathRef smoothedPath = CGPathCreateMutable();
    
    dataEntry = [self.data.values objectAtIndex:0];
    x = [self.xAxis scaleValue:0];
    y = [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress;
    
    CGPathMoveToPoint(smoothedPath, nil, rect.origin.x + x * graphWidth, rect.origin.y + (1.0 - y ) * graphHeight);
    
    // iterate for each x pixel
    for (int rx = 0; rx < graphWidth; rx++) {
        x = rx;
        
        int idx0 = ((CGFloat)rx / graphWidth) * [self.data.values count];
        int idx1 = MIN(idx0 + 1, (int)[self.data.values count] - 1);
        
        CGFloat ratio = 1.0 - SQR(( ((CGFloat)rx / graphWidth) - ((CGFloat)idx0 / [self.data.values count]) ) * (CGFloat)[self.data.values count]);
        NSLog(@"%d => %d / %.2f", idx0, idx1, ratio);
        GraphDataEntry *dataEntry1 = [self.data.values objectAtIndex:idx0];
        GraphDataEntry *dataEntry2 = [self.data.values objectAtIndex:idx1];
        CGFloat mixedValue = [self.yAxis scaleValue:[dataEntry1.value floatValue]] * ratio + [self.yAxis scaleValue:[dataEntry2.value floatValue]] * (1.0  - ratio);
        y = mixedValue * self._animationProgress;
        CGPathAddLineToPoint(smoothedPath, NULL, rect.origin.x + x, rect.origin.y + (1.0 - y ) * graphHeight);
    }
    
    CGContextAddPath(ctx, smoothedPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(smoothedPath);
}

@end
