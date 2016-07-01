//
//  HexagonMapMesh.m
//  SimWorld
//
//  Created by Michael Rommel on 16.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "CombatBoardMesh.h"

#import "Array2D.h"
#import "Plot.h"

#define kSpaceZ 0.8f

@implementation CombatBoardMesh

- (id)initWithBoard:(CombatBoard *)board andTerrainAtlas:(TextureAtlas *)textureAtlas andRiverAtlas:(TextureAtlas *)riverAtlas
{
    int numberOfTiles = 5 * 6;
    self = [super initWithNumberOfVertices:4*numberOfTiles andNumberOfIndices:6*numberOfTiles andTexture:textureAtlas.texture];
    self.riverTexture = riverAtlas.texture;
    
    if (self) {
        CombatBoardTile *item = nil;
        int tileIndex = 0;
        float x, y, z;
        
        // 0 ----- 1
        // |     / |
        // |   /   |
        // | /     |
        // 2 ----- 3
        for (int ix = 0; ix < 5; ix++) {
            for (int iy = 0; iy < 6; iy++) {
                item = [board tileAtX:ix andY:iy];
                tileIndex = ix + iy * 5;
                
                x = ix * 10;
                y = 0;
                z = iy * 10;
        
                CGRect tileRect = [textureAtlas tileForName:[[MapDataProvider sharedInstance] atlasKeyForMapTerrain:item.terrain]];
                CGFloat ox = tileRect.origin.x;
                CGFloat oy = tileRect.origin.y;
                CGFloat ow = tileRect.size.width;
                CGFloat oh = tileRect.size.height;
                
                CGRect riverRect = [riverAtlas tileForName:@""];
                CGFloat tx = riverRect.origin.x;
                CGFloat ty = riverRect.origin.y;
                CGFloat tw = riverRect.size.width;
                CGFloat th = riverRect.size.height;
                
                int ti = tileIndex * 4;
                [self setVertexAt:ti + 0 andX:(0.0f+x) andY:y andZ:(0.0f+z)
                      andTextureX:ox+ow*0.0f andTextureY:oy+oh*0.0f
                     andTextureX2:tx+tw*0.0f andTextureY2:ty+th*0.0f];
                [self setVertexAt:ti + 1 andX:(10.0f+x) andY:y andZ:(0.0f+z)
                      andTextureX:ox+ow*1.0f andTextureY:oy+oh*0.0f
                     andTextureX2:tx+tw*1.0f andTextureY2:ty+th*0.0f];
                [self setVertexAt:ti + 2 andX:(0.0f+x) andY:y andZ:(10.0+z)
                      andTextureX:ox+ow*0.0f andTextureY:oy+oh*1.0f
                     andTextureX2:tx+tw*0.0f andTextureY2:ty+th*1.0f];
                [self setVertexAt:ti + 3 andX:(10.0f+x) andY:y andZ:(10.0f+z)
                      andTextureX:ox+ow*1.0f andTextureY:oy+oh*1.0f
                     andTextureX2:tx+tw*1.0f andTextureY2:ty+th*1.0f];
                
                [self setTriangleAt:tileIndex*2+0 withIndex1:ti+0 andIndex2:ti+1 andIndex3:ti+2];
                [self setTriangleAt:tileIndex*2+1 withIndex1:ti+1 andIndex2:ti+3 andIndex3:ti+2];
            }
        }
    }
    
    return self;
}

@end
