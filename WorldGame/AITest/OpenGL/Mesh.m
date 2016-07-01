//
//  Mesh.m
//  SimWorld
//
//  Created by Michael Rommel on 14.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "Mesh.h"

#import "OpenGLUtil.h"

@implementation Mesh

- (id)initWithNumberOfVertices:(NSUInteger)numberOfVertices
            andNumberOfIndices:(NSUInteger)numberOfIndices
                    andTexture:(GLuint)texture
{
    self = [super init];
    
    if (self) {
        [self populateWithNumberOfVertices:numberOfVertices andNumberOfIndices:numberOfIndices];
        self.texture = texture;
    }
    
    return self;
}

- (id)initWithNumberOfVertices:(NSUInteger)numberOfVertices
            andNumberOfIndices:(NSUInteger)numberOfIndices
                andTextureFile:(NSString *)textureFile
{
    self = [super init];
    
    if (self) {
        
        self.texture = [[OpenGLUtil sharedInstance] setupTexture:textureFile];
    }
    
    return self;
}

- (void)populateWithNumberOfVertices:(NSUInteger)numberOfVertices
                  andNumberOfIndices:(NSUInteger)numberOfIndices
{
    self.vertices = malloc(numberOfVertices * sizeof(Vertex));
    self.numberOfVertices = numberOfVertices;
    self.indices = malloc(numberOfIndices * sizeof(Index));
    self.numberOfIndices = numberOfIndices;
}

- (void)setVertexAt:(int)index
               andX:(float)x andY:(float)y andZ:(float)z
        andTextureX:(float)tx andTextureY:(float)ty
{
    self.vertices[index].Color[0] = 1;
    self.vertices[index].Color[1] = 1;
    self.vertices[index].Color[2] = 1;
    self.vertices[index].Color[3] = 1;
    self.vertices[index].Position[0] = x;
    self.vertices[index].Position[1] = y;
    self.vertices[index].Position[2] = z;
    self.vertices[index].TexCoord[0] = tx;
    self.vertices[index].TexCoord[1] = ty;
    self.vertices[index].TexCoord2[0] = 0;
    self.vertices[index].TexCoord2[1] = 0;
}

- (void)setVertexAt:(int)index
               andX:(float)x
               andY:(float)y
               andZ:(float)z
        andTextureX:(float)tx
        andTextureY:(float)ty
          andColorA:(float)colorA
          andColorR:(float)colorR
          andColorG:(float)colorG
          andColorB:(float)colorB
{
    self.vertices[index].Color[0] = colorA;
    self.vertices[index].Color[1] = colorR;
    self.vertices[index].Color[2] = colorG;
    self.vertices[index].Color[3] = colorB;
    self.vertices[index].Position[0] = x;
    self.vertices[index].Position[1] = y;
    self.vertices[index].Position[2] = z;
    self.vertices[index].TexCoord[0] = tx;
    self.vertices[index].TexCoord[1] = ty;
    self.vertices[index].TexCoord2[0] = 0;
    self.vertices[index].TexCoord2[1] = 0;
}

- (void)setVertexAt:(int)index
               andX:(float)x andY:(float)y andZ:(float)z
        andTextureX:(float)tx andTextureY:(float)ty
       andTextureX2:(float)tx2 andTextureY2:(float)ty2
{
    self.vertices[index].Color[0] = 1;
    self.vertices[index].Color[1] = 1;
    self.vertices[index].Color[2] = 1;
    self.vertices[index].Color[3] = 1;
    self.vertices[index].Position[0] = x;
    self.vertices[index].Position[1] = y;
    self.vertices[index].Position[2] = z;
    self.vertices[index].TexCoord[0] = tx;
    self.vertices[index].TexCoord[1] = ty;
    self.vertices[index].TexCoord2[0] = tx2;
    self.vertices[index].TexCoord2[1] = ty2;
}

- (void)setTriangleAt:(int)index
           withIndex1:(int)i1 andIndex2:(int)i2 andIndex3:(int)i3
{
    self.indices[index*3] = i1;
    self.indices[index*3+1] = i2;
    self.indices[index*3+2] = i3;
}

- (void)setIndexAt:(int)index
           toIndex:(int)indexValue
{
    self.indices[index] = indexValue;
}

- (void)moveWithX:(float)dx andY:(float)dy andZ:(float)dz
{
    for (int i = 0; i < self.numberOfVertices; i++) {
        self.vertices[i].Position[0] += dx;
        self.vertices[i].Position[1] += dy;
        self.vertices[i].Position[2] += dz;
    }
}

@end
