//
//  ChartView.m
//  AITest
//
//  Created by Michael Rommel on 07.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "ChartView.h"

#import "UIConstants.h"

@interface ChartView()

@property (nonatomic, setter=setValues:) NSArray *values;

@end

@implementation ChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextFillRect(ctx, self.bounds);
    
    if (!self.values) {
        return;
    }
    
    if (self.values.count < 2) {
        return;
    }
    
    NSLog(@"array values: %@", self.values);
    
    [self drawAxesWithContext:ctx];
    
    [self drawValuesWithContext:ctx];
}

- (void)drawAxesWithContext:(CGContextRef)ctx
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, nil, BU_HALF, self.bounds.size.height - BU_HALF);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width - BU, self.bounds.size.height - BU_HALF);
    
    CGPathCloseSubpath(path);
    
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}

- (void)drawValuesWithContext:(CGContextRef)ctx
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    float graphHeight = self.bounds.size.height - BU;
    float graphWidth = self.bounds.size.width - BU;
    
    CGPathMoveToPoint(path, nil, BU_HALF, BU_HALF + (1.0f - [[self.values firstObject] floatValue]) * graphHeight);
    
    for (int i = 1; i < self.values.count; i++) {
        CGPathAddLineToPoint(path, NULL, BU_HALF + ((float)i / (float)self.values.count) * graphWidth, BU_HALF + (1.0f - [[self.values objectAtIndex:i] floatValue]) * graphHeight);
    }
    
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}

- (void)setValues:(NSArray *)values
{
    _values = values;
    
    [self setNeedsDisplay];
}

@end
