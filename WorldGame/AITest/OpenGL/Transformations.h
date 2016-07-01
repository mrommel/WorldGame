//
//  Transformations.h
//  GLTransformations
//
//  Created by RRC on 9/8/13.
//  Copyright (c) 2013 Ricardo Rendon Cepeda. All rights reserved.
//

#import <GLKit/GLKit.h>

static __inline__ GLKVector3 GLKVector3ScaleFromMatrix4(GLKMatrix4 m) {
    
    GLKVector3 v = GLKVector3Make(sqrt(m.m00*m.m00 + m.m01*m.m01 +m.m02*m.m02),
                                  sqrt(m.m10*m.m10 + m.m11*m.m11 +m.m12*m.m12),
                                  sqrt(m.m20*m.m20 + m.m21*m.m21 +m.m22*m.m22));
    
    return v;
}

static __inline__ GLKMatrix4 GLKMatrix4RotationFromMatrix(GLKMatrix4 m) {
    
    GLKVector3 s = GLKVector3ScaleFromMatrix4(m);
    
    GLKMatrix4 n_matrix;
    n_matrix.m00 = m.m00/s.x;
    n_matrix.m01 = m.m01/s.x;
    n_matrix.m02 = m.m02/s.x;
    n_matrix.m03 = 0;
    
    n_matrix.m10 = m.m10/s.y;
    n_matrix.m11 = m.m11/s.y;
    n_matrix.m12 = m.m12/s.y;
    n_matrix.m13 = 0;
    
    n_matrix.m20 = m.m20/s.z;
    n_matrix.m21 = m.m21/s.z;
    n_matrix.m22 = m.m22/s.z;
    n_matrix.m23 = 0;
    
    n_matrix.m30 = 0;
    n_matrix.m31 = 0;
    n_matrix.m32 = 0;
    n_matrix.m33 = 1;
    
    return n_matrix;
}


static __inline__ GLKVector3 GLKVector3RotationFromMatrix(GLKMatrix4 matrix) {
    
    GLKVector3 rotate;
    
    // decompose main matrix and take just rotation matrix
    GLKMatrix4 rMatrix = GLKMatrix4RotationFromMatrix(matrix);
    
    rotate.x = atan2f(rMatrix.m21, rMatrix.m22);
    rotate.y = atan2f(-rMatrix.m20, sqrtf(rMatrix.m21*rMatrix.m21 + rMatrix.m22*rMatrix.m22) );
    rotate.z = atan2f(rMatrix.m10, rMatrix.m00);
    
    return rotate;
}

static __inline__ GLKVector3 GLKVector3TranslateFromMatrix(GLKMatrix4 matrix) {
    
    GLKVector3 translate = GLKVector3Make(matrix.m30, matrix.m31, matrix.m32);
    
    return translate;
}

@interface Transformations : NSObject

typedef enum TransformationState
{
    S_NEW,
    S_SCALE,
    S_TRANSLATION,
    S_ROTATION
}
TransformationState;

@property (readwrite) TransformationState state;

- (id)initWithDepth:(float)z Scale:(float)s Translation:(GLKVector2)t Rotation:(GLKVector3)r;
- (void)start;
- (void)scale:(float)s;
- (void)translate:(GLKVector2)t withMultiplier:(float)m;
- (void)rotate:(GLKVector3)r withMultiplier:(float)m;
- (GLKMatrix4)getModelViewMatrix;

@end
