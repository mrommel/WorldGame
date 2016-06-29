//
//  CombatBoard.h
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Plot.h"

@class Map;
@class CombatBoard;
@class Army;

/*!
 
 */
@interface CombatBoardTile : NSObject

@property (atomic) int x;
@property (atomic) int y;
@property (nonatomic) MapTerrain terrain;
@property (nonatomic) CombatBoard* board;

- (instancetype)initWithX:(int)x andY:(int)y onBoard:(CombatBoard *)board;

@end

/*!
 Board that is used for combats between armies
 
 // #####
 // #####
 // #####
 // ----- (river?)
 // *****
 // *****
 // *****
 */
@interface CombatBoard : NSObject

- (instancetype)initWithAttackerPosition:(CGPoint)attackerPosition andDefenderPosition:(CGPoint)defenderPosition onMap:(Map *)map;

- (CombatBoardTile *)tileAtX:(int)x andY:(int)y;

- (void)setAttackerArmy:(Army *)army;
- (void)setDefenderArmy:(Army *)army;

@end
