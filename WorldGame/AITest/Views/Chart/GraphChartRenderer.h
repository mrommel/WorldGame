//
//  GraphChartRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#ifndef GraphChartRenderer_h
#define GraphChartRenderer_h

#import <CoreGraphics/CoreGraphics.h>

@protocol GraphChartRenderer

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end

#endif /* GraphChartRenderer_h */
