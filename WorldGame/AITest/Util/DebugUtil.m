//
//  DebugUtil.m
//  AITest
//
//  Created by Michael Rommel on 13.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "DebugUtil.h"

#import <UIKit/UIKit.h>

typedef void(^PathEnumerationHandler)(const CGPathElement *element);

@implementation DebugUtil

+ (void)enumerateElementsOfPath:(CGPathRef)cgPath withBlock:(PathEnumerationHandler)handler
{
    void CGPathEnumerationCallback(void *info, const CGPathElement *element);
    CGPathApply(cgPath, (__bridge void * _Nullable)(handler), CGPathEnumerationCallback);
}

+ (NSString *)descriptionOfPath:(CGPathRef)cgPath
{
    CGRect bounds = CGPathGetPathBoundingBox(cgPath);
    CGRect controlPointBounds = CGPathGetBoundingBox(cgPath);
    
    NSMutableString *mutableDescription = [NSMutableString string];
    [mutableDescription appendFormat:@"%@ <%p>\n", [self class], self];
    [mutableDescription appendFormat:@"  Bounds: %@\n", NSStringFromCGRect(bounds)];
    [mutableDescription appendFormat:@"  Control Point Bounds: %@\n", NSStringFromCGRect(controlPointBounds)];
    
    [self enumerateElementsOfPath:cgPath withBlock:^(const CGPathElement *element) {
        [mutableDescription appendFormat:@"    %@\n", [self descriptionForPathElement:element]];
    }];
    
    return [mutableDescription copy];
}

+ (NSString *)descriptionForPathElement:(const CGPathElement *)element
{
    NSString *description = nil;
    switch (element->type) {
        case kCGPathElementMoveToPoint: {
            CGPoint point = element ->points[0];
            description = [NSString stringWithFormat:@"%f %f %@", point.x, point.y, @"moveto"];
            break;
        }
        case kCGPathElementAddLineToPoint: {
            CGPoint point = element ->points[0];
            description = [NSString stringWithFormat:@"%f %f %@", point.x, point.y, @"lineto"];
            break;
        }
        case kCGPathElementAddQuadCurveToPoint: {
            CGPoint point1 = element->points[0];
            CGPoint point2 = element->points[1];
            description = [NSString stringWithFormat:@"%f %f %f %f %@", point1.x, point1.y, point2.x, point2.y, @"quadcurveto"];
            break;
        }
        case kCGPathElementAddCurveToPoint: {
            CGPoint point1 = element->points[0];
            CGPoint point2 = element->points[1];
            CGPoint point3 = element->points[2];
            description = [NSString stringWithFormat:@"%f %f %f %f %f %f %@", point1.x, point1.y, point2.x, point2.y, point3.x, point3.y, @"curveto"];
            break;
        }
        case kCGPathElementCloseSubpath: {
            description = @"closepath";
            break;
        }
    }
    return description;
}

void CGPathEnumerationCallback(void *info, const CGPathElement *element)
{
    PathEnumerationHandler handler = (__bridge PathEnumerationHandler)(info);
    if (handler) {
        handler(element);
    }
}

@end
