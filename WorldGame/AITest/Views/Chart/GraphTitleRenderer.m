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
    [self fillContext:ctx withRect:rect andColor:self.backgroundColor];
    
    [self.titleColor set];
    [self drawString:self.title withFont:self.titleFont andColor:self.titleColor inRect:rect];
}

@end
