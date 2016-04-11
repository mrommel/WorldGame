//
//  MapPoint.h
//  AITest
//
//  Created by Michael Rommel on 17.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum HexDirection {
    HexDirectionNorthEast = 0,
    HexDirectionEast = 1,
    HexDirectionSouthEast = 2,
    HexDirectionSouthWest = 3,
    HexDirectionWest = 4,
    HexDirectionNorthWest = 5
} HexDirection;

#define HEXDIRECTIONS   [NSMutableArray arrayWithArray:@[@(HexDirectionNorthEast), @(HexDirectionEast), @(HexDirectionSouthEast), @(HexDirectionSouthWest), @(HexDirectionWest), @(HexDirectionNorthWest)]]

#define OPPOSITE_DIRECTION(direction) (((direction - 3) < 0) ? (direction + 3) : (direction - 3))

@interface MapPoint : NSObject

@property (atomic) NSInteger x;
@property (atomic) NSInteger y;

-(instancetype)initWithX:(NSInteger)nx andY:(NSInteger)ny;

- (MapPoint *)neighborInDirection:(HexDirection)dir;
- (BOOL)validForWidth:(NSInteger)width andHeight:(NSInteger)height;

@end

#define NO_FLOWDIRECTION                -1
#define NUM_FLOWDIRECTION_TYPES         6

#define FLOWDIRECTION_NORTH             0
#define FLOWDIRECTION_NORTHEAST         1
#define FLOWDIRECTION_SOUTHEAST         2
#define FLOWDIRECTION_SOUTH             3
#define FLOWDIRECTION_SOUTHWEST         4
#define FLOWDIRECTION_NORTHWEST         5

#define FLOWDIRECTION_NORTH_MASK		1
#define FLOWDIRECTION_SOUTH_MASK		2
#define FLOWDIRECTION_SOUTHEAST_MASK	4
#define FLOWDIRECTION_NORTHWEST_MASK	8
#define FLOWDIRECTION_SOUTHWEST_MASK	16
#define FLOWDIRECTION_NORTHEAST_MASK	32

//       1
//    /  |  \
//   6 \ | / 2
//   |   0   | n,s
//   5 / | \ 3
//    \  |  /
// nw,se 4 ne,sw
//
typedef enum FlowDirection {
    FlowDirectionNorth = FLOWDIRECTION_NORTH,
    FlowDirectionNorthEast = FLOWDIRECTION_NORTHEAST,
    FlowDirectionSouthEast = FLOWDIRECTION_SOUTHEAST,
    FlowDirectionSouth = FLOWDIRECTION_SOUTH,
    FlowDirectionSouthWest = FLOWDIRECTION_SOUTHWEST,
    FlowDirectionNorthWest = FLOWDIRECTION_NORTHWEST
} FlowDirection;

#define FlowDirectionString(enum) [@[@"North",@"NorthEast",@"SouthEast",@"South",@"SouthWest",@"NorthWest"] objectAtIndex:enum]

#define OPPOSITE_FLOWDIRECTION(direction) ((direction < 3) ? (direction + 3) : (direction - 3))

typedef enum HexPointCorner {
    HexPointCornerNorth = 6,
    HexPointCornerNorthEast = 7,
    HexPointCornerSouthEast = 8,
    HexPointCornerSouth = 9,
    HexPointCornerSouthWest = 10,
    HexPointCornerNorthWest = 11
} HexPointCorner;

#define CornerString(enum) [@[@"North",@"NorthEast",@"SouthEast",@"South",@"SouthWest",@"NorthWest"] objectAtIndex:(enum-6)]

/*!
 
 */
@interface MapPointWithCorner : MapPoint

@property (atomic, assign) HexPointCorner corner;

- (id)initWithX:(NSInteger)x andY:(NSInteger)y andCorner:(HexPointCorner)corner;
- (id)initWithHex:(MapPoint *)hex andCorner:(HexPointCorner)corner;

- (NSArray *)possibleFlowsFromCorner;
- (MapPointWithCorner *)nextCornerInFlowDirection:(FlowDirection)flowDirection;

@end