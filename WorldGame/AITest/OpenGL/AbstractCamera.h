//
//  AbstractCamera.h
//  SimWorld
//
//  Created by Michael Rommel on 02.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CC3GLMatrix.h"

#include <GLKit/GLKit.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <math.h>

@interface AbstractCamera : NSObject

@property (nonatomic,assign) GLKMatrix4 viewMatrix;
@property (nonatomic,assign) GLKMatrix4 projectionMatrix;

-(id) init;

-(void) generatePerspectiveProjectionMatrixFromFieldOfView:(GLfloat)fieldOfView;

-(void) update;

@end
