//
//  HexagonMapMesh.m
//  SimWorld
//
//  Created by Michael Rommel on 16.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "CombatBoardMesh.h"

#import "Array2D.h"

#define kSpaceZ 0.8f

@implementation CombatBoardMesh
/*
- (id)initWithMap:(HexagonMap *)map andTerrainAtlas:(TextureAtlas *)textureAtlas andRiverAtlas:(TextureAtlas *)riverAtlas
{
    int numberOfTiles = map.size.width * map.size.height;
    self = [super initWithNumberOfVertices:7*numberOfTiles andNumberOfIndices:18*numberOfTiles andTexture:textureAtlas.texture];
    self.riverTexture = riverAtlas.texture;
    
    if (self) {
        HexagonMapItem *item = nil;
        int tileIndex = 0;
        float x, y, z, centerY;
        for (int ix = 0; ix < map.size.width; ix++) {
            for (int iy = 0; iy < map.size.height; iy++) {
                item = [map.tiles objectAtX:ix andY:iy];
                tileIndex = ix + iy * map.size.width;
                
                [HexPoint hexWithX:ix andY:iy toX:&x andY:&z];
                y = 0;
                centerY = 0;
                
                //      1
                //   /  |  \
                //  6 \ | / 2
                //  |   0   |
                //  5 / | \ 3
                //   \  |  /
                //      4
                CGRect tileRect = [textureAtlas tileForName:item.terrain];
                CGFloat ox = tileRect.origin.x;
                CGFloat oy = tileRect.origin.y;
                CGFloat ow = tileRect.size.width;
                CGFloat oh = tileRect.size.height;
                
                CGRect riverRect = [riverAtlas tileForName:[item.river atlasName]];
                CGFloat tx = riverRect.origin.x;
                CGFloat ty = riverRect.origin.y;
                CGFloat tw = riverRect.size.width;
                CGFloat th = riverRect.size.height;
                
                int ti = tileIndex * 7;
                [self setVertexAt:ti + 0 andX:(0.0f+x) andY:y+centerY andZ:(0.0f+z)
                      andTextureX:ox+ow*0.5f andTextureY:oy+oh*0.5f
                     andTextureX2:tx+tw*0.5f andTextureY2:ty+th*0.5f];
                [self setVertexAt:ti + 1 andX:(0.0f+x) andY:y andZ:(-0.5f+z)
                      andTextureX:ox+ow*0.5f andTextureY:oy+oh*0.0f
                     andTextureX2:tx+tw*0.5f andTextureY2:ty+th*0.0f];
                [self setVertexAt:ti + 2 andX:(0.5f+x) andY:y andZ:(-0.3f+z)
                      andTextureX:ox+ow*1.0f andTextureY:oy+oh*0.3f
                     andTextureX2:tx+tw*1.0f andTextureY2:ty+th*0.3f];
                [self setVertexAt:ti + 3 andX:(0.5f+x) andY:y andZ:(0.3f+z)
                      andTextureX:ox+ow*1.0f andTextureY:oy+oh*0.7f
                     andTextureX2:tx+tw*1.0f andTextureY2:ty+th*0.7f];
                [self setVertexAt:ti + 4 andX:(0.0f+x) andY:y andZ:(0.5f+z)
                      andTextureX:ox+ow*0.5f andTextureY:oy+oh*1.0f
                     andTextureX2:tx+tw*0.5f andTextureY2:ty+th*1.0f];
                [self setVertexAt:ti + 5 andX:(-0.5f+x) andY:y andZ:(0.3f+z)
                      andTextureX:ox+ow*0.0f andTextureY:oy+oh*0.7f
                     andTextureX2:tx+tw*0.0f andTextureY2:ty+th*0.7f];
                [self setVertexAt:ti + 6 andX:(-0.5f+x) andY:y andZ:(-0.3f+z)
                      andTextureX:ox+ow*0.0f andTextureY:oy+oh*0.3f
                     andTextureX2:tx+tw*0.0f andTextureY2:ty+th*0.3f];
                
                [self setTriangleAt:tileIndex*6+0 withIndex1:ti+0 andIndex2:ti+1 andIndex3:ti+2];
                [self setTriangleAt:tileIndex*6+1 withIndex1:ti+0 andIndex2:ti+2 andIndex3:ti+3];
                [self setTriangleAt:tileIndex*6+2 withIndex1:ti+0 andIndex2:ti+3 andIndex3:ti+4];
                [self setTriangleAt:tileIndex*6+3 withIndex1:ti+0 andIndex2:ti+4 andIndex3:ti+5];
                [self setTriangleAt:tileIndex*6+4 withIndex1:ti+0 andIndex2:ti+5 andIndex3:ti+6];
                [self setTriangleAt:tileIndex*6+5 withIndex1:ti+0 andIndex2:ti+6 andIndex3:ti+1];
            }
        }
    }
    
    return self;
} */

@end
