//
//  GraphRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 26.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphRenderer.h"

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

@end
