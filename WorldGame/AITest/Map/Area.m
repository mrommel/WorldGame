//
//  Area.m
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Area.h"
#import "Plot.h"

@implementation AreaBounds

- (instancetype)init
{
    self = [super init];
    
    return self;
}

- (instancetype)initWithEastEdge:(NSInteger)eastEdge westEdge:(NSInteger)westEdge northEdge:(NSInteger)northEdge andSouthEdge:(NSInteger)southEdge
{
    self = [super init];
    
    if (self) {
        self.eastEdge = eastEdge;
        self.westEdge = westEdge;
        self.northEdge = northEdge;
        self.southEdge = southEdge;
    }
    
    return self;
}

- (BOOL)isTallerThanWide
{
    return ABS(self.northEdge - self.southEdge) > ABS(self.eastEdge - self.westEdge);
}

- (BOOL)containsX:(NSInteger)x andY:(NSInteger)y
{
    return self.westEdge <= x && x <= self.eastEdge && self.northEdge <= y && y <= self.southEdge;
}

- (CGPoint)center
{
    return CGPointMake((self.westEdge + self.eastEdge) / 2.0f, (self.northEdge + self.southEdge) / 2.0f);
}

- (NSInteger)size
{
    return ABS(self.eastEdge - self.westEdge) * ABS(self.northEdge - self.southEdge);
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[AreaBounds east:%ld, west:%ld, north:%ld, south:%ld => size:%ld]", (long)self.eastEdge, (long)self.westEdge, (long)self.northEdge, (long)self.southEdge, (long)[self size]];
}

@end

#pragma mark -

@implementation Area

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.bounds = [AreaBounds new];
        self.tiles = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype)initWithBounds:(AreaBounds *)bounds
{
    self = [super init];
    
    if (self) {
        self.bounds = bounds;
        self.tiles = [NSMutableArray new];
    }
    
    return self;
}

- (NSInteger)size
{
    return [self.tiles count];
}

- (CGPoint)center
{
    return [self.bounds center];
}

- (CGFloat)distanceTo:(Area *)area
{
    CGPoint p1 = [area center];
    CGPoint p2 = [self center];
    CGFloat xDist = (p2.x - p1.x); //[2]
    CGFloat yDist = (p2.y - p1.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    
    return distance;
}

- (void)divideIntoTwoAreas:(AreaSplitCallback)areaSplitCallback andSplitByPercent:(NSInteger)chopPercent
{
    if (!areaSplitCallback) {
        return;
    }
    
    // How much fertility do we want in the first region?
    NSInteger uiTargetSize = [self size] * chopPercent / 100L;
    NSInteger uiSizeSoFar = 0L;
    
    Area *firstArea = [Area new];
    Area *secondArea = [Area new];
    
    if ([self.bounds isTallerThanWide]) {
        // Taller than wide
        
        // Move up one row at a time until we have exceeded the target size
        NSInteger northEdgeTmp = self.bounds.northEdge;
        while (uiSizeSoFar < uiTargetSize) {
            uiSizeSoFar += [self computeAreaSizeWithWestEdge:self.bounds.westEdge eastEdge:self.bounds.eastEdge northEdge:northEdgeTmp andSouthEdge:northEdgeTmp];
            northEdgeTmp++;
        }
        
        firstArea.bounds.northEdge = self.bounds.northEdge;
        firstArea.bounds.southEdge = northEdgeTmp;
        firstArea.bounds.westEdge = self.bounds.westEdge;
        firstArea.bounds.eastEdge = self.bounds.eastEdge;
        
        secondArea.bounds.northEdge = northEdgeTmp + 1;
        secondArea.bounds.southEdge = self.bounds.southEdge;
        secondArea.bounds.westEdge = self.bounds.westEdge;
        secondArea.bounds.eastEdge = self.bounds.eastEdge;
    } else {
        // Wider than tall
        
        // Move right one column at a time until we have exceeded the target fertility
        NSInteger eastEdgeTmp = self.bounds.westEdge;
        while (uiSizeSoFar < uiTargetSize) {
            uiSizeSoFar += [self computeAreaSizeWithWestEdge:eastEdgeTmp eastEdge:eastEdgeTmp northEdge:self.bounds.northEdge andSouthEdge:self.bounds.southEdge];
            eastEdgeTmp++;
        }
        
        firstArea.bounds.northEdge = self.bounds.northEdge;
        firstArea.bounds.southEdge = self.bounds.southEdge;
        firstArea.bounds.westEdge = self.bounds.westEdge;
        firstArea.bounds.eastEdge = eastEdgeTmp;
        
        secondArea.bounds.northEdge = self.bounds.northEdge;
        secondArea.bounds.southEdge = self.bounds.southEdge;
        secondArea.bounds.westEdge = eastEdgeTmp + 1;
        secondArea.bounds.eastEdge = self.bounds.eastEdge;
    }
    
    // distribute the tiles to the new areas
    for (NSInteger y = self.bounds.northEdge; y <= self.bounds.southEdge; y++) {
        for (NSInteger x = self.bounds.westEdge; x <= self.bounds.eastEdge; x++) {
            Plot *plot = [self tileAtX:x andY:y];
            if (plot != nil) {
                if ([firstArea.bounds containsX:x andY:y]) {
                    [firstArea.tiles addObject:plot];
                } else {
                    [secondArea.tiles addObject:plot];
                }
            }
        }
    }

    // return the values
    areaSplitCallback(firstArea, secondArea);
    
    return;
}

- (Plot *)maximumTileFromEvaluator:(AreaTileEvaluatorCallback)evaluatorCallback
{
    if (!evaluatorCallback) {
        return nil;
    }
    
    Plot *bestPlot = nil;
    NSInteger maximumValue = NSIntegerMin;
    
    for (Plot *plot in self.tiles) {
        NSInteger value = evaluatorCallback(plot);
        
        if (value > maximumValue) {
            maximumValue = value;
            bestPlot = plot;
        }
    }
    
    return bestPlot;
}

/// Totals up the fertility of one row of data
- (NSInteger)computeAreaSizeWithWestEdge:(NSInteger)xMin eastEdge:(NSInteger)xMax northEdge:(NSInteger)yMin andSouthEdge:(NSInteger)yMax
{
    NSInteger rtnValue = 0;
    
    for (NSInteger y = yMin; y <= yMax; y++) {
        for (NSInteger x = xMin; x <= xMax; x++) {
            if ([self tileAtX:x andY:y] != nil) {
                rtnValue++;
            }
        }
    }
    
    return rtnValue;
}

- (Plot *)tileAtX:(NSInteger)x andY:(NSInteger)y
{
    for (Plot *tile in self.tiles) {
        if (tile.coordinate.x == x && tile.coordinate.y == y) {
            return tile;
        }
    }
    
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Area bounds:%@, size:%ld]", self.bounds, (long)[self size]];
}

@end
