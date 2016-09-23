//
//  GraphChartLineRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GraphChartRenderer.h"
#import "GraphData.h"

@interface GraphChartLineRenderer : NSObject<GraphChartRenderer>

@property (nonatomic) GraphData *data;

- (instancetype)initWithGraphData:(GraphData *)data;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end
