//
//  TerrainVertex.h
//  WorldGame
//
//  Created by Michael Rommel on 12.07.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MathHelper.h"

#define kVerticesPerTile 19
#define kIndicesPerTile 72

#define TRIANGLE(idx, v0, v1, v2)  indices[idx] = v0; indices[(idx + 1)] = v1; indices[(idx + 2)] = v2

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
    float TextureContributions[4];
} TerrainVertex;

static __inline__ TerrainVertex TerrainVertexMake(GLKVector3 pos, GLKVector2 tex, GLKVector4 contrib)
{
    TerrainVertex vertex;
    
    vertex.Position[0] = pos.x;
    vertex.Position[1] = pos.y;
    vertex.Position[2] = pos.z;
    vertex.Color[0] = 1;
    vertex.Color[1] = 1;
    vertex.Color[2] = 1;
    vertex.Color[3] = 1;
    vertex.TexCoord[0] = tex.x;
    vertex.TexCoord[1] = tex.y;
    vertex.TextureContributions[0] = contrib.x;
    vertex.TextureContributions[1] = contrib.y;
    vertex.TextureContributions[2] = contrib.z;
    vertex.TextureContributions[3] = contrib.w;
    
    return vertex;
}

static __inline__ NSString* TerrainVertexToString(TerrainVertex vertex)
{
    return [NSString stringWithFormat:@"TerrainVertex(%.2f, %.2f, %.2f - %.2f, %.2f)", vertex.Position[0], vertex.Position[1], vertex.Position[2], vertex.TexCoord[0], vertex.TexCoord[1]];
}

static __inline__ void TerrainVertexSetHeight(TerrainVertex *vertex, float height)
{
    vertex->Position[1] = -height;
}

static __inline__ void TerrainVertexSetContribution(TerrainVertex *vertex, GLKVector4 contrib)
{
    vertex->TextureContributions[0] = contrib.x;
    vertex->TextureContributions[1] = contrib.y;
    vertex->TextureContributions[2] = contrib.z;
    vertex->TextureContributions[3] = contrib.w;
}

typedef unsigned int TerrainIndex;


