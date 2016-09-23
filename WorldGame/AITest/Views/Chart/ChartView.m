//
//  ChartView.m
//  AITest
//
//  Created by Michael Rommel on 07.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "ChartView.h"

#import "UIConstants.h"

#pragma mark -
#pragma mark GraphData


#pragma mark -
#pragma mark ChartRenderer

@protocol ChartRenderer

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end

#pragma mark -
#pragma mark ChartLineRenderer

@interface ChartLineRenderer : NSObject<ChartRenderer>

@property (nonatomic) GraphData *data;

@end

@implementation ChartLineRenderer

- (instancetype)initWithGraphData:(GraphData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGPathRelease(path);
    
    
    /*CGMutablePathRef path = CGPathCreateMutable();
    
    NSInteger values = [self.data.values count];
    CGFloat graphWidth = rect.size.width;
    CGFloat graphHeight = rect.size.height;
    
    CGPathMoveToPoint(path, nil, BU_HALF, BU_HALF + (1.0f - [[self.data.values firstObject] floatValue]) * graphHeight);
    
    for (int i = 1; i < self.values.count; i++) {
        CGPathAddLineToPoint(path, NULL, BU_HALF + ((float)i / (float)self.values.count) * graphWidth, BU_HALF + (1.0f - [[self.values objectAtIndex:i] floatValue]) * graphHeight);
    }
    
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);*/
}

@end

#pragma mark -
#pragma mark ChartAxis

typedef NS_ENUM(NSInteger, ChartAxisOrientation) {
    ChartAxisOrientationVertical,  // | y
    ChartAxisOrientationHorizontal // - x
};

typedef NS_ENUM(NSInteger, ChartAxisPosition) {
    ChartAxisPositionBottom,  // x
    ChartAxisPositionLeft, // y
    ChartAxisPositionRight // y
};

@interface ChartAxis : NSObject

@property (nonatomic) ChartAxisOrientation orientation;
@property (nonatomic) ChartAxisPosition position;

@property (atomic) CGFloat minimumValue;
@property (atomic) CGFloat maximumValue;

@end

@implementation ChartAxis

- (instancetype)initWithOrientation:(ChartAxisOrientation)orientation andPosition:(ChartAxisPosition)position
{
    self = [super init];
    
    if (self) {
        self.orientation = orientation;
        self.position = position;
    }
    
    return self;
}

- (void)calculateWithGraphData:(GraphData *)data
{
    self.minimumValue = CGFLOAT_MAX;
    self.maximumValue = CGFLOAT_MIN;
    
    
}

@end

#pragma mark -
#pragma mark AxisRenderer

@interface AxisRenderer : NSObject

@property (atomic) ChartAxis *axis;

@end

@implementation AxisRenderer

- (instancetype)initWithAxis:(ChartAxis *)axis
{
    self = [super init];
    
    if (self) {
        self.axis = axis;
    }
    
    return self;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGPathRef path = CGPathCreateWithRect(rect, NULL);
    
    switch (self.axis.position) {
        case ChartAxisPositionBottom:
            CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
            break;
        case ChartAxisPositionLeft:
            CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
            break;
        case ChartAxisPositionRight:
            CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
            break;
    }
    
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathFill);
    
    CGPathRelease(path);
}

@end

#pragma mark -
#pragma mark TitleRenderer

@interface TitleRenderer : NSObject

@property (nonatomic) NSString *title;

@end

@implementation TitleRenderer

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
    //[self.title drawInRect:rect withFont:font];
    [self drawString:self.title withFont:font inRect:rect];
}

- (void) drawString: (NSString*) s
           withFont: (UIFont*) font
             inRect: (CGRect) contextRect {
    
    /// Make a copy of the default paragraph style
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: font,
                                  NSForegroundColorAttributeName: [UIColor whiteColor],
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [s sizeWithAttributes:attributes];
    
    CGRect textRect = CGRectMake(contextRect.origin.x + floorf((contextRect.size.width - size.width) / 2),
                                 contextRect.origin.y + floorf((contextRect.size.height - size.height) / 2),
                                 size.width,
                                 size.height);
    
    [s drawInRect:textRect withAttributes:attributes];
}

@end

#pragma mark -
#pragma mark ChartView

@interface ChartView()

@property (nonatomic) NSString *title;
@property (nonatomic) TitleRenderer *titleRenderer;

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
        self.titleRenderer = [[TitleRenderer alloc] initWithTitle:title];
        
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
    
    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
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
    
    for (id<ChartRenderer> renderer in self.graphRenderer) {
        [renderer drawWithContext:ctx andCanvasRect:canvasRect];
    }
    
    for (AxisRenderer *renderer in self.axisRenderer) {
        switch (renderer.axis.position) {
            case ChartAxisPositionLeft:
                [renderer drawWithContext:ctx andCanvasRect:axisLeftRect];
                break;
            case ChartAxisPositionRight:
                [renderer drawWithContext:ctx andCanvasRect:axisRightRect];
                break;
            case  ChartAxisPositionBottom:
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
            [self.graphRenderer addObject:[[ChartLineRenderer alloc] initWithGraphData:graphData]];
            
            ChartAxis *bottomAxis = [[ChartAxis alloc] initWithOrientation:ChartAxisOrientationHorizontal andPosition:ChartAxisPositionBottom];
            [bottomAxis calculateWithGraphData:graphData];
            [self.axisRenderer addObject:[[AxisRenderer alloc] initWithAxis:bottomAxis]];
            
            ChartAxis *leftAxis = [[ChartAxis alloc] initWithOrientation:ChartAxisOrientationVertical andPosition:ChartAxisPositionLeft];
            [leftAxis calculateWithGraphData:graphData];
            [self.axisRenderer addObject:[[AxisRenderer alloc] initWithAxis:leftAxis]];
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
