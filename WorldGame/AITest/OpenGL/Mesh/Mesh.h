//
//  Mesh.h
//  SimWorld
//
//  Created by Michael Rommel on 14.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <OpenGLES/ES2/gl.h>

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
    float TexCoord2[2];
} Vertex;

typedef unsigned int Index;

@interface Mesh : NSObject

@property (nonatomic, assign) Vertex* vertices;
@property (nonatomic, assign) NSUInteger numberOfVertices;
@property (nonatomic, assign) Index* indices;
@property (nonatomic, assign) NSUInteger numberOfIndices;
@property (nonatomic, assign) GLuint texture;
@property (nonatomic, assign) CC3BoundingBox boundingBox;

/** @name init functions */

- (id)initWithNumberOfVertices:(NSUInteger)numberOfVertices
            andNumberOfIndices:(NSUInteger)numberOfIndices
                    andTexture:(GLuint)texture;

- (id)initWithNumberOfVertices:(NSUInteger)numberOfVertices
            andNumberOfIndices:(NSUInteger)numberOfIndices
                andTextureFile:(NSString *)textureFile;

- (void)populateWithNumberOfVertices:(NSUInteger)numberOfVertices
                  andNumberOfIndices:(NSUInteger)numberOfIndices;

/** @name vertex functions */

- (void)setVertexAt:(int)index
               andX:(float)x andY:(float)y andZ:(float)z
        andTextureX:(float)tx andTextureY:(float)ty;

- (void)setVertexAt:(int)index
               andX:(float)x
               andY:(float)y
               andZ:(float)z
        andTextureX:(float)tx
        andTextureY:(float)ty
          andColorA:(float)colorA
          andColorR:(float)colorR
          andColorG:(float)colorG
          andColorB:(float)colorB;

- (void)setVertexAt:(int)index
               andX:(float)x andY:(float)y andZ:(float)z
        andTextureX:(float)tx andTextureY:(float)ty
       andTextureX2:(float)tx2 andTextureY2:(float)ty2;


/** @name index functions */

- (void)setTriangleAt:(int)index withIndex1:(int)i1 andIndex2:(int)i2 andIndex3:(int)i3;

- (void)setIndexAt:(int)index
           toIndex:(int)indexValue;

- (void)moveWithX:(float)dx andY:(float)dy andZ:(float)dz;

@end
