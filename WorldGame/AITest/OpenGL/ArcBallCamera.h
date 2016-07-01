//
//  ArcBallCamera.h
//  SimWorld
//
//  Created by Michael Rommel on 02.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AbstractCamera.h"

@interface ArcBallCamera : AbstractCamera

// Rotation around the two axes
@property (atomic,assign) GLfloat rotationX;
@property (atomic,assign) GLfloat rotationY;

// Y axis rotation limits (radians)
@property (atomic,assign) GLfloat minRotationY;
@property (atomic,assign) GLfloat maxRotationY;

// Distance between the target and camera
@property (atomic) GLfloat distance;

// Distance limits
@property (atomic,assign) GLfloat minDistance;
@property (atomic,assign) GLfloat maxDistance;

// Calculated position and specified target
@property (atomic,assign) GLKVector3 position;
@property (atomic) GLKVector3 target;

-(id) initWithTarget:(GLKVector3)target andRotationX:(GLfloat)rotationX andRotationY:(GLfloat)rotationY
     andMinRotationY:(GLfloat)minRotationY andMaxRotationY:(GLfloat)maxRotationY
         andDistance:(GLfloat)distance
      andMinDistance:(GLfloat)minDistance andMaxDistance:(GLfloat)maxDistance;

-(void) moveBy:(GLfloat)distanceChange;
-(void) rotateByX:(GLfloat)rotationXChange andY:(GLfloat)rotationYChange;
-(void) translateBy:(GLKVector3)positionChange;

@end
