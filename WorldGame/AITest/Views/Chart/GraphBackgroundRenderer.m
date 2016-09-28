//
//  GraphBackgroundRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 27.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphBackgroundRenderer.h"

@implementation GraphBackgroundRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor greenColor];
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    [self fillContext:ctx withRect:rect andColor:self.backgroundColor];
    
    if (self.backgroundImage) {
        [self.backgroundImage drawInRect:rect];
    }
}

@end
