//
//  GLPlane.h
//  SimWorld
//
//  Created by Michael Rommel on 12.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <math.h>

#include <GLKit/GLKit.h>

@interface GLPlane : NSObject

@property (atomic,assign) GLKVector3 point;
@property (atomic,assign) GLKVector3 normal;

- (id)initWithPoint:(GLKVector3)point andNormal:(GLKVector3)normal;
- (id)initWithPoint1:(GLKVector3)point1 andPoint2:(GLKVector3)point2 andPoint3:(GLKVector3)point3;

- (float)distanceToPoint:(GLKVector3)point;

@end
