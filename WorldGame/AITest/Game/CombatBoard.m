//
//  CombatBoard.m
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "CombatBoard.h"

#import "Array2D.h"
#import "Map.h"

@implementation CombatBoardTile

- (instancetype)initWithX:(int)x andY:(int)y onBoard:(CombatBoard *)board
{
    self = [super init];
    
    if (self) {
        self.x = x;
        self.y = y;
        self.board = board;
        self.terrain = MapTerrainDefault;
    }
    
    return self;
}

@end

#pragma mark -

@interface CombatBoard()

@property (nonatomic) Array2D *board;

@end

@implementation CombatBoard

- (instancetype)initWithAttackerPosition:(CGPoint)attackerPosition andDefenderPosition:(CGPoint)defenderPosition onMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.board = [[Array2D alloc] initWithSize:CGSizeMake(5, 6)];
        
        MapTerrain attackerTerrain = [map tileAtX:attackerPosition.x andY:attackerPosition.y].terrain;
        MapTerrain defenderTerrain = [map tileAtX:defenderPosition.x andY:defenderPosition.y].terrain;
        
        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 3; y++) {
                CombatBoardTile *boardTile = [[CombatBoardTile alloc] initWithX:x andY:y onBoard:self];
                boardTile.terrain = attackerTerrain;
                [self.board setObject:boardTile atX:x andY:y];
            }
        }
        
        for (int x = 0; x < 5; x++) {
            for (int y = 3; y < 6; y++) {
                CombatBoardTile *boardTile = [[CombatBoardTile alloc] initWithX:x andY:y onBoard:self];
                boardTile.terrain = defenderTerrain;
                [self.board setObject:boardTile atX:x andY:y];
            }
        }
    }
    
    return self;
}

- (CombatBoardTile *)tileAtX:(int)x andY:(int)y
{
    return [self.board objectAtX:x andY:y];
}

- (void)setAttackerArmy:(Army *)army
{
    
}

- (void)setDefenderArmy:(Army *)army
{
    
}

@end
