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

static NSString* const PlotDataCoordinateKey = @"Plot.Coordinate";
static NSString* const PlotDataTerrainKey = @"Plot.Terrain";

static NSString* const PlotDataFeaturesKey = @"Plot.Features";
static NSString* const PlotDataFeatureKey = @"Plot.Feature.%d";
static NSString* const PlotDataInhabitantsKey = @"Plot.Inhabitants";
static NSString* const PlotDataStartingPlotKey = @"Plot.StartingPlot";

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


@interface Plot()

@property (atomic, setter=setStartingPlot:) BOOL startingPlot;
@property (atomic) BOOL river;

@end

@implementation Plot

@synthesize startingPlot;

- (instancetype)initWithX:(int)nx andY:(int)ny andTerrain:(MapTerrain)nterrain
{
    self = [super init];
    
    if (self) {
        self.coordinate = [[MapPoint alloc] initWithX:nx andY:ny];
        self.terrain = nterrain;
        self.features = [[NSMutableArray alloc] init];
        self.inhabitants = 0;
        self.owner = nil;
        self.startingPlot = NO;
        self.revealed = [[BitArray alloc] initWithSize:8];
        self.network = [[RelationsNetwork alloc] init];
    }
    
    return self;
}

- (instancetype)initWithCoord:(MapPoint *)ncoord andTerrain:(MapTerrain)nterrain
{
    self = [super init];
    
    if (self) {
        self.coordinate = ncoord;
        self.terrain = nterrain;
        self.features = [[NSMutableArray alloc] init];
        self.inhabitants = 0;
        self.owner = nil;
        self.startingPlot = NO;
        self.revealed = [[BitArray alloc] initWithSize:8];
        self.network = [[RelationsNetwork alloc] init];
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
        self.owner = nil;
        self.startingPlot = [decoder decodeBoolForKey:PlotDataStartingPlotKey];
        self.revealed = [[BitArray alloc] initWithSize:8];
        self.network = [[RelationsNetwork alloc] init];
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
    [encoder encodeBool:self.startingPlot forKey:PlotDataStartingPlotKey];
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
    self.river = hasRiver;
}

- (BOOL)isRiver
{
    return self.river;
}

#pragma mark -
#pragma mark player functions

- (void)settleWithPlayer:(Player *)player
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
}

- (BOOL)isLandmass
{
    return self.terrain != MapTerrainOcean && self.terrain != MapTerrainShore;
}

- (BOOL)isOcean
{
    return self.terrain == MapTerrainOcean || self.terrain == MapTerrainShore;
}

- (void)setOwner:(Player *)owner
{
    [self.network setPlayer:owner withEvent:EventTypeClaim];
    _owner = owner;
}

- (BOOL)isStartingPlot
{
    return self.startingPlot;
}

- (void)setStartingPlot:(BOOL)bNewValue
{
    startingPlot = bNewValue;
}

#define kGrowth         0.05f // means 5% growth
#define kFluctuation    0.01f // means 1% fluctuation to each neighbor

- (void)turn
{
    if ([self isLandmass]) {
        //
        [self.network turn];
        
        // calculate population growth
        self.inhabitants = self.inhabitants * (1.f + kGrowth) + (((int)(arc4random() % 5) - 2));
        self.inhabitants = (self.inhabitants < 0 ? 0 : self.inhabitants);
    
        // calculate the population spread
#warning to do: spread the population
    }
}

@end
