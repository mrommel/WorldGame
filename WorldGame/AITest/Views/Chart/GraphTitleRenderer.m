//
//  GraphTitleRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphTitleRenderer.h"

@implementation GraphTitleRenderer

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    
    if (self) {
        self.title = title;
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    [[UIColor blueColor] set];
    CGContextFillRect(ctx, rect);
    
    [[UIColor whiteColor] set];
    UIFont *font = [UIFont systemFontOfSize:14];
    [self drawString:self.title withFont:font inRect:rect];
}

- (void) drawString:(NSString *)string
           withFont:(UIFont *)font
             inRect:(CGRect)contextRect
{
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [string sizeWithAttributes:attributes];
    
    CGRect textRect = CGRectMake(contextRect.origin.x + floorf((contextRect.size.width - size.width) / 2),
                                 contextRect.origin.y + floorf((contextRect.size.height - size.height) / 2),
                                 size.width,
                                 size.height);
    
    [string drawInRect:textRect withAttributes:attributes];
}

@end
