//
//  MapTile.m
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Plot.h"

#import "XMLReader.h"
#import "NSDictionary+Extension.h"
#import "RelationsNetwork.h"
#import "NSArray+Util.h"
#import "Game.h"
#import "PlotEconomy.h"
#import "Simulation/Simulation.h"

#define NO_OWNER -1

static NSString* const PlotDataCoordinateKey = @"Plot.Coordinate";
static NSString* const PlotDataTerrainKey = @"Plot.Terrain";

static NSString* const PlotDataFeaturesKey = @"Plot.Features";
static NSString* const PlotDataFeatureKey = @"Plot.Feature.%d";
static NSString* const PlotDataInhabitantsKey = @"Plot.Inhabitants";
static NSString* const PlotDataPopulationStateKey = @"Plot.PopulationState";
static NSString* const PlotDataOwnerKey = @"Plot.Owner";
static NSString* const PlotDataStartingPlotKey = @"Plot.StartingPlot";

static NSString* const PlotDataRevealedKey = @"Plot.Revealed";
static NSString* const PlotDataVisibleKey = @"Plot.Visible";

static NSString* const kSCIENCEAGRICULTURE = @"SCIENCE_AGRICULTURE";

@interface MapDataProvider()

@property (nonatomic) NSMutableDictionary *terrains;
@property (nonatomic) NSMutableDictionary *features;

@end

@implementation MapDataProvider

static MapDataProvider *shared = nil;

+ (MapDataProvider *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[self alloc] init];
        }
    }
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.terrains = [NSMutableDictionary new];
        
        [self.terrains setObject:[self mapTerrainFromFile:@"Ocean"]
                          forKey:[self keyForTerrain:MapTerrainOcean]];
        [self.terrains setObject:[self mapTerrainFromFile:@"Plains"]
                          forKey:[self keyForTerrain:MapTerrainPlain]];
        [self.terrains setObject:[self mapTerrainFromFile:@"Grassland"]
                          forKey:[self keyForTerrain:MapTerrainGrass]];
        [self.terrains setObject:[self mapTerrainFromFile:@"Desert"]
                          forKey:[self keyForTerrain:MapTerrainDesert]];
        [self.terrains setObject:[self mapTerrainFromFile:@"Shore"]
                          forKey:[self keyForTerrain:MapTerrainShore]];
        [self.terrains setObject:[self mapTerrainFromFile:@"Snow"]
                          forKey:[self keyForTerrain:MapTerrainSnow]];
        [self.terrains setObject:[self mapTerrainFromFile:@"Tundra"]
                          forKey:[self keyForTerrain:MapTerrainTundra]];
        
        self.features = [NSMutableDictionary new];
        
        [self.features setObject:[self mapFeatureFromFile:@"Forest"]
                          forKey:[self keyForFeature:MapFeatureForest]];
    }
    
    return self;
}

- (MapTerrainData *)mapTerrainFromFile:(NSString *)filename
{
    NSDictionary *itemDict = [self dictFromName:filename];
    MapTerrainData *itemData = [[MapTerrainData alloc] init];
    itemData.name = [itemDict objectForPath:@"Terrain|Title|text"];
    itemData.image = [itemDict objectForPath:@"Terrain|ImageName|text"];
    itemData.possibleFeatures = [itemDict mutableArrayForPath:@"Terrain|PossibleFeatures|Item"];
    itemData.soil = [[itemDict objectForPath:@"Terrain|Soil|text"] floatValue];
    itemData.acres = [[itemDict objectForPath:@"Terrain|Acres|text"] integerValue];
    return itemData;
}

- (MapFeatureData *)mapFeatureFromFile:(NSString *)filename
{
    NSDictionary *itemDict = [self dictFromName:filename];
    MapFeatureData *itemData = [[MapFeatureData alloc] init];
    itemData.name = [itemDict objectForPath:@"Feature|Title|text"];
    itemData.image = [itemDict objectForPath:@"Feature|ImageName|text"];
    return itemData;
}

- (NSString *)keyForTerrain:(MapTerrain)terrain
{
    return [NSString stringWithFormat:@"terrain%d", (int)terrain];
}

- (NSString *)keyForFeature:(MapFeature)feature
{
    return [NSString stringWithFormat:@"feature%d", (int)feature];
}

- (NSDictionary *)dictFromName:(NSString *)fileName
{
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath1 options:NSDataReadingUncached error:&error];
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    return dict;
}

- (MapTerrainData *)terrainDataForMapTerrain:(MapTerrain)terrain
{
    return [self.terrains objectForKey:[self keyForTerrain:terrain]];
}

- (MapFeatureData *)featureDataForMapFeature:(MapFeature)feature
{
    return [self.features objectForKey:[self keyForFeature:feature]];
}

@end

@implementation MapTerrainData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _possibleFeatures = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)setPossibleFeatures:(NSMutableArray *)newPossibleFeatures
{
    for (NSDictionary *item in newPossibleFeatures) {
        id obj = [item objectForKey:@"text"];
        [self.possibleFeatures addObject:obj];
    }
}

@end

@implementation MapFeatureData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

@end

#pragma mark -

@interface Plot()

@property (atomic) BOOL _startingPlot;
@property (atomic) BOOL _river;
@property (nonatomic) BitArray *revealedArray;
@property (nonatomic) BitArray *visibleArray;

@end

@implementation Plot

- (instancetype)initWithX:(int)nx andY:(int)ny andTerrain:(MapTerrain)nterrain onMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.map = map;
        self.coordinate = [[MapPoint alloc] initWithX:nx andY:ny];
        self.terrain = nterrain;
        self.features = [[NSMutableArray alloc] init];
        self.inhabitants = 0;
        self.populationState = PlotPopulationStateNomads;
        self.ownerIdentifier = NO_OWNER;
        self.startingPlot = NO;
        self.revealedArray = [[BitArray alloc] initWithSize:8];
        self.visibleArray = [[BitArray alloc] initWithSize:8];
        self.network = [[RelationsNetwork alloc] init];
        
        // economy
        self.economy = [[PlotEconomy alloc] initWithPlot:self];
        // self.economy.delegate ...
    }
    
    return self;
}

- (instancetype)initWithCoord:(MapPoint *)ncoord andTerrain:(MapTerrain)nterrain onMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.map = map;
        self.coordinate = ncoord;
        self.terrain = nterrain;
        self.features = [[NSMutableArray alloc] init];
        self.inhabitants = 0;
        self.populationState = PlotPopulationStateNomads;
        self.ownerIdentifier = NO_OWNER;
        self.startingPlot = NO;
        self.revealedArray = [[BitArray alloc] initWithSize:8];
        self.visibleArray = [[BitArray alloc] initWithSize:8];
        self.network = [[RelationsNetwork alloc] init];
        
        // economy
        self.economy = [[PlotEconomy alloc] initWithPlot:self];
        // self.economy.delegate ...
    }
    
    return self;
}

#pragma mark -
#pragma mark serialize functions

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    
    if (self) {
        self.coordinate = [decoder decodeObjectForKey:PlotDataCoordinateKey];
        self.terrain = [decoder decodeIntegerForKey:PlotDataTerrainKey];
        
        self.features = [[NSMutableArray alloc] init];
        NSInteger numOfFeatures = [decoder decodeIntegerForKey:PlotDataFeaturesKey];
        for (int i = 0; i <numOfFeatures; ++i) {
            NSInteger feature = [decoder decodeIntegerForKey:[NSString stringWithFormat:PlotDataFeatureKey, i]];
            [self.features addInteger:feature];
        }
        
        self.inhabitants = [decoder decodeFloatForKey:PlotDataInhabitantsKey];
        self.populationState = [decoder decodeIntegerForKey:PlotDataPopulationStateKey];
        self.ownerIdentifier = [decoder decodeIntegerForKey:PlotDataOwnerKey];
        self._startingPlot = [decoder decodeBoolForKey:PlotDataStartingPlotKey];
        self.revealedArray = [decoder decodeObjectForKey:PlotDataRevealedKey];
        self.visibleArray = [decoder decodeObjectForKey:PlotDataVisibleKey];
        
        // init the network
        self.network = [[RelationsNetwork alloc] init];
        
        // economy
        self.economy = [[PlotEconomy alloc] initWithPlot:self];
        // self.economy.delegate ...
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.coordinate forKey:PlotDataCoordinateKey];
    [encoder encodeInteger:self.terrain forKey:PlotDataTerrainKey];
    
    [encoder encodeInteger:self.features.count forKey:PlotDataFeaturesKey];
    for (int i = 0; i <self.features.count; ++i) {
        [encoder encodeInteger:[self.features integerAtIndex:i] forKey:[NSString stringWithFormat:PlotDataFeatureKey, i]];
    }
    
    [encoder encodeFloat:self.inhabitants forKey:PlotDataInhabitantsKey];
    [encoder encodeInteger:self.populationState forKey:PlotDataPopulationStateKey];
    [encoder encodeInteger:self.ownerIdentifier forKey:PlotDataOwnerKey];
    [encoder encodeBool:self._startingPlot forKey:PlotDataStartingPlotKey];
    
    [encoder encodeObject:self.revealedArray forKey:PlotDataRevealedKey];
    [encoder encodeObject:self.visibleArray forKey:PlotDataVisibleKey];
}

#pragma mark -
#pragma mark terrain functions

- (MapTerrainData *)terrainData
{
    return [[MapDataProvider sharedInstance] terrainDataForMapTerrain:self.terrain];
}

#pragma mark -
#pragma mark feature functions

- (void)addFeature:(MapFeature)feature
{
    if (![self hasFeature:feature]) {
        [self.features addInteger:feature];
    }
}

- (BOOL)hasFeature:(MapFeature)feature
{
    for (id item in self.features) {
        if ([item intValue] == (int)feature) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark river functions

- (void)setRiver:(BOOL)hasRiver
{
    self._river = hasRiver;
}

- (BOOL)hasRiver
{
    return self._river;
}

#pragma mark -
#pragma mark neighboring functions

- (NSArray *)neighbors
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSNumber *direction in HEXDIRECTIONS) {
        MapPoint *pt = [self.coordinate neighborInDirection:[direction intValue]];
        
        if ([self.map isValidAt:pt]) {
            [array addObject:[self.map tileAtX:pt.x andY:pt.y]];
        }
    }

    return array;
}

- (BOOL)isCoastal
{
    if ([self isOcean]) {
        return NO;
    }
    
    for (Plot *neighbor in [self neighbors]) {
        if ([neighbor isOcean]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark player functions

- (void)setVisible:(BOOL)visible forPlayer:(Player *)player
{
    if (visible) {
        [self.visibleArray set:player.identifier];
    } else {
        [self.visibleArray reset:player.identifier];
    }
}

- (BOOL)isVisibleForPlayer:(Player *)player
{
    return [self.visibleArray isSetAt:player.identifier];
}

- (void)setRevealed:(BOOL)visible forPlayer:(Player *)player
{
    if (visible) {
        [self.revealedArray set:player.identifier];
    } else {
        [self.revealedArray reset:player.identifier];
    }
}

- (BOOL)isRevealedForPlayer:(Player *)player
{
    return [self.revealedArray isSetAt:player.identifier];
}

#pragma mark settle functions

/*- (void)settleWithPlayer:(Player *)player
{
    NSAssert(self.owner == nil, @"There can't be an owner when you settle");
    
    self.owner = player;
    self.inhabitants = 50;
}

- (BOOL)claimWithPlayer:(Player *)player
{
    if (self.owner == nil) {
        self.owner = player;
        return YES;
    }
    
    return NO; // already a different owner
}*/

- (BOOL)isLandmass
{
    return self.terrain != MapTerrainOcean && self.terrain != MapTerrainShore;
}

- (BOOL)isOcean
{
    return self.terrain == MapTerrainOcean || self.terrain == MapTerrainShore;
}

#pragma mark -
#pragma mark player functions

- (void)setOwner:(Player *)owner
{
    [self.network setPlayer:owner];
    self.ownerIdentifier = owner.identifier;
}

- (Player *)owner
{
    if (self.ownerIdentifier == NO_OWNER) {
        return nil;
    }
    
    return [[GameProvider sharedInstance].game playerForIdentifier:self.ownerIdentifier];
}

- (BOOL)hasOwner
{
    return self.ownerIdentifier != NO_OWNER;
}

- (BOOL)isStartingPlot
{
    return self._startingPlot;
}

- (void)setStartingPlot:(BOOL)bNewValue
{
    self._startingPlot = bNewValue;
}

- (NSInteger)calculateNatureYield:(YieldType)yieldType forPlayer:(Player *)player
{
    MapTerrainData *data = self.terrainData;
    
    switch (yieldType) {
        case YieldTypeFood:
            return data.soil * data.acres;
        default:
            return 0;
    }
    
    return 0;
}

- (void)turn
{
    // quit when we are on ocean
    if (![self isLandmass]) {
        return;
    }
    
    if ([self hasOwner]) {
        //
        [self.network turn];
        
        // calculate population growth
        // Nt+1 = Nt + Nt * (birth - death)
        self.inhabitants = self.inhabitants + self.inhabitants * ([self.network.birthRate valueWithDelay:0]  - [self.network.deathRate valueWithDelay:0]);
        
        switch (self.populationState) {
            case PlotPopulationStateNomads:
                // handle settling (10% chance)
                if ([[self owner] hasScience:kSCIENCEAGRICULTURE] &&
                    arc4random() % 100 < 10) {
                    
                    self.populationState = PlotPopulationStateVillage;
                    if (self.delegate) {
                        [self.delegate plot:self handlePopulationStateChangeFrom:PlotPopulationStateNomads to:PlotPopulationStateVillage];
                    }
                }
                break;
            case PlotPopulationStateVillage:
                // check, if we should be a town
                if (self.inhabitants > 5000) {
                    self.populationState = PlotPopulationStateTown;
                    if (self.delegate) {
                        [self.delegate plot:self handlePopulationStateChangeFrom:PlotPopulationStateVillage to:PlotPopulationStateTown];
                    }
                }
                break;
            case PlotPopulationStateTown:
            case PlotPopulationStateCity:
            case PlotPopulationStateMetropol:
                // NOOP
                break;
        }
    
        // only handle economy when we have settled
        if (self.populationState != PlotPopulationStateNomads) {
            [self.economy turn];
        }
    } else if (self.inhabitants > 0) {
        // when the tile is not conquered yet, increase by 1%
        self.inhabitants = self.inhabitants * 1.01;
        
        // when we have more than 500 users, notify the game that one of the players should get this tile
        if (self.inhabitants > 100) {
            if (self.delegate) {
                [self.delegate plot:self handlePlayerShouldRequestTileDueToPopulationIncrease:self.inhabitants];
            }
        }
    }
}

/*!
 calculate the population spread
 */
- (CGFloat)possibleMigrants
{
    return self.inhabitants * 0.01;
}

/*!
 basis: uncertainty, wealth, same culture, same player (oversea)
 */
- (CGFloat)migrationWeight
{
#warning please tweak here
    if (self.ownerIdentifier != NO_OWNER) {
        return [self.network.birthRate valueWithDelay:0];
    }
    
    return 0.01;
}

@end
