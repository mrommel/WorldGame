//
//  CC3GLMatrix+Extension.h
//  SimWorld
//
//  Created by Michael Rommel on 15.07.15.
//  Copyright (c) 2015 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    GLfloat x;			/**< The X-componenent of the vector. */
    GLfloat y;			/**< The Y-componenent of the vector. */
} CC3Vector2;

static const CC3Vector2 kCC3Vector2Zero = { 0.0, 0.0 };

/** Returns a CC3Vector2 structure constructed from the vector components. */
CC3Vector2 CC3Vector2Make(GLfloat x, GLfloat y);

CC3Vector2 CC3Vector2Add(CC3Vector2 vector1, CC3Vector2 vector2);
CC3Vector2 CC3Vector2ScaleUniform(CC3Vector2 v, GLfloat scale);

GLfloat CC3Vector2Length(CC3Vector2 v);



CC3Vector4 CC3Vector4Add(CC3Vector4 vector1, CC3Vector4 vector2);

/**
 * Defines an axially-aligned-bounding-sphere (AABB), describing
 * a 3D volume by specifying the center in 3D corner and a radius.
 */
typedef struct {
    CC3Vector center;			/**< The center of the sphere. */
    float radius;			/**< The radius of the sphere */
} CC3BoundingSphere;

/** A CC3BoundingSphere of zero origin and dimensions. */
static const CC3BoundingSphere kCC3CC3BoundingSphereZero = { {0.0, 0.0, 0.0}, 0 };

/** Returns a string description of the specified CC3BoundingSphere struct. */
NSString* NSStringFromCC3BoundingSphere(CC3BoundingSphere bb);

/** Returns a CC3BoundingSphere structure constructed from the center coords and radius components. */
CC3BoundingSphere CC3BoundingSphereMake(GLfloat x, GLfloat y, GLfloat z, GLfloat radius);

/** Returns a CC3BoundingSphere structure constructed from the center vector and radius components. */
CC3BoundingSphere CC3BoundingSphereMakeFromCenter(CC3Vector center, GLfloat radius);


/** Unit vector pointing in the same direction as the positive Y-axis. */
static const CC3Vector kCC3VectorUp = { 0.0,  1.0,  0.0 };

/** Unit vector pointing in the same direction as the positive X-axis. */
static const CC3Vector kCC3VectorRight = { 1.0,  0.0,  0.0 };

/** Unit vector pointing in the same direction as the positive Z-axis. */
static const CC3Vector kCC3VectorForward = { 0.0,  0.0,  1.0 };

/** Unit vector pointing in the same direction as the negative Z-axis. */
static const CC3Vector kCC3VectorBackward = { 0.0,  0.0, -1.0 };


@interface CC3GLMatrix (Extension)

/** set the right value of the matrix */
- (void)setRightDirection:(CC3Vector)aVector;

/** set the up value of the matrix */
- (void)setUpDirection:(CC3Vector)aVector;

/** set the backwards value of the matrix */
- (void)setBackwardDirection:(CC3Vector)aVector;

/** set the forward value of the matrix */
- (void)setForwardDirection:(CC3Vector)aVector;

/** set the translation value of the matrix */
- (void)setTranslation:(CC3Vector)aVector;

- (void)setTranslationY:(float)y;

/** get the translation value of the matrix */
- (CC3Vector)extractTranslation;

- (CC3Vector)extractBackwardDirection;

/** Transforms a 3D vector normal by a matrix. */
- (CC3Vector)transformNormal:(CC3Vector)normal;

/** copies the current Matrix and inverts it */
- (CC3GLMatrix *)copyInverted;

/** copies the current Matrix and multiplies it */
- (CC3GLMatrix *)copyMultipliedBy:(CC3GLMatrix *)mut;
- (CC3GLMatrix *)copyMultipliedByConst:(const CC3GLMatrix *)mut;

+ (CC3GLMatrix *)matrixFromQuaternion:(CC3Vector4)quaternion;

@end

@interface NSMutableArray (Matrix)

- (CC3GLMatrix *)matrixAtIndex:(NSUInteger)index;
- (void)addMatrix:(CC3GLMatrix *)matrix;
- (void)insertMatrix:(CC3GLMatrix *)matrix atIndex:(NSUInteger)index;

- (void)addVector4:(CC3Vector4)vector;
- (void)insertVector4:(CC3Vector4)vector atIndex:(NSUInteger)index;
- (CC3Vector4)vector4AtIndex:(NSUInteger)index;

@end

@interface CC3GLVector : NSObject

@property (atomic) CC3Vector value;

- (id)initWithVector:(CC3Vector)vector;

@end