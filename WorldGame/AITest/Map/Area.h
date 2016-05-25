//
//  Area.h
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

@class Area;
@class Plot;

/*!
 class that holds the bounding box
 */
@interface AreaBounds : NSObject

@property (atomic) NSInteger eastEdge;
@property (atomic) NSInteger westEdge;
@property (atomic) NSInteger northEdge;
@property (atomic) NSInteger southEdge;

- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithEastEdge:(NSInteger)eastEdge westEdge:(NSInteger)westEdge northEdge:(NSInteger)northEdge andSouthEdge:(NSInteger)southEdge NS_DESIGNATED_INITIALIZER;

- (BOOL)isTallerThanWide;

- (BOOL)containsX:(NSInteger)x andY:(NSInteger)y;

/*!
 size of the bounding box (rect)
 */
- (NSInteger)size;

- (NSString *)description;

@end

/*!
 callback for area splitting
 */
typedef void (^AreaSplitCallback)(Area *first, Area *second);

/*!
 callback for area tile evaluation
 */
typedef NSInteger (^AreaTileEvaluatorCallback)(Plot *plot);

/*!
 class that consists of tiles within bounds
 */
@interface Area : NSObject

@property (nonatomic) AreaBounds *bounds;
@property (nonatomic) NSMutableArray *tiles;

/*!
 creates new area
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;

/*!
 creates new area from bounds
 */
- (instancetype)initWithBounds:(AreaBounds *)bounds NS_DESIGNATED_INITIALIZER;

/*!
 number of tiles
 */
- (NSInteger)size;

- (CGPoint)center;

- (CGFloat)distanceTo:(Area *)area;

- (void)divideIntoTwoAreas:(AreaSplitCallback)areaSplitCallback andSplitByPercent:(NSInteger)chopPercent;

- (Plot *)maximumTileFromEvaluator:(AreaTileEvaluatorCallback)evaluatorCallback;

- (NSString *)description;

@end

