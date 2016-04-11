//
//  MapPoint.m
//  AITest
//
//  Created by Michael Rommel on 17.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MapPoint.h"

#import "Plot.h"

static NSString* const MapPointXKey = @"MapPoint.X";
static NSString* const MapPointYKey = @"MapPoint.Y";

@implementation MapPoint
       
-(instancetype)initWithX:(NSInteger)nx andY:(NSInteger)ny
{
    self = [super init];
    
    if (self) {
        self.x = nx; self.y = ny;
    }
    
    return self;
}

#pragma mark -
#pragma mark serialize functions

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    
    if (self) {
        self.x = [decoder decodeIntegerForKey:MapPointXKey];
        self.y = [decoder decodeIntegerForKey:MapPointYKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.x forKey:MapPointXKey];
    [encoder encodeInteger:self.y forKey:MapPointYKey];
}

#pragma mark -
#pragma mark util functions

- (MapPoint *)neighborInDirection:(HexDirection)dir
{
    switch (dir) {
        case HexDirectionNorthEast:
            if (EVEN(self.x)) {
                return [[MapPoint alloc] initWithX:self.x andY:self.y-1];
            } else {
                return [[MapPoint alloc] initWithX:self.x+1 andY:self.y-1];
            }
            break;
        case HexDirectionEast:
            if (EVEN(self.x)) {
                return [[MapPoint alloc] initWithX:self.x+1 andY:self.y];
            } else {
                return [[MapPoint alloc] initWithX:self.x+1 andY:self.y];
            }
            break;
        case HexDirectionSouthEast:
            if (EVEN(self.x)) {
                return [[MapPoint alloc] initWithX:self.x andY:self.y+1];
            } else {
                return [[MapPoint alloc] initWithX:self.x+1 andY:self.y+1];
            }
            break;
        case HexDirectionSouthWest:
            if (EVEN(self.x)) {
                return [[MapPoint alloc] initWithX:self.x-1 andY:self.y+1];
            } else {
                return [[MapPoint alloc] initWithX:self.x andY:self.y+1];
            }
            break;
        case HexDirectionWest:
            if (EVEN(self.x)) {
                return [[MapPoint alloc] initWithX:self.x-1 andY:self.y];
            } else {
                return [[MapPoint alloc] initWithX:self.x-1 andY:self.y];
            }
            break;
        case HexDirectionNorthWest:
            if (EVEN(self.x)) {
                return [[MapPoint alloc] initWithX:self.x-1 andY:self.y-1];
            } else {
                return [[MapPoint alloc] initWithX:self.x andY:self.y-1];
            }
            break;
        default:
            return nil;
    }
}

- (BOOL)validForWidth:(NSInteger)width andHeight:(NSInteger)height
{
    return 0 <= self.x && self.x < width && 0 <= self.y && self.y < height;
}

@end

@implementation MapPointWithCorner

- (id)initWithX:(NSInteger)x andY:(NSInteger)y andCorner:(HexPointCorner)corner
{
    self = [super initWithX:x andY:y];
    
    if (self) {
        self.corner = corner;
    }
    
    return self;
}

- (id)initWithHex:(MapPoint *)hex andCorner:(HexPointCorner)corner
{
    self = [super initWithX:hex.x andY:hex.y];
    
    if (self) {
        self.corner = corner;
    }
    
    return self;
}

- (NSArray *)possibleFlowsFromCorner
{
    NSMutableArray *flows = [[NSMutableArray alloc] init];
    
    switch (self.corner) {
        case HexPointCornerNorth: // 6 -> 0, 2, 4
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorth]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouthEast]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouthWest]];
            break;
        case HexPointCornerNorthEast:
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorthEast]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouth]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorthWest]];
            break;
        case HexPointCornerSouthEast:
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorth]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouthEast]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouthWest]];
            break;
        case HexPointCornerSouth:
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorthEast]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouth]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorthWest]];
            break;
        case HexPointCornerSouthWest:
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorth]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouthEast]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouthWest]];
            break;
        case HexPointCornerNorthWest:
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorthEast]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionSouth]];
            [flows addObject:[NSNumber numberWithInt:FlowDirectionNorthWest]];
            break;
    }
    
    return flows;
}

// this method has errors:
// - not all corners should exist since flows only have 3 positions
//   (so north and northwest corner should not be returned nor accepted)
//
//     n
//   /   ≠
// n       y
// |       |  north /
// |       |  south
// y       y
//   ≠   /  south west / north east
//  |  y
//  |
//  south east / north west
//
- (MapPointWithCorner *)nextCornerInFlowDirection:(FlowDirection)flowDirection
{
    MapPoint *neighbor;
    switch (self.corner) {
        case HexPointCornerNorth:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Not a valid corner: %@ for flow calculation.", CornerString(self.corner)];
            break;
        case HexPointCornerNorthEast:
            switch (flowDirection) {
                case FlowDirectionNorth:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionNorthEast:
                    neighbor = [self neighborInDirection:HexDirectionNorthEast];
                    return [[MapPointWithCorner alloc] initWithHex:neighbor andCorner:HexPointCornerSouthEast];
                    break;
                case FlowDirectionSouthEast:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionSouth:
                    return [[MapPointWithCorner alloc] initWithHex:self andCorner:HexPointCornerSouthEast];
                    break;
                case FlowDirectionSouthWest:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionNorthWest:
                    neighbor = [self neighborInDirection:HexDirectionNorthWest];
                    return [[MapPointWithCorner alloc] initWithHex:neighbor andCorner:HexPointCornerSouthEast];
                    break;
            }
            break;
        case HexPointCornerSouthEast:
            switch (flowDirection) {
                case FlowDirectionNorth:
                    return [[MapPointWithCorner alloc] initWithHex:self andCorner:HexPointCornerNorthEast];
                    break;
                case FlowDirectionNorthEast:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionSouthEast:
                    neighbor = [self neighborInDirection:HexDirectionEast];
                    return [[MapPointWithCorner alloc] initWithHex:neighbor andCorner:HexPointCornerSouth];
                    break;
                case FlowDirectionSouth:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionSouthWest:
                    return [[MapPointWithCorner alloc] initWithHex:self andCorner:HexPointCornerSouth];
                    break;
                case FlowDirectionNorthWest:
                    // NOOP - will raise exception
                    break;
            }
            break;
        case HexPointCornerSouth:
            switch (flowDirection) {
                case FlowDirectionNorth:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionNorthEast:
                    return [[MapPointWithCorner alloc] initWithHex:self andCorner:HexPointCornerSouthEast];
                    break;
                case FlowDirectionSouthEast:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionSouth:
                    neighbor = [self neighborInDirection:HexDirectionSouthEast];
                    return [[MapPointWithCorner alloc] initWithHex:neighbor andCorner:HexPointCornerSouthWest];
                    break;
                case FlowDirectionSouthWest:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionNorthWest:
                    return [[MapPointWithCorner alloc] initWithHex:self andCorner:HexPointCornerSouthWest];
                    break;
            }
            break;
        case HexPointCornerSouthWest:
            switch (flowDirection) {
                case FlowDirectionNorth:
                    neighbor = [self neighborInDirection:HexDirectionNorthWest];
                    return [[MapPointWithCorner alloc] initWithHex:neighbor andCorner:HexPointCornerSouth];
                    break;
                case FlowDirectionNorthEast:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionSouthEast:
                    return [[MapPointWithCorner alloc] initWithHex:self andCorner:HexPointCornerSouth];
                    break;
                case FlowDirectionSouth:
                    // NOOP - will raise exception
                    break;
                case FlowDirectionSouthWest:
                    neighbor = [self neighborInDirection:HexDirectionWest];
                    return [[MapPointWithCorner alloc] initWithHex:neighbor andCorner:HexPointCornerSouthWest];
                    break;
                case FlowDirectionNorthWest:
                    // NOOP - will raise exception
                    break;
            }
            break;
        case HexPointCornerNorthWest:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Not a valid corner: %@ for flow calculation.", CornerString(self.corner)];
            break;
    }
    
    [NSException raise:NSInternalInconsistencyException
                format:@"Cannot find next corner for (%ld,%ld) at corner %@ in direction %@", (long)self.x, (long)self.y, CornerString(self.corner), FlowDirectionString(flowDirection)];
    return nil;
}

@end
