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
@class Map;
@class PlotEconomy;

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

@property (atomic) CGFloat soil;
@property (atomic) NSInteger acres;

#warning todo: wine has different acre needs than wheat
#warning todo: what about fishing?

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
 state of the plots population
 */
typedef NS_ENUM(NSInteger, PlotPopulationState) {
    PlotPopulationStateNomads,
    PlotPopulationStateVillage,
    PlotPopulationStateTown, // with some villages around
    PlotPopulationStateCity,
    PlotPopulationStateMetropol
};


/*!
 plot, each tile
 */
@interface Plot : NSObject<NSCoding>

@property (nonatomic) Map *map;

@property (nonatomic) MapPoint *coordinate;
@property (atomic) MapTerrain terrain;
@property (nonatomic) NSMutableArray *features;

//@property (nonatomic, setter=setOwner:) Player *owner;
@property (atomic) NSInteger ownerIdentifier;

//@property (nonatomic) Area *area;
@property (nonatomic) Continent *continent;
@property (nonatomic) RelationsNetwork *network;

// simulation values
@property (atomic) float inhabitants;
@property (atomic) PlotPopulationState populationState;

// economy values
@property (nonatomic) PlotEconomy *economy;
/*@property (atomic) float soilQuality;
@property (atomic) int soilAcres; // define the amount of soil
@property (atomic) float health; // quality of average health*/

- (instancetype)initWithX:(int)nx andY:(int)ny andTerrain:(MapTerrain)ntype onMap:(Map *)map;
- (instancetype)initWithCoord:(MapPoint *)ncoord andTerrain:(MapTerrain)ntype onMap:(Map *)map;

// terrain functions
- (MapTerrainData *)terrainData;

// feature functions
- (void)addFeature:(MapFeature)feature;
- (BOOL)hasFeature:(MapFeature)feature;

// river functions
- (void)setRiver:(BOOL)hasRiver;
- (BOOL)hasRiver;

// neighboring functions
- (BOOL)isCoastal;

// player functions
- (void)setVisible:(BOOL)visible forPlayer:(Player *)player;
- (BOOL)isVisibleForPlayer:(Player *)player;
- (void)setRevealed:(BOOL)revealed forPlayer:(Player *)player;
- (BOOL)isRevealedForPlayer:(Player *)player;

//- (void)settleWithPlayer:(Player *)player;
//- (BOOL)claimWithPlayer:(Player *)player;

- (BOOL)isLandmass;
- (BOOL)isOcean;

- (void)setOwner:(Player *)owner;

- (BOOL)isStartingPlot;
- (void)setStartingPlot:(BOOL)bNewValue;

// turn methods
- (void)turn;

@end
