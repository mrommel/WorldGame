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
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    [self.backgroundColor set];
    CGContextFillRect(ctx, rect);
    
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
            NSString *txt = [NSString stringWithFormat:@"%.1f-%.1f", self.axis.startValue, self.axis.endValue];
            [self drawString:txt withFont:[UIFont systemFontOfSize:10] andColor:[UIColor blueColor] inRect:rect];
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

- (void)drawString:(NSString *)string
          withFont:(UIFont *)font
         andColor:(UIColor *)color
            inRect:(CGRect)contextRect
{
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: color,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [string sizeWithAttributes:attributes];
    
    CGRect textRect = CGRectMake(contextRect.origin.x + floorf((contextRect.size.width - size.width) / 2),
                                 contextRect.origin.y + floorf((contextRect.size.height - size.height) / 2),
                                 size.width,
                                 size.height);
    
    [string drawInRect:textRect withAttributes:attributes];
}

@end
