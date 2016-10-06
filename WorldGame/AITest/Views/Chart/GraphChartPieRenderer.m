//
//  GraphChartPieRenderer.m
//  WorldGame
//
//  Created by Michael Rommel on 06.10.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphChartPieRenderer.h"

#import "GraphDataEntry.h"

#define DEG2RAD(x)  ((x-90)*M_PI/180.0)

@interface GraphChartPieRenderer()

@property (atomic) CGFloat _animationProgress; // 0..1
@property (nonatomic) UIFont *percentageFont;

@end

@implementation GraphChartPieRenderer

- (instancetype)initWithGraphData:(GraphData *)data
{
    self = [super init];
    
    if (self) {
        self.data = data;
        self._animationProgress = 1.0;
        self.lineColor = [UIColor whiteColor];
        self.fillColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        
        self.showLabels = YES;
        self.percentageFont = [UIFont boldSystemFontOfSize:8];
    }
    
    return self;
}

- (void)setAnimationProgress:(CGFloat)animationProgress
{
    self._animationProgress = animationProgress;
}

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect
{
    CGFloat graphWidth = rect.size.width;
    CGFloat graphHeight = rect.size.height;
    
    float margin = 10;
    float diameter = MIN(graphWidth, graphHeight) - 2 * margin;
    float offset_x = (graphWidth - diameter) / 2;
    float offset_y = (graphHeight - diameter) / 2;
    float gap = 1;
    float radius = diameter / 2;
    float origin_x = rect.origin.x + offset_x + radius;
    float origin_y = rect.origin.y + offset_y + radius;
    
    float startDeg = 0;
    float endDeg = 0;
    
    float total = 0;
    for (GraphDataEntry *dataEntry in self.data.values) {
        total += [dataEntry.value floatValue];
    }
    
    for (int i = 0; i < self.data.values.count; i++) {
        GraphDataEntry *dataEntry = [self.data.values objectAtIndex:i];
        
        float perc = [dataEntry.value floatValue] / total;
        perc *= self._animationProgress;
        endDeg = startDeg + perc * 360;
        
        CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
        CGContextMoveToPoint(ctx, origin_x, origin_y);
        CGContextAddArc(ctx, origin_x, origin_y, radius, DEG2RAD(startDeg), DEG2RAD(endDeg), 0);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
        CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
        CGContextSetLineWidth(ctx, gap);
        CGContextMoveToPoint(ctx, origin_x, origin_y);
        CGContextAddArc(ctx, origin_x, origin_y, radius, DEG2RAD(startDeg), DEG2RAD(endDeg), 0);
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        
        startDeg = endDeg;
    }
    
    startDeg = 0;
    
    for (int i = 0; i < self.data.values.count; i++) {
        GraphDataEntry *dataEntry = [self.data.values objectAtIndex:i];
        
        float perc = [dataEntry.value floatValue] / total;
        perc *= self._animationProgress;
        endDeg = startDeg + perc * 360;
        
        if (self.showLabels) {
            float angle = (startDeg + endDeg) / 2;
            CGPoint center = CGPointMake(origin_x + cos(DEG2RAD(angle)) * radius * 0.75, origin_y + sin(DEG2RAD(angle)) * radius * 0.75);
            
            NSString *percentageText = [NSString stringWithFormat:@"%.1f%%", perc * 100];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            NSAttributedString *attributedString = [NSAttributedString.alloc initWithString:percentageText attributes: @{NSParagraphStyleAttributeName:paragraphStyle,
                                                                                                                         NSFontAttributeName:self.percentageFont,
                                                                                                                         NSForegroundColorAttributeName:self.textColor}];
            CGSize optimumSize = [attributedString boundingRectWithSize:(CGSize){100, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            CGRect percentageFrame = CGRectMake(center.x - optimumSize.width / 2, center.y - optimumSize.height / 2, optimumSize.width, optimumSize.height);
            
            [attributedString drawInRect:percentageFrame];
        }
        
        startDeg = endDeg;
    }
}

@end
