//
//  MathHelper.h
//  SimWorld
//
//  Created by Michael Rommel on 03.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

//
//  MathHelpers.h
//

#import "CC3GLMatrix.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <math.h>

#include <GLKit/GLKit.h>

#pragma mark -
#pragma mark Defines
#pragma mark -

#define PRINT_MATRIX(matrix)    \
NSLog(@"   / %.2f \t%.2f \t%.2f \t%.2f \t\\", matrix.m00, matrix.m10, matrix.m20, matrix.m30); \
NSLog(@"   | %.2f \t%.2f \t%.2f \t%.2f \t|", matrix.m01, matrix.m11, matrix.m21, matrix.m31); \
NSLog(@"   | %.2f \t%.2f \t%.2f \t%.2f \t|", matrix.m02, matrix.m12, matrix.m22, matrix.m32); \
NSLog(@"   \\ %.2f \t%.2f \t%.2f \t%.2f \t/", matrix.m03, matrix.m13, matrix.m23, matrix.m33);

#define PRINT_BYTE(byteVal)    \
NSLog(@"   %d%d%d%d %d%d%d%d", (byteVal >> 7) & 1, (byteVal >> 6) & 1, (byteVal >> 5) & 1, (byteVal >> 4) & 1, (byteVal >> 3) & 1, (byteVal >> 2) & 1, (byteVal >> 1) & 1, byteVal & 1);

#pragma mark -
#pragma mark Prototypes
#pragma mark -

static __inline__ GLKVector3 Vector3DDirectionToAngle(GLKVector3 direction);

// Transforms a GLKVector3 by the given matrix
static __inline__ GLKVector3 Vector3Transform(GLKVector3 vector, GLKMatrix4 transform);

// Creates a new rotation matrix from a specified yaw, pitch and roll angles
static __inline__ GLKMatrix4 Matrix4MakeFromYawPitchRoll(float yaw, float pitch, float roll);

// Creates a new quaternion from specified yaw, pitch and roll angles
static __inline__ GLKQuaternion QuaternionMakeFromYawPitchRoll(float yaw, float pitch, float roll);

#pragma mark -
#pragma mark Implementations
#pragma mark -

static __inline__ NSString* GLKVector3ToString(GLKVector3 vector)
{
    return [NSString stringWithFormat:@"%.2f, %.2f, %.2f", vector.x, vector.y, vector.z];
}

static __inline__ GLKVector3 Vector3DDirectionToAngle(GLKVector3 direction)
{
    // Convert direction vector to angle
    float rotation = (float) acos(direction.y > 0 ? -direction.x : direction.x);
    
    if (direction.y > 0)
        rotation  = M_PI;
    
    rotation  = M_PI_2;
    
    return GLKVector3Make(0, rotation, 0);
}

static __inline__ GLKVector3 Vector3Transform(GLKVector3 vector, GLKMatrix4 transform)
{
    return GLKVector3Make(((vector.x * transform.m00) + (vector.y * transform.m10) + (vector.z * transform.m20) + transform.m30),
                          ((vector.x * transform.m01) + (vector.y * transform.m11) + (vector.z * transform.m21) + transform.m31),
                          ((vector.x * transform.m02) + (vector.y * transform.m12) + (vector.z * transform.m22) + transform.m32));
}

static __inline__ GLKMatrix4 Matrix4MakeFromYawPitchRoll(float yaw, float pitch, float roll)
{
    GLKQuaternion quaternion;
    
    quaternion = QuaternionMakeFromYawPitchRoll(yaw, pitch, roll);
    
    return GLKMatrix4MakeWithQuaternion(quaternion);
}


static __inline__ GLKQuaternion QuaternionMakeFromYawPitchRoll(float yaw, float pitch, float roll)
{
    GLKQuaternion quaternion;
    
    quaternion.x = (((float)cos((double)(yaw * 0.5f)) * (float)sin((double)(pitch * 0.5f))) * (float)cos((double)(roll * 0.5f))) + (((float)sin((double)(yaw * 0.5f)) * (float)cos((double)(pitch * 0.5f))) * (float)sin((double)(roll * 0.5f)));
    
    quaternion.y = (((float)sin((double)(yaw * 0.5f)) * (float)cos((double)(pitch * 0.5f))) * (float)cos((double)(roll * 0.5f))) - (((float)cos((double)(yaw * 0.5f)) * (float)sin((double)(pitch * 0.5f))) * (float)sin((double)(roll * 0.5f)));
    
    quaternion.z = (((float)cos((double)(yaw * 0.5f)) * (float)cos((double)(pitch * 0.5f))) * (float)sin((double)(roll * 0.5f))) - (((float)sin((double)(yaw * 0.5f)) * (float)sin((double)(pitch * 0.5f))) * (float)cos((double)(roll * 0.5f)));
    
    quaternion.w = (((float)cos((double)(yaw * 0.5f)) * (float)cos((double)(pitch * 0.5f))) * (float)cos((double)(roll * 0.5f))) + (((float)sin((double)(yaw * 0.5f)) * (float)sin((double)(pitch * 0.5f))) * (float)sin((double)(roll * 0.5f)));
    
    return quaternion;
}


