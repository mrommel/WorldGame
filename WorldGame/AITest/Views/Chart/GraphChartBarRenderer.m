//
//  GraphChartBarRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 05.10.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartBarRenderer.h"

#import "GraphDataEntry.h"

@interface GraphChartBarRenderer()

@property (nonatomic) GraphChartAxis *xAxis;
@property (nonatomic) GraphChartAxis *yAxis;
@property (atomic) CGFloat _animationProgress; // 0..1

@end

@implementation GraphChartBarRenderer

- (instancetype)initWithGraphData:(GraphData *)data andXAxis:(GraphChartAxis *)xAxis andYAxis:(GraphChartAxis *)yAxis
{
    self = [super init];
    
    if (self) {
        self.data = data;
        self.xAxis = xAxis;
        self.yAxis = yAxis;
        self._animationProgress = 1.0;
        self.lineColor = [UIColor whiteColor];
        self.fillColor = [UIColor redColor];
    }
    
    return self;
}

- (void)setAnimationProgress:(CGFloat)animationProgress
{
    self._animationProgress = animationProgress;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGFloat scale = (CGFloat)(self.data.values.count - 1) / (CGFloat)self.data.values.count;
    CGFloat graphWidth = rect.size.width * scale;
    CGFloat graphHeight = rect.size.height;
    CGFloat barWidth = (rect.size.width * scale) / self.data.values.count;
    
    for (int i = 0; i < self.data.values.count; i++) {
        GraphDataEntry *dataEntry = [self.data.values objectAtIndex:i];
        CGFloat x = [self.xAxis scaleValue:i];
        CGFloat y = [self.yAxis scaleValue:[dataEntry.value floatValue]] * self._animationProgress;
        
        CGRect rectangle = CGRectMake(rect.origin.x + x * graphWidth, rect.origin.y + (1.0 - y) * graphHeight, barWidth, rect.size.height - (1.0 - y) * graphHeight);
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        CGContextFillRect(ctx, rectangle);
        CGContextStrokeRect(ctx, rectangle);
    }
}

@end
