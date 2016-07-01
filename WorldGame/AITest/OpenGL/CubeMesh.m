//
//  CubeMesh.m
//  SimWorld
//
//  Created by Michael Rommel on 15.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "CubeMesh.h"

#define TEX_COORD_MAX 2

@implementation CubeMesh

- (id)initWithX:(float)x andY:(float)y andZ:(float)z andTextureFile:(NSString *)textureName
{
    self = [super initWithNumberOfVertices:24 andNumberOfIndices:36 andTextureFile:textureName];
    
    if (self) {
        // Front
        [self setVertexAt:0 andX:(1+x) andY:(-1+y) andZ:(1+z) andTextureX:TEX_COORD_MAX andTextureY:0];
        [self setVertexAt:1 andX:(1+x) andY:(1+y) andZ:(1+z) andTextureX:TEX_COORD_MAX andTextureY:TEX_COORD_MAX];
        [self setVertexAt:2 andX:(-1+x) andY:(1+y) andZ:(1+z) andTextureX:0 andTextureY:TEX_COORD_MAX];
        [self setVertexAt:3 andX:(-1+x) andY:(-1+y) andZ:(1+z) andTextureX:0 andTextureY:0];
        // Back
        [self setVertexAt:4 andX:(1+x) andY:(1+y) andZ:(-1+z) andTextureX:TEX_COORD_MAX andTextureY:0];
        [self setVertexAt:5 andX:(-1+x) andY:(-1+y) andZ:(-1+z) andTextureX:TEX_COORD_MAX andTextureY:TEX_COORD_MAX];
        [self setVertexAt:6 andX:(1+x) andY:(-1+y) andZ:(-1+z) andTextureX:0 andTextureY:TEX_COORD_MAX];
        [self setVertexAt:7 andX:(-1+x) andY:(1+y) andZ:(-1+z) andTextureX:0 andTextureY:0];
        // Left
        [self setVertexAt:8 andX:(-1+x) andY:(-1+y) andZ:(1+z) andTextureX:TEX_COORD_MAX andTextureY:0];
        [self setVertexAt:9 andX:(-1+x) andY:(1+y) andZ:(1+z) andTextureX:TEX_COORD_MAX andTextureY:TEX_COORD_MAX];
        [self setVertexAt:10 andX:(-1+x) andY:(1+y) andZ:(-1+z) andTextureX:0 andTextureY:TEX_COORD_MAX];
        [self setVertexAt:11 andX:(-1+x) andY:(-1+y) andZ:(-1+z) andTextureX:0 andTextureY:0];
        // Right
        [self setVertexAt:12 andX:(1+x) andY:(-1+y) andZ:(-1+z) andTextureX:TEX_COORD_MAX andTextureY:0];
        [self setVertexAt:13 andX:(1+x) andY:(1+y) andZ:(-1+z) andTextureX:TEX_COORD_MAX andTextureY:TEX_COORD_MAX];
        [self setVertexAt:14 andX:(1+x) andY:(1+y) andZ:(1+z) andTextureX:0 andTextureY:TEX_COORD_MAX];
        [self setVertexAt:15 andX:(1+x) andY:(-1+y) andZ:(1+z) andTextureX:0 andTextureY:0];
        // Top
        [self setVertexAt:16 andX:(1+x) andY:(1+y) andZ:(1+z) andTextureX:TEX_COORD_MAX andTextureY:0];
        [self setVertexAt:17 andX:(1+x) andY:(1+y) andZ:(-1+z) andTextureX:TEX_COORD_MAX andTextureY:TEX_COORD_MAX];
        [self setVertexAt:18 andX:(-1+x) andY:(1+y) andZ:(-1+z) andTextureX:0 andTextureY:TEX_COORD_MAX];
        [self setVertexAt:19 andX:(-1+x) andY:(1+y) andZ:(1+z) andTextureX:0 andTextureY:0];
        // Bottom
        [self setVertexAt:20 andX:(1+x) andY:(-1+y) andZ:(-1+z) andTextureX:TEX_COORD_MAX andTextureY:0];
        [self setVertexAt:21 andX:(1+x) andY:(-1+y) andZ:(1+z) andTextureX:TEX_COORD_MAX andTextureY:TEX_COORD_MAX];
        [self setVertexAt:22 andX:(-1+x) andY:(-1+y) andZ:(1+z) andTextureX:0 andTextureY:TEX_COORD_MAX];
        [self setVertexAt:23 andX:(-1+x) andY:(-1+y) andZ:(-1+z) andTextureX:0 andTextureY:0];
        
        // Front
        [self setTriangleAt:0 withIndex1:0 andIndex2:1 andIndex3:2];
        [self setTriangleAt:1 withIndex1:2 andIndex2:3 andIndex3:0];
        // Back
        [self setTriangleAt:2 withIndex1:4 andIndex2:5 andIndex3:6];
        [self setTriangleAt:3 withIndex1:4 andIndex2:5 andIndex3:7];
        // Left
        [self setTriangleAt:4 withIndex1:8 andIndex2:9 andIndex3:10];
        [self setTriangleAt:5 withIndex1:10 andIndex2:11 andIndex3:8];
        // Right
        [self setTriangleAt:6 withIndex1:12 andIndex2:13 andIndex3:14];
        [self setTriangleAt:7 withIndex1:14 andIndex2:15 andIndex3:12];
        // Top
        [self setTriangleAt:8 withIndex1:16 andIndex2:17 andIndex3:18];
        [self setTriangleAt:9 withIndex1:18 andIndex2:19 andIndex3:16];
        // Bottom
        [self setTriangleAt:10 withIndex1:20 andIndex2:21 andIndex3:22];
        [self setTriangleAt:11 withIndex1:22 andIndex2:23 andIndex3:20];
    }
    
    return self;
}

@end
