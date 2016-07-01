//
//  GLPlane.m
//  SimWorld
//
//  Created by Michael Rommel on 12.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "GLPlane.h"

@implementation GLPlane

- (id)initWithPoint:(GLKVector3)point andNormal:(GLKVector3)normal
{
    self = [super init];
    
    if (self) {
        self.point = point;
        self.normal = normal;
    }
    
    return self;
}

- (id)initWithPoint1:(GLKVector3)point1 andPoint2:(GLKVector3)point2 andPoint3:(GLKVector3)point3
{
    self = [super init];
    
    if (self) {
        GLKVector3 v = GLKVector3Subtract(point2, point1);
        GLKVector3 u = GLKVector3Subtract(point3, point1);
        self.point = point1;
        self.normal = GLKVector3Normalize(GLKVector3CrossProduct(v, u));
    }
    
    return self;
}

- (float)distanceToPoint:(GLKVector3)point
{
    return GLKVector3DotProduct(self.normal, GLKVector3Subtract(self.point, point));
}

@end
