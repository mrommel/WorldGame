//
//  GLRay.m
//  SimWorld
//
//  Created by Michael Rommel on 12.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "GLRay.h"

@implementation GLRay

- (id)initWithOrigin:(GLKVector3)origin andDirection:(GLKVector3)direction
{
    self = [super init];
    
    if (self) {
        self.origin = origin;
        self.direction = direction;
    }
    
    return self;
}

- (BOOL)intersectsPlane:(GLPlane *)plane atPoint:(GLKVector3 *)intersectionPointOut
{
    float denominator = GLKVector3DotProduct(self.direction, plane.normal);
    
    if(fabsf(denominator) < FLT_EPSILON) {
        // Ray is parallel to the plane. So, it intersections at the origin.
        if(intersectionPointOut) {
            *intersectionPointOut = self.origin;
        }
        return YES;
    }
    
    float d = -GLKVector3DotProduct(plane.point, plane.normal);
    float numerator = -GLKVector3DotProduct(self.origin, plane.normal) + d;
    float t = numerator / denominator;
    
    if(t >= 0) {
        // Ray intersects plane.
        if(intersectionPointOut) {
            *intersectionPointOut = GLKVector3Add(self.origin, GLKVector3MultiplyScalar(self.direction, t));
        }
        return YES;
    }
    
    // No intersection.
    return NO;
}

@end
