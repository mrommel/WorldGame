//
//  HexagonMapMesh.h
//  SimWorld
//
//  Created by Michael Rommel on 16.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "Mesh.h"
#import "TextureAtlas.h"
#import "CombatBoard.h"

@protocol CombatMeshDelegate;

@interface CombatBoardMesh : Mesh

@property (nonatomic, assign) GLuint riverTexture;

- (id)initWithBoard:(CombatBoard *)board andTerrainAtlas:(TextureAtlas *)textureAtlas andRiverAtlas:(TextureAtlas *)riverAtlas;
//- (id)initWithBoard:(CombatBoard *)board andRiverAtlas:(TextureAtlas *)textureAtlas;

@end

@protocol CombatBoardMeshDelegate <NSObject>

- (CombatBoardTile *)combatBoardMesh:(CombatBoardMesh *)mesh didChooseX:(int)x andY:(int)yx;

@end
