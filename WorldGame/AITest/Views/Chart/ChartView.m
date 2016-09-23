//
//  ChartView.m
//  AITest
//
//  Created by Michael Rommel on 07.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "ChartView.h"

#import "UIConstants.h"
#import "GraphTitleRenderer.h"
#import "GraphChartRenderer.h"
#import "GraphAxisRenderer.h"
#import "GraphChartLineRenderer.h"

@interface ChartView()

@property (nonatomic) NSString *title;
@property (nonatomic) GraphTitleRenderer *titleRenderer;

@property (nonatomic) NSMutableArray *graphs;
@property (nonatomic) NSMutableArray *graphRenderer;

@property (nonatomic) NSMutableArray *axes;
@property (nonatomic) NSMutableArray *axisRenderer;

@end

@implementation ChartView

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.title = title;
        self.titleRenderer = [[GraphTitleRenderer alloc] initWithTitle:title];
        
        self.graphs = [[NSMutableArray alloc] init];
        self.graphRenderer = [[NSMutableArray alloc] init];
        
        self.axes = [[NSMutableArray alloc] init];
        self.axisRenderer = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, self.bounds);
    
    if (!self.graphs) {
        return;
    }
    
    // canvas vars
    CGFloat x0 = self.bounds.origin.x;
    CGFloat x1 = self.bounds.origin.x + BU3;
    CGFloat x2 = self.bounds.origin.x + self.bounds.size.width - BU3;
    CGFloat x3 = self.bounds.origin.x + self.bounds.size.width;
    
    CGFloat y0 = self.bounds.origin.y;
    CGFloat y1 = self.bounds.origin.y + BU3;
    CGFloat y2 = self.bounds.origin.y + self.bounds.size.height - BU3;
    CGFloat y3 = self.bounds.origin.y + self.bounds.size.height;
    
    CGRect titleRect = CGRectMake(x1, y0, x2 - x1, y1 - y0);
    CGRect canvasRect = CGRectMake(x1, y1, x2 - x1, y2 - y1);
    CGRect axisLeftRect = CGRectMake(x0, y1, x1 - x0, y2 - y1);
    CGRect axisRightRect = CGRectMake(x2, y1, x3 - x2, y2 - y1);
    CGRect axisBottomRect = CGRectMake(x1, y2, x2 - x1, y3 - y2);
    
    [self.titleRenderer drawWithContext:ctx andCanvasRect:titleRect];
    
    for (id<GraphChartRenderer> renderer in self.graphRenderer) {
        [renderer drawWithContext:ctx andCanvasRect:canvasRect];
    }
    
    for (GraphAxisRenderer *renderer in self.axisRenderer) {
        switch (renderer.axis.position) {
            case GraphChartAxisPositionLeft:
                [renderer drawWithContext:ctx andCanvasRect:axisLeftRect];
                break;
            case GraphChartAxisPositionRight:
                [renderer drawWithContext:ctx andCanvasRect:axisRightRect];
                break;
            case GraphChartAxisPositionBottom:
                [renderer drawWithContext:ctx andCanvasRect:axisBottomRect];
                break;
        }
        
    }
}

- (void)addGraphData:(GraphData *)graphData
{
    [self.graphs addObject:graphData];
    
    switch (graphData.type) {
        case GraphTypeDefault:
        case GraphTypeLine: {
            [self.graphRenderer addObject:[[GraphChartLineRenderer alloc] initWithGraphData:graphData]];
            
            GraphChartAxis *bottomAxis = [[GraphChartAxis alloc] initWithOrientation:GraphChartAxisOrientationHorizontal andPosition:GraphChartAxisPositionBottom];
            [bottomAxis calculateWithGraphData:graphData];
            [self.axisRenderer addObject:[[GraphAxisRenderer alloc] initWithAxis:bottomAxis]];
            
            GraphChartAxis *leftAxis = [[GraphChartAxis alloc] initWithOrientation:GraphChartAxisOrientationVertical andPosition:GraphChartAxisPositionLeft];
            [leftAxis calculateWithGraphData:graphData];
            [self.axisRenderer addObject:[[GraphAxisRenderer alloc] initWithAxis:leftAxis]];
        }
            break;
        case GraphTypeBar:
            break;
        case GraphTypePie:
            break;
    }
    
    [self setNeedsDisplay];
}

@end
