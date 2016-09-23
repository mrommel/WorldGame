//
//  GraphChartLineRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartLineRenderer.h"

@implementation GraphChartLineRenderer

- (instancetype)initWithGraphData:(GraphData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGPathRelease(path);
    
    
    /*CGMutablePathRef path = CGPathCreateMutable();
     
     NSInteger values = [self.data.values count];
     CGFloat graphWidth = rect.size.width;
     CGFloat graphHeight = rect.size.height;
     
     CGPathMoveToPoint(path, nil, BU_HALF, BU_HALF + (1.0f - [[self.data.values firstObject] floatValue]) * graphHeight);
     
     for (int i = 1; i < self.values.count; i++) {
     CGPathAddLineToPoint(path, NULL, BU_HALF + ((float)i / (float)self.values.count) * graphWidth, BU_HALF + (1.0f - [[self.values objectAtIndex:i] floatValue]) * graphHeight);
     }
     
     CGContextAddPath(ctx, path);
     CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
     CGContextStrokePath(ctx);
     
     CGPathRelease(path);*/
}

@end