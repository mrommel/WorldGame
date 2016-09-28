//
//  GraphRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 26.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphRenderer.h"

@implementation Line

- (instancetype)initWithOrigin:(CGPoint)origin andDestination:(CGPoint)destination
{
    self = [super init];
    
    if (self) {
        self.origin = origin;
        self.destination = destination;
    }
    
    return self;
}

- (instancetype)initWithOriginX:(CGFloat)originX andOriginY:(CGFloat)originY andDestinationX:(CGFloat)destinationX andDestinationY:(CGFloat)destinationY
{
    self = [super init];
    
    if (self) {
        self.origin = CGPointMake(originX, originY);
        self.destination = CGPointMake(destinationX, destinationY);
    }
    
    return self;
}

@end

@implementation GraphRenderer

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

- (void)fillContext:(CGContextRef)ctx withRect:(CGRect)rect andColor:(UIColor *)fillColor
{
    [fillColor set];
    CGContextFillRect(ctx, rect);
}

- (void)drawContext:(CGContextRef)ctx withLine:(Line *)line andColor:(UIColor *)color
{
    CGPathRef pathLine = CGPathCreateMutable();
    
    CGContextMoveToPoint(ctx, line.origin.x, line.origin.y);
    CGContextAddLineToPoint(ctx, line.destination.x, line.destination.y);
    
    CGContextAddPath(ctx, pathLine);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGPathRelease(pathLine);
}

@end
