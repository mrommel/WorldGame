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
        
        self.backgroundColor = [UIColor whiteColor];
        self.titleColor = [UIColor grayColor];
        self.titleFont = [UIFont systemFontOfSize:14];
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    [self.backgroundColor set];
    CGContextFillRect(ctx, rect);
    
    [self.titleColor set];
    [self drawString:self.title withFont:self.titleFont andColor:self.titleColor inRect:rect];
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
