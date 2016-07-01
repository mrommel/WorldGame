//
//  GLRay.h
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

#import "GLPlane.h"

@interface GLRay : NSObject

@property (atomic,assign) GLKVector3 origin;
@property (atomic,assign) GLKVector3 direction;

- (id)initWithOrigin:(GLKVector3)origin andDirection:(GLKVector3)direction;

- (BOOL)intersectsPlane:(GLPlane *)plane atPoint:(GLKVector3 *)intersectionPointOut;

@end
