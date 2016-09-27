//
//  GraphAxisRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphAxisRenderer.h"

#import "UIConstants.h"
#import "GraphTitleRenderer.h"
#import "GraphChartRenderer.h"
#import <UIKit/UIKit.h>

@interface GraphAxisRenderer()

@property (atomic) NSInteger intervals;

@end

@implementation GraphAxisRenderer

- (instancetype)initWithAxis:(GraphChartAxis *)axis
{
    self = [super init];
    
    if (self) {
        self.axis = axis;
        self.backgroundColor = [UIColor whiteColor];
        self.intervals = 3;
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    [self fillContext:ctx withRect:rect andColor:self.backgroundColor];
    
    switch (self.axis.position) {
        case GraphChartAxisPositionBottom: {
            
            // line
            [[UIColor grayColor] set];
            CGPathRef bottomLine = CGPathCreateMutable();
            
            CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y + BU_HALF);
            CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + BU_HALF);
            
            CGContextAddPath(ctx, bottomLine);
            CGContextDrawPath(ctx, kCGPathStroke);
            
            CGPathRelease(bottomLine);
            
            // ticks
            NSInteger tickCount = [self.axis tickCount];
            float x_label_height = 20;
            
            float div_width;
            if (tickCount == 1) {
                div_width = 0;
            } else {
                div_width = rect.size.width / (tickCount - 1);
            }
            
            int power = floor(log10(self.axis.intervalValue));
            NSString *formatString = [NSString stringWithFormat:@"%%.%if", (power < 0) ? -power : 0];
            
            for (NSUInteger i = 0; i < tickCount; i++) {
                if (i % self.intervals == 0 || self.intervals == 1) {
                    int dx = (int) (div_width * i);
                    float x_axis = self.axis.startValue + i * self.axis.intervalValue;

                    NSString *x_label = [NSString stringWithFormat:formatString, x_axis];
                    CGRect textFrame = CGRectMake(rect.origin.x + dx - 100, rect.origin.y + rect.size.height - x_label_height, 200, x_label_height);
                    
                    [self drawString:x_label withFont:[UIFont systemFontOfSize:10] andColor:[UIColor blackColor] inRect:textFrame];
                };
            }
        }
            break;
        case GraphChartAxisPositionLeft:
            
            // line
            [[UIColor grayColor] set];
            CGPathRef leftLine = CGPathCreateMutable();
            
            CGContextMoveToPoint(ctx, rect.origin.x + rect.size.width - BU_HALF, rect.origin.y);
            CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width - BU_HALF, rect.origin.y + rect.size.height);
            
            CGContextAddPath(ctx, leftLine);
            CGContextDrawPath(ctx, kCGPathStroke);
            
            CGPathRelease(leftLine);
            
            break;
        case GraphChartAxisPositionRight:
            
            break;
    }
}

@end
