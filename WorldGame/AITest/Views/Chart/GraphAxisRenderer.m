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

@implementation GraphAxisRenderer

- (instancetype)initWithAxis:(GraphChartAxis *)axis
{
    self = [super init];
    
    if (self) {
        self.axis = axis;
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    switch (self.axis.position) {
        case GraphChartAxisPositionBottom:
            [[UIColor redColor] set];
            CGContextFillRect(ctx, rect);
            
            // line
            [[UIColor grayColor] set];
            CGPathRef bottomLine = CGPathCreateMutable();
            
            CGContextMoveToPoint(ctx, rect.origin.x, rect.origin.y + BU_HALF);
            CGContextAddLineToPoint(ctx, rect.origin.x + rect.size.width, rect.origin.y + BU_HALF);
            
            CGContextAddPath(ctx, bottomLine);
            CGContextDrawPath(ctx, kCGPathStroke);
            
            CGPathRelease(bottomLine);
            
            break;
        case GraphChartAxisPositionLeft:
            [[UIColor greenColor] set];
            CGContextFillRect(ctx, rect);
            
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
            [[UIColor blueColor] set];
            CGContextFillRect(ctx, rect);
            break;
    }
    
    
}

@end
