//
//  GraphAxisRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphChartAxis.h"

@interface GraphAxisRenderer : NSObject

@property (atomic) GraphChartAxis *axis;

- (instancetype)initWithAxis:(GraphChartAxis *)axis;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end