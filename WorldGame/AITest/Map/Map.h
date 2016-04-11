//
//  Map.h
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Plot.h"

// 
typedef NS_ENUM(NSInteger, MapType) {
    MapTypeDefault,
    MapTypeBipolar,
    MapTypePangea,
    MapTypeContinents
};

//
typedef NS_ENUM(NSInteger, MapSize) {
    MapSizeDefault,
    MapSizeDuel,
    MapSizeTiny,
    MapSizeSmall,
    MapSizeStandard,
    MapSizeLarge,
    MapSizeHuge
};

/*!
 class for the map generator options
 */
@interface MapOptions : NSObject

@property (atomic) MapType mapType;
@property (atomic) MapSize mapSize;
@property (atomic) int numRivers;
@property (atomic) int numLakes;

- (instancetype)initWithMapType:(MapType)mapType andSize:(MapSize)size;

@end

//
typedef void (^MapGenerateProgress)(int);

/*!
 class that represents a complete map
 */
@interface Map : NSObject<NSCoding>

@property (atomic, assign) NSInteger width;
@property (atomic, assign) NSInteger height;
@property (atomic) NSMutableArray *startPositions;

// constructors
- (instancetype)initWithWidth:(int)width andHeight:(int)height;
- (instancetype)initWithMapSize:(MapSize)mapSize;

// plot functions
- (BOOL)isValidAt:(MapPoint *)point;
- (BOOL)isValidAtX:(NSInteger)x andY:(NSInteger)y;
- (Plot *)tileAtX:(NSInteger)x andY:(NSInteger)y;

// terrain functions
- (MapTerrain)terrainAtX:(int)x andY:(int)y;
- (void)setTerrain:(MapTerrain)terrain atX:(int)x andY:(int)y;
- (BOOL)isOceanAtX:(int)x andY:(int)y;

// feature functions
- (void)addFeature:(MapFeature)feature atX:(int)x andY:(int)y;
- (BOOL)hasFeature:(MapFeature)feature atX:(int)x andY:(int)y;

// river functions
- (void)setRiver:(BOOL)hasRiver atX:(int)x andY:(int)y;
- (BOOL)hasRiverAtX:(int)x andY:(int)y;

// continent functions
- (Continent *)continentByIdentifier:(int)identifier;
- (void)addContinent:(Continent *)continent;

// map generators
- (void)generateMapWithOptions:(MapOptions *)options withProgress:(MapGenerateProgress)progress;

- (void)turn;

@end
