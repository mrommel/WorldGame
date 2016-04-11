//
//  MapGenerator.m
//  AITest
//
//  Created by Michael Rommel on 15.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MapGenerator.h"

#import "Array2D.h"
#import "NSArray+Util.h"
#import "Continent.h"
#import "HeightMap.h"

const static int kMaximalContinents = 256;
const static int kNotAnalizedContinent = -1;
const static int kNoContinent = -2;

const static int kNoRivers = -1;
const static int kNumberOfRivers = 7;
const static int kNoLakes = -1;
const static int kNumberOfLakes = 7;
const static int kNumberOfIslands = 10;

// Heightspartions
#define kDeepSea        2*16- 0
#define kNormalSea      4*16-10
#define kWaterDepth     6*16-32
#define kFlatLand       9*16-48
#define kHills          10*16-50
#define kLowMountain    11*16-50
#define kMidMountain    12*16-50
#define kHighMountain   13*16-50

#define pDeepSea        0
#define pNormalSea      1
#define pFlatSea        2
#define pIsland         3
#define pIceberg        4
#define pGlacier        5
#define pWasteland      6
#define pTaiga          7

#define pTundra         8
#define pConiferous     9
#define pMeadow1        10
#define pMixedforest    11
#define pMeadow2        12
#define pDeciduous      13
#define pMeadow3        14
#define pBushes         15

#define pMeadow4        16
#define pSavanne        17
#define pSteppe         18
#define pMoor           19
#define pSwamp1         20
#define pRainforest     21
#define pSwamp2         22
#define pJungle         23

#define pMeadow5        24
#define pWildDesert     25
#define pDesert         26
#define pLake           27
#define pHill           28
#define pLowMountain    29
#define pMidMountain    30
#define pHighMountain   31

#define pSpPlain        32
#define pSpHill         33

//Part of Scape in % of Northsphere
#define latitudePolar       5
#define latitudeSubPolar	25
#define latitudeGemaessigt  50
#define latitudeSubTropic	75
#define latitudeTropic      100

// climate zones
typedef enum Climate {
    cPolar = 0,
    cSubPolar = 1,
    cGemaessigt = 2,
    cSubTropen = 3,
    cTropen = 4
} Climate;

@implementation MapGenerator

- (instancetype)initWithMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.map = map;
    }
    
    return self;
}

- (void)generateWithProgress:(MapGenerateProgress)progress
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (void)fillWithTerrain:(MapTerrain)terrain
{
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            [self.map tileAtX:i andY:j].terrain = terrain;
        }
    }
}

- (void)addTerrainRect:(CGRect)rect andFillItWithTerrain:(MapTerrain)terrain
{
    [self addTerrainRectWithX:rect.origin.x andY:rect.origin.y andWidth:rect.size.width andHeight:rect.size.height andFillItWithTerrain:terrain];
}

- (void)addTerrainRectWithX:(int)x andY:(int)y andWidth:(int)width andHeight:(int)height andFillItWithTerrain:(MapTerrain)terrain
{
    for (int i = x; i < (x + width); i++) {
        for (int j = y; j < (y + height); j++) {
            [self.map tileAtX:i andY:j].terrain = terrain;
        }
    }
}

- (void)addTerrainLineFrom:(CGPoint)from to:(CGPoint)to andFillItWithTerrain:(MapTerrain)terrain
{
    int startx = MIN(from.x, to.x);
    int starty = MIN(from.y, to.y);
    int endx = MAX(from.x, to.x);
    int endy = MAX(from.y, to.y);
    
    if ((endx - startx) > (endy - starty) ) {
        for (int i = 0; i < (endx - startx); i++ ) {
            float p = (float)i / (float)(endx - startx);
            
            int i = startx + p * (endx - startx);
            int j = starty + p * (endy - starty);
            [self.map tileAtX:i andY:j].terrain = terrain;
        }
    } else {
        for (int i = 0; i < (endy - starty); i++ ) {
            float p = (float)i / (float)(endy - starty);
            
            int i = startx + p * (endx - startx);
            int j = starty + p * (endy - starty);
            [self.map tileAtX:i andY:j].terrain = terrain;
        }
    }
}

- (void)identifyContinents
{
    Array2D *continentIdentifiers = [[Array2D alloc] initWithSize:CGSizeMake(self.map.width, self.map.height)];
    [continentIdentifiers fillWithInt:kNotAnalizedContinent];
    
    // reset
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            [self.map tileAtX:i andY:j].continent = nil;
        }
    }
    
    for (int nx = 0; nx < self.map.width; nx++)
    {
        for (int ny = 0; ny < self.map.height; ny++)
        {
            Plot *tile = [self.map tileAtX:nx andY:ny];
            MapPoint *pt = tile.coordinate;
            
            if ([tile isLandmass])
            {
                MapPoint *p0 = [pt neighborInDirection:HexDirectionNorthWest];
                MapPoint *p4 = [pt neighborInDirection:HexDirectionWest];
                MapPoint *p1 = [pt neighborInDirection:HexDirectionNorthEast];
                MapPoint *p5 = [pt neighborInDirection:HexDirectionSouthWest];
                
                int c0 = [p0 validForWidth:self.map.width andHeight:self.map.height] ? [continentIdentifiers intAtX:p0.x andY:p0.y] : kNotAnalizedContinent;
                int c1 = [p1 validForWidth:self.map.width andHeight:self.map.height] ? [continentIdentifiers intAtX:p1.x andY:p1.y] : kNotAnalizedContinent;
                int c4 = [p4 validForWidth:self.map.width andHeight:self.map.height] ? [continentIdentifiers intAtX:p4.x andY:p4.y] : kNotAnalizedContinent;
                int c5 = [p5 validForWidth:self.map.width andHeight:self.map.height] ? [continentIdentifiers intAtX:p5.x andY:p5.y] : kNotAnalizedContinent;
                
                if (c0 > kNotAnalizedContinent)
                    [continentIdentifiers setInt:c0 atX:pt.x andY:pt.y];
                else if (c1 > kNotAnalizedContinent)
                    [continentIdentifiers setInt:c1 atX:pt.x andY:pt.y];
                else if (c5 > kNotAnalizedContinent)
                    [continentIdentifiers setInt:c5 atX:pt.x andY:pt.y];
                else if (c4 > kNotAnalizedContinent)
                    [continentIdentifiers setInt:c4 atX:pt.x andY:pt.y];
                else
                    [continentIdentifiers setInt:[self getUnusedIndentifierInContinentMap:continentIdentifiers] atX:pt.x andY:pt.y];
                
                // handle connection case
                if (c1 > kNotAnalizedContinent && c5 > kNotAnalizedContinent && (c1 != c5))
                    [continentIdentifiers replaceAllInt:c5 withInt:c1];
                if (c4 > kNotAnalizedContinent && c0 > kNotAnalizedContinent && (c4 != c0))
                    [continentIdentifiers replaceAllInt:c4 withInt:c0];
                if (c4 > kNotAnalizedContinent && c1 > kNotAnalizedContinent && (c4 != c1))
                    [continentIdentifiers replaceAllInt:c4 withInt:c1];
                if (c0 > kNotAnalizedContinent && c5 > kNotAnalizedContinent && (c0 != c5))
                    [continentIdentifiers replaceAllInt:c5 withInt:c0];
                if (c0 > kNotAnalizedContinent && c1 > kNotAnalizedContinent && (c0 != c1))
                    [continentIdentifiers replaceAllInt:c0 withInt:c1];
                if (c4 > kNotAnalizedContinent && c5 > kNotAnalizedContinent && (c4 != c5))
                    [continentIdentifiers replaceAllInt:c4 withInt:c5];
            } else {
                // ocean tile don't belong to a continent
                [continentIdentifiers setInt:kNoContinent atX:pt.x andY:pt.y];
            }
        }
    }
    
    // set continents
    for (int nx = 0; nx < self.map.width; nx++)
    {
        for (int ny = 0; ny < self.map.height; ny++)
        {
            Plot *tile = [self.map tileAtX:nx andY:ny];
            MapPoint *pt = tile.coordinate;
            
            if ([tile isLandmass]) {
                int continentIdentifier = [continentIdentifiers intAtX:pt.x andY:pt.y];
                
                NSAssert(continentIdentifier > kNotAnalizedContinent, @"Continents cannot be negative ()");
                
                Continent *continent = [self.map continentByIdentifier:continentIdentifier];
                if (continent == nil) {
                    continent = [[Continent alloc] initWithIdentifier:continentIdentifier andName:[NSString stringWithFormat:@"Continent%d", continentIdentifier]];
                    [self.map addContinent:continent];
                }
                tile.continent = continent;
            } else {
                // ocean tile don't belong to a continent
                tile.continent = nil;
            }
        }
    }
}

- (int)getUnusedIndentifierInContinentMap:(Array2D *)continentIdentifiers
{
    NSMutableArray *unused = [[NSMutableArray alloc] init];
    
    // initialize with unused = true
    for (int i = 0; i < kMaximalContinents; i++)
        [unused addObject:[NSNumber numberWithBool:YES]];
    
    // now check for continent identifiers
    for (int nx = 0; nx < self.map.width; nx++) {
        for (int ny = 0; ny < self.map.height; ny++) {
            int c = [continentIdentifiers intAtX:nx andY:ny];
            if (c >= 0 && c < kMaximalContinents) {
                [unused replaceObjectAtIndex:c withBool:NO];
            }
        }
    }
    
    // get first free identifier
    for (short u = 0; u < kMaximalContinents; u++) {
        if ([unused boolValueAtIndex:u]) {
            return u;
        }
    }
    
    return kNoContinent;
}

@end

@implementation BipolarMapGenerator

- (void)generateWithProgress:(MapGenerateProgress)progress
{
    if (progress)
        progress(0);
    
    [self fillWithTerrain:MapTerrainOcean];
    if (progress)
        progress(30);
    
    // some land in the east west
    [self addTerrainRect:CGRectMake(0, 0, self.map.width / 3, self.map.height) andFillItWithTerrain:MapTerrainGrass];
    [self addTerrainRect:CGRectMake(self.map.width - self.map.width / 3, 0, self.map.width / 3, self.map.height) andFillItWithTerrain:MapTerrainGrass];
    if (progress)
        progress(60);
    
    // add land bridge
    [self addTerrainLineFrom:CGPointMake(self.map.width / 3, self.map.height / 2) to:CGPointMake(self.map.width - self.map.width / 3, self.map.height / 2) andFillItWithTerrain:MapTerrainGrass];
    if (progress)
        progress(80);
    
    [self identifyContinents];
    if (progress)
        progress(90);
    
    // add start positions
    [self.map.startPositions addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.map.height / 2)]];
    [self.map.startPositions addObject:[NSValue valueWithCGPoint:CGPointMake(self.map.width - 1, self.map.height / 2)]];
    if (progress)
        progress(100);
}

@end

@interface OptionsMapGenerator()

@property (nonatomic) MapOptions *options;
@property (nonatomic) Array2D *tmpMap;
@property (nonatomic) HeightMap *heightMap;

@end

@implementation OptionsMapGenerator

- (instancetype)initWithMap:(Map *)map andOptions:(MapOptions *)options
{
    self = [super initWithMap:map];
    
    if (self) {
        self.options = options;
    }
    
    return self;
}

- (void)generateWithProgress:(MapGenerateProgress)progress
{
    if (progress)
        progress(0);
    
    // [self fillWithTerrain:MapTerrainOcean];
    [NSThread sleepForTimeInterval:0.1f];
    
    // Step 0.1 Bodenschätze initialisieren
    // TODO
    if (progress)
        progress(10);
    [NSThread sleepForTimeInterval:0.1f];
    
    // Step 0.2 resize matrices
    // TODO
    if (progress)
        progress(15);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 1.1 Höhen(raster)gitter erzeugen
    self.heightMap = [[HeightMap alloc] initWithSize:CGSizeMake(self.map.width, self.map.height)];
    if (progress)
        progress(20);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 1.2 Vegetation erzeugen
    Array2D *vegetationMap = [[Array2D alloc] initWithSize:CGSizeMake(self.map.width, self.map.height)];
    if (progress)
        progress(25);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 1.3 Work erzeugen und initializieren
    self.tmpMap = [[Array2D alloc] initWithSize:CGSizeMake(self.map.width, self.map.height)];
    [self.tmpMap fillWithInt:0];
    if (progress)
        progress(30);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 2.1 fill heightmap with random (sinus/cosinus) values
    [self.heightMap random];
    if (progress)
        progress(35);
    [NSThread sleepForTimeInterval:0.1f];
    
    // Step 2.2 blur heights
    [self.heightMap smoothen];
    if (progress)
        progress(45);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 2.3 Ozeane und Berg und Rest(=Sp...) generieren
    [self setOceansAndMountains];
    if (progress)
        progress(50);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 2.4 Ozeane glätten
    [self checkOcean];
    if (progress)
        progress(60);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 3.1 Vegetation glätten
    [vegetationMap smoothenInt];
    if (progress)
        progress(70);
    [NSThread sleepForTimeInterval:0.1f];
    
    // Step 3.2 generate SpPlain and SpHill
    [self modifyWorkWithVegetation:vegetationMap];
    if (progress)
        progress(75);
    [NSThread sleepForTimeInterval:0.1f];
    
    // Step 3.3 generate Islands from FlatSea
    [self generateIslands];
    if (progress)
        progress(80);
    [NSThread sleepForTimeInterval:0.1f];
    
    // Step 4 transform tmp to map terrain
    [self transformWork];
    if (progress)
        progress(85);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 5.1 Rivers
    /*
     for(int count=0;count<rNumOfRivers;)
     if (makeRiver(rand()%dimx,rand()%dimy,height)) count++;*/
    [self generateRivers:((self.options.numRivers == kNoRivers) ? kNumberOfRivers : self.options.numRivers)];
    if (progress)
        progress(90);
    [NSThread sleepForTimeInterval:0.1f];
    
    //Step 5.2 lakes
    [self generateLakes:((self.options.numRivers == kNoLakes) ? kNumberOfLakes : self.options.numLakes)];
    if (progress)
        progress(95);
    [NSThread sleepForTimeInterval:0.1f];
    
    [self identifyContinents];
    if (progress)
        progress(90);
    [NSThread sleepForTimeInterval:0.1f];
    
    // add start positions
    [self.map.startPositions addObject:[NSValue valueWithCGPoint:CGPointMake(0, self.map.height / 2)]];
    [self.map.startPositions addObject:[NSValue valueWithCGPoint:CGPointMake(self.map.width - 1, self.map.height / 2)]];
    if (progress)
        progress(100);
}

- (void)generateRivers:(int)numberOfRivers
{
    for(int count=0;count<numberOfRivers;) {
        if ([self tryToMakeRiverAtX:rand()%(int)self.map.width andY:rand()%(int)self.map.height]) {
            count++;
        }
    }
}

- (BOOL)tryToMakeRiverAtX:(int)x andY:(int)y
{
    // no rivers in oceans
    if ([self isOceanAtX:x andY:y]) {
        return NO;
    }
    
    // rivers start at hill or mountains
    if (![self isHillOrMountainAtX:x andY:y]) {
        return NO;
    }
    
    NSLog(@"-------------------------------");
    NSLog(@"Start Making River");
    
    MapPointWithCorner *currentPointWithCorner = [[MapPointWithCorner alloc] initWithX:x andY:y andCorner:HexPointCornerSouthEast];
    FlowDirection currentFlow = FLOWDIRECTION_SOUTH;
    BOOL riverReachedOcean = NO;
    BOOL riverReachedLake = NO;
    int riverLength = 0;
    
    while (!riverReachedOcean && !riverReachedLake) {
        
        NSLog(@"Current Cursor position: (%d,%d) at corner: %@", currentPointWithCorner.x, currentPointWithCorner.y, CornerString(currentPointWithCorner.corner));
        NSLog(@"Make River at: (%d,%d) in Flow:%@", currentPointWithCorner.x, currentPointWithCorner.y, FlowDirectionString(currentFlow));
        [self.map setRiver:YES atX:currentPointWithCorner.x andY:currentPointWithCorner.y];
        riverLength++;
        
        float bestHeight = HUGE_VALF;
        FlowDirection bestFlow = NO_FLOWDIRECTION;
        
        for (NSNumber *flow in [currentPointWithCorner possibleFlowsFromCorner]) {
            MapPointWithCorner *flowPointWithCorner = [currentPointWithCorner nextCornerInFlowDirection:[flow intValue]];
            float flowHeight = [self heightAtPointWithCorner:flowPointWithCorner];
            if (bestHeight > flowHeight) {
                bestFlow = [flow intValue];
                bestHeight = flowHeight;
            }
        }
        
        currentFlow = bestFlow;
        currentPointWithCorner = [currentPointWithCorner nextCornerInFlowDirection:bestFlow];
        
        // check if we reached the edge of the map
        if (![self.map isValidAtX:currentPointWithCorner.x andY:currentPointWithCorner.y]) {
            riverReachedOcean = YES;
        }
        
        // check if river cannot excape
        if ([self.map hasRiverAtX:currentPointWithCorner.x andY:currentPointWithCorner.y]) {
            riverReachedLake = YES;
            NSLog(@"River reached lake");
        }
        
        // check if tile is adjacent to ocean
        if ([self.map isOceanAtX:currentPointWithCorner.x andY:currentPointWithCorner.y]) {
            riverReachedOcean = YES;
            NSLog(@"River reached ocean");
        }
    }
    
    return YES;
}

- (float)heightAtPointWithCorner:(MapPointWithCorner *)hexPointWithCorner
{
    return [self heightAtCorner:hexPointWithCorner.corner ofX:hexPointWithCorner.x andY:hexPointWithCorner.y];
}

- (float)heightAtCorner:(HexPointCorner)corner ofX:(int)x andY:(int)y
{
    MapPoint *current = [[MapPoint alloc] initWithX:x andY:y];
    MapPoint *pt1 = nil;
    MapPoint *pt2 = nil;
    
    //       N
    //       x
    // NW  /   \  NE
    //   x       x
    //   |       |
    //   |       |
    //   x       x
    // SW  \   /  SE
    //       x
    //       S
    switch (corner) {
        case HexPointCornerNorth:
            pt1 = [current neighborInDirection:HexDirectionNorthWest];
            pt2 = [current neighborInDirection:HexDirectionNorthEast];
            break;
        case HexPointCornerNorthEast:
            pt1 = [current neighborInDirection:HexDirectionNorthEast];
            pt2 = [current neighborInDirection:HexDirectionEast];
            break;
        case HexPointCornerSouthEast:
            pt1 = [current neighborInDirection:HexDirectionEast];
            pt2 = [current neighborInDirection:HexDirectionSouthEast];
            break;
        case HexPointCornerSouth:
            pt1 = [current neighborInDirection:HexDirectionSouthEast];
            pt2 = [current neighborInDirection:HexDirectionSouthWest];
            break;
        case HexPointCornerSouthWest:
            pt1 = [current neighborInDirection:HexDirectionSouthWest];
            pt2 = [current neighborInDirection:HexDirectionWest];
            break;
        case HexPointCornerNorthWest:
            pt1 = [current neighborInDirection:HexDirectionWest];
            pt2 = [current neighborInDirection:HexDirectionNorthWest];
            break;
    }
    
    return [self averageHeightOfPoint1:current andPoint2:pt1 andPoint3:pt2];
}

- (float)averageHeightOfPoint1:(MapPoint *)pt1 andPoint2:(MapPoint *)pt2 andPoint3:(MapPoint *)pt3
{
    float sum = 0.0f;
    int count = 0;
    
    if ([self.map isValidAt:pt1]) {
        count++;
        sum += [self.heightMap valueAtX:pt1.x andY:pt1.y];
    }
    
    if ([self.map isValidAt:pt2]) {
        count++;
        sum += [self.heightMap valueAtX:pt2.x andY:pt2.y];
    }
    
    if ([self.map isValidAt:pt3]) {
        count++;
        sum += [self.heightMap valueAtX:pt3.x andY:pt3.y];
    }
    
    if (count == 0) {
        return 0.0f;
    }
    
    return sum / count;
}

- (void)generateLakes:(int)numberOfLakes
{
    /*
     for(count=0;count<rNumOfLakes;)
     {
     int nx = rand()%dimx; int ny = rand()%dimy;
     setPlain(nx,ny,generateLakes(getPlain(nx,ny),isRiver(nx,ny),count));
     }*/
}

- (void)transformWork
{
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            int tmpValue = [self.tmpMap intAtX:i andY:j];
            
            switch (tmpValue) {
                case pDeepSea:
                    [self.map setTerrain:MapTerrainOcean atX:i andY:j];
                    break;
                case pNormalSea:
                    [self.map setTerrain:MapTerrainOcean atX:i andY:j];
                    break;
                case pFlatSea:
                    [self.map setTerrain:MapTerrainOcean atX:i andY:j];
                    break;
                case pIsland:
                    [self.map setTerrain:MapTerrainOcean atX:i andY:j];
                    break;
                case pIceberg:
                    [self.map setTerrain:MapTerrainOcean atX:i andY:j];
                    break;
                case pGlacier:
                    [self.map setTerrain:MapTerrainSnow atX:i andY:j];
                    break;
                case pWasteland:
                    [self.map setTerrain:MapTerrainTundra atX:i andY:j];
                    break;
                case pTaiga: // 7
                    [self.map setTerrain:MapTerrainTundra atX:i andY:j];
                    [self.map addFeature:MapFeatureForest atX:i andY:j];
                    break;
                case pTundra:
                    [self.map setTerrain:MapTerrainTundra atX:i andY:j];
                    break;
                case pConiferous:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pMixedforest:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureForest atX:i andY:j];
                    break;
                case pMeadow2:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pDeciduous:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureForest atX:i andY:j];
                    break;
                case pMeadow3:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pBushes: // 15
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pMeadow4:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pSavanne:
                    [self.map setTerrain:MapTerrainPlain atX:i andY:j];
                    break;
                case pSteppe:
                    [self.map setTerrain:MapTerrainPlain atX:i andY:j];
                    break;
                case pMoor:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pSwamp1:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pRainforest:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureForest atX:i andY:j];
                    break;
                case pSwamp2:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pJungle: // 23
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureForest atX:i andY:j];
                    break;
                case pMeadow5:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pWildDesert:
                    [self.map setTerrain:MapTerrainDesert atX:i andY:j];
                    break;
                case pDesert:
                    [self.map setTerrain:MapTerrainDesert atX:i andY:j];
                    break;
                case pLake:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    break;
                case pHill:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureHills atX:i andY:j];
                    break;
                case pLowMountain:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureHills atX:i andY:j];
                    break;
                case pMidMountain:
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureMountains atX:i andY:j];
                    break;
                case pHighMountain: // 31
                    [self.map setTerrain:MapTerrainGrass atX:i andY:j];
                    [self.map addFeature:MapFeatureMountains atX:i andY:j];
                    break;
            }
        }
    }
}

// generate data out of pseudo-types
- (void)modifyWorkWithVegetation:(Array2D *)vegetationMap
{
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            if ([self.tmpMap intAtX:i andY:j] == pSpPlain) {
                float vegetationValue = [vegetationMap floatAtX:i andY:j];
                float newPlainValue = [self generatePlainFromVegetation:vegetationValue andLatitude:j];
                [self.tmpMap setInt:newPlainValue atX:i andY:j];
            } else if ([self.tmpMap intAtX:i andY:j] == pSpHill) {
                float vegetationValue = [vegetationMap floatAtX:i andY:j];
                float newPlainValue = [self generateHillsFromVegetation:vegetationValue andLatitude:j];
                [self.tmpMap setInt:newPlainValue atX:i andY:j];
            }
        }
    }
}

- (Climate)climateForLatitude:(int)latitude
{
    int borderPolar = self.map.height * latitudePolar / 200;
    int borderSubPolar = self.map.height * latitudeSubPolar / 200;
    int borderTemperated = self.map.height * latitudeGemaessigt / 200;
    int borderSubTropic = self.map.height * latitudeSubTropic / 200;
    
    if ((latitude < borderPolar) || (latitude > (self.map.height-borderPolar))) {
        return cPolar;
    }
    if ((latitude < borderSubPolar) || (latitude > (self.map.height-borderSubPolar))) {
        return cSubPolar;
    }
    if ((latitude < borderTemperated) || (latitude > (self.map.height-borderTemperated))) {
        return cGemaessigt;
    }
    if ((latitude < borderSubTropic) || (latitude > (self.map.height-borderSubTropic))) {
        return cSubTropen;
    }
    return cTropen;
}

#define PERCENT (rand() % 100)

- (int)generatePlainFromVegetation:(float)vegetation andLatitude:(int)latitude
{
    switch ([self climateForLatitude:latitude]) {
        case cPolar:
            if(PERCENT <= 90) {
                return pGlacier;
            } else {
                return pWasteland;
            }
            break;
        case cSubPolar:
            if (PERCENT > 90) {
                return pWasteland;
            } else {
                if (PERCENT < 33) {
                    if (vegetation > 2) {
                        return pMoor;
                    } else {
                        return pSwamp1;
                    }
                } else {
                    if (vegetation > 2) {
                        if (PERCENT > 90) {
                            return pConiferous;
                        } else {
                            return pTaiga;
                        }
                    } else if (PERCENT > 90) {
                        return pMeadow1;
                    } else {
                        return pTundra;
                    }
                }
            }
            break;
        case cGemaessigt:
            if (rand()%100 > 66) {
                if (vegetation < 2) {
                    return pConiferous;
                } else {
                    return pMeadow1;
                }
            } else if (PERCENT > 50) {
                if (vegetation < 2) {
                    return pMixedforest;
                } else {
                    return pMeadow2;
                }
            } else {
                if (vegetation < 2) {
                    return pDeciduous;
                } else {
                    return pMeadow3;
                }
            }
            break;
        case cSubTropen:
            if (PERCENT > 66) {
                if (PERCENT > 50) {
                    if (vegetation < 2) {
                        return pDeciduous;
                    } else {
                        return pMeadow3;
                    }
                } else {
                    if (vegetation < 2) {
                        return pBushes;
                    } else {
                        return pMeadow4;
                    }
                }
            } else {
                if (PERCENT > 50) {
                    if (PERCENT > 66) {
                        if (vegetation < 2) {
                            return pSavanne;
                        } else {
                            return pSteppe;
                        }
                    } else {
                        if (vegetation < 2) {
                            return pRainforest;
                        } else {
                            return pSwamp2;
                        }
                    }
                } else {
                    if (vegetation < 2) {
                        return pJungle;
                    } else {
                        return pMeadow5;
                    }
                }
            }
            break;
        case cTropen:
            if (PERCENT > 50) {
                if (PERCENT > 50) {
                    if (vegetation < 2) {
                        return pBushes;
                    } else {
                        return pMeadow4;
                    }
                } else if (vegetation < 2) {
                    return pSavanne;
                } else {
                    return pSteppe;
                }
            } else if (PERCENT < 33) {
                if (vegetation < 2) {
                    return pRainforest;
                } else {
                    return pSwamp2;
                }
            } else if (PERCENT < 50) {
                if (vegetation < 2) {
                    return pJungle;
                } else {
                    return pMeadow5;
                }
            } else if (vegetation < 2) {
                return pWildDesert;
            } else {
                return pDesert;
            }
            break;
        default:
            return pMeadow1;
    }
}

- (int)generateHillsFromVegetation:(float)vegetation andLatitude:(int)latitude
{
    switch ([self climateForLatitude:latitude]) {
        case cPolar:
            if(PERCENT <= 90) {
                return pGlacier;
            } else {
                return pWasteland;
            }
            break;
        case cSubPolar:
            if (PERCENT > 90) {
                return pWasteland;
            } else {
                if (PERCENT < 33) {
                    if (vegetation>2) {
                        return pMoor;
                    } else {
                        return pSwamp1;
                    }
                } else {
                    if (vegetation > 2) {
                        if (PERCENT > 90) {
                            return pConiferous;
                        } else {
                            return pTaiga;
                        }
                    } else if (PERCENT > 90) {
                        return pMeadow1;
                    } else {
                        return pTundra;
                    }
                }
            }
            //Sumpf & Moor
            break;
        case cGemaessigt:
            if (PERCENT > 66) {
                if (vegetation < 2) {
                    return pConiferous;
                } else {
                    return pMeadow1;
                }
            } else if (PERCENT > 50) {
                if (vegetation < 2) {
                    return pMixedforest;
                } else {
                    return pMeadow2;
                }
            } else if (vegetation < 2) {
                return pDeciduous;
            } else {
                return pMeadow3;
            }
            break;
        case cSubTropen:
            if (PERCENT > 66) {
                if (PERCENT > 50) {
                    if (vegetation < 2) {
                        return pDeciduous;
                    } else {
                        return pMeadow3;
                    }
                } else if (vegetation < 2) {
                    return pBushes;
                } else {
                    return pMeadow4;
                }
            } else if (PERCENT > 50) {
                if ( PERCENT >66) {
                    if (vegetation<2) {
                        return pSavanne;
                    } else {
                        return pSteppe;
                    }
                } else if (vegetation<2) {
                    return pRainforest;
                } else {
                    return pSwamp2;
                }
            } else if (vegetation<2) {
                return pJungle;
            } else {
                return pMeadow5;
            }
            break;
        case cTropen:
            if (PERCENT > 50) {
                if (PERCENT > 50) {
                    if (vegetation < 2) {
                        return pBushes;
                    } else {
                        return pMeadow4;
                    }
                } else if (vegetation < 2) {
                    return pSavanne;
                } else {
                    return pSteppe;
                }
            } else if (PERCENT < 33) {
                if (vegetation < 2) {
                    return pRainforest;
                } else {
                    return pSwamp2;
                }
            } else if (PERCENT < 50) {
                if (vegetation < 2) {
                    return pJungle;
                } else {
                    return pMeadow5;
                }
            } else if (vegetation < 2) {
                return pWildDesert;
            } else {
                return pDesert;
            }
            break;
        default:
            return pMeadow1;
    }
    
    return pMeadow1;
}

- (void)setOceansAndMountains
{
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            int height = [self.heightMap valueAtX:i andY:j];
            if (height <= kWaterDepth) {
                // Sea
                if (height <= kDeepSea) {
                    [self.tmpMap setFloat:pDeepSea atX:i andY:j];
                } else if (height <= kNormalSea) {
                    [self.tmpMap setFloat:pNormalSea atX:i andY:j];
                } else if ([self climateForLatitude:j] == cPolar) {
                    [self.tmpMap setFloat:pIceberg atX:i andY:j];
                } else {
                    [self.tmpMap setFloat:pFlatSea atX:i andY:j];
                }
            } else {
                // Continent
                if (height >= kHighMountain) {
                    [self.tmpMap setFloat:pHighMountain atX:i andY:j];
                } else if (height >= kMidMountain) {
                    [self.tmpMap setFloat:pMidMountain atX:i andY:j];
                } else if (height >= kLowMountain) {
                    [self.tmpMap setFloat:pLowMountain atX:i andY:j];
                } else if (height >= kHills) {
                    [self.tmpMap setFloat:pHill atX:i andY:j];
                } else if (height <= kFlatLand) {
                    [self.tmpMap setFloat:pSpPlain atX:i andY:j];
                } else {
                    [self.tmpMap setFloat:pSpHill atX:i andY:j];
                }
            }
        }
    }
}

- (void)checkOcean
{
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            if ([self isOceanAtX:i andY:j]) {
                int max = [self.tmpMap maximumIntOnHexAtX:i andY:j withDefault:0];
                if ((max >= pGlacier) && ([self.tmpMap intAtX:i andY:j] < pFlatSea)) {
                    [self.tmpMap setInt:pFlatSea atX:i andY:j];
                } else if ((max >= pFlatSea) && ([self.tmpMap intAtX:i andY:j] < pNormalSea)) {
                    [self.tmpMap setInt:pNormalSea atX:i andY:j];
                }
            }
        }
    }
    
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            if ([self isOceanAtX:i andY:j]) {
                float max = [self.tmpMap maximumIntOnHexAtX:i andY:j withDefault:0.0f];
                if ((max >= pGlacier) && ([self.tmpMap intAtX:i andY:j] < pFlatSea)) {
                    [self.tmpMap setInt:pFlatSea atX:i andY:j];
                } else if ((max >= pFlatSea) && ([self.tmpMap intAtX:i andY:j] < pNormalSea)) {
                    [self.tmpMap setInt:pNormalSea atX:i andY:j];
                }
            }
        }
    }
}

- (BOOL)isOceanAt:(MapPoint *)h
{
    if (![self.map isValidAt:h]) {
        return NO;
    }
    return [self isOceanAtX:h.x andY:h.y];
}

- (BOOL)isOceanAtX:(int)x andY:(int)y
{
    if (![self.map isValidAtX:x andY:y]) {
        return NO;
    }
    
    return [self.tmpMap intAtX:x andY:y] < pGlacier;
}

- (BOOL)isHillOrMountainAtX:(int)x andY:(int)y
{
    if (![self.map isValidAtX:x andY:y]) {
        return NO;
    }
    
    return [self.tmpMap intAtX:x andY:y] >= pHill;
}

- (void)generateIslands
{
    for (int count = 0; count < kNumberOfIslands;) {
        int nx = arc4random() % (int)self.map.width;
        int ny = arc4random() % (int)self.map.height;
        
        //check for flatsea, if is, make Island
        if ([self.tmpMap intAtX:nx andY:ny] == pFlatSea) {
            [self.tmpMap setInt:pIsland atX:nx andY:ny];
            count++;
        }
    }
}

@end
