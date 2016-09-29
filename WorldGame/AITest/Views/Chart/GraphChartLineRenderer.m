//
//  GraphChartLineRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartLineRenderer.h"

#import "GraphDataEntry.h"

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
    }
    
    return self;
}

- (void)setAnimationProgress:(CGFloat)animationProgress
{
    self._animationProgress = animationProgress;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    // line
    CGMutablePathRef path = CGPathCreateMutable();
     
    CGFloat graphWidth = rect.size.width;
    CGFloat graphHeight = rect.size.height;
    
    GraphDataEntry *dataEntry = [self.data.values objectAtIndex:0];
    CGFloat x = [self.xAxis scaleValue:0];
    CGFloat y = [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress;
    //NSLog(@"f(%.2f) = %.2f  ==> (%.2f, %.2f)", 0.0, [dataEntry.value floatValue], x, y);
    
    CGPathMoveToPoint(path, nil, rect.origin.x + x * graphWidth, rect.origin.y + (1.0 - y ) * graphHeight);
     
    for (int i = 1; i < self.data.values.count; i++) {
        dataEntry = [self.data.values objectAtIndex:i];
        x = [self.xAxis scaleValue:i] / (self.data.values.count - 1);
        y = [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress;
        //NSLog(@"f(%.2f) = %.2f  ==> (%.2f, %.2f)", (CGFloat)i, [dataEntry.value floatValue], x, y);
         
        CGPathAddLineToPoint(path, NULL, rect.origin.x + x * graphWidth, rect.origin.y + (1.0 - y ) * graphHeight);
    }
     
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
     
    CGPathRelease(path);
}

@end
