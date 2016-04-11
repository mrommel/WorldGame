//
//  MapTile.h
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;
@class Continent;

#import "MapPoint.h"
#import "BitArray.h"
#import "RelationsNetwork.h"

#define EVEN(x)     ((x % 2) == 0)
#define ODD(x)     ((x % 2) == 1)

typedef NS_ENUM(NSInteger, MapTerrain) {
    MapTerrainDefault,
    MapTerrainOcean,
    MapTerrainShore,
    MapTerrainGrass,
    MapTerrainPlain,
    MapTerrainDesert,
    MapTerrainTundra,
    MapTerrainSnow
};

@interface MapTerrainData : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *image;
@property (nonatomic) NSMutableArray *possibleFeatures;

@end

typedef NS_ENUM(NSInteger, MapFeature) {
    MapFeatureDefault,
    MapFeatureHills,
    MapFeatureMountains,
    MapFeatureIce,
    MapFeatureJungle,
    MapFeatureForest,
    MapFeatureLake
};

@interface MapFeatureData : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *image;

@end

@interface MapDataProvider : NSObject

+ (MapDataProvider *)sharedInstance;

- (MapTerrainData *)terrainDataForMapTerrain:(MapTerrain)terrain;
- (MapFeatureData *)featureDataForMapFeature:(MapFeature)feature;

@end



/*!
 plot, each tile
 */
@interface Plot : NSObject<NSCoding>

@property (nonatomic) MapPoint *coordinate;
@property (atomic) MapTerrain terrain;
@property (nonatomic) NSMutableArray *features;

@property (nonatomic, setter=setOwner:) Player *owner;
//@property (nonatomic) Area *area;
@property (nonatomic) Continent *continent;
@property (nonatomic) BitArray *revealed;
@property (nonatomic) RelationsNetwork *network;

// simulation values
@property (atomic) float inhabitants;
/*@property (atomic) float soilQuality;
@property (atomic) int soilAcres; // define the amount of soil
@property (atomic) float health; // quality of average health*/

- (instancetype)initWithX:(int)nx andY:(int)ny andTerrain:(MapTerrain)ntype;
- (instancetype)initWithCoord:(MapPoint *)ncoord andTerrain:(MapTerrain)ntype;

// feature functions
- (void)addFeature:(MapFeature)feature;
- (BOOL)hasFeature:(MapFeature)feature;

// river functions
- (void)setRiver:(BOOL)hasRiver;
- (BOOL)hasRiver;

// player functions
- (void)settleWithPlayer:(Player *)player;
- (BOOL)claimWithPlayer:(Player *)player;

- (BOOL)isLandmass;
- (BOOL)isOcean;

- (void)setOwner:(Player *)owner;

- (BOOL)isStartingPlot;
- (void)setStartingPlot:(BOOL)bNewValue;

// turn methods
- (void)turn;

@end
