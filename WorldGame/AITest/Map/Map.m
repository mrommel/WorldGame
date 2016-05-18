//
//  Map.m
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Map.h"

#import <UIKit/UIKit.h>

#import "Array2D.h"
#import "Plot.h"
#import "MapGenerator.h"
#import "Continent.h"

static NSString* const MapDataWidthKey = @"Map.Width";
static NSString* const MapDataHeightKey = @"Map.Height";

static NSString* const MapDataStartPositionsKey = @"Map.Positions";
static NSString* const MapDataStartPositionKey = @"Map.Position.%d";

static NSString* const MapDataContinentsKey = @"Map.Continents";
static NSString* const MapDataContinentKey = @"Map.Continent.%d";

static NSString* const MapDataTileKey = @"Map.Tile.%d.%d";

/*!
 */
@implementation MapOptions

- (instancetype)initWithMapType:(MapType)mapType andSize:(MapSize)mapSize;
{
    self = [super init];
    
    if (self) {
        self.mapType = mapType;
        self.mapSize = mapSize;
    }
    
    return self;
}

@end

/*!
 
 */
@interface Map()

@property (nonatomic) Array2D *tiles;
@property (nonatomic) NSMutableArray *continents;
@property (nonatomic) UIImage *thumbnailImage;

@end

@implementation Map

- (instancetype)initWithWidth:(NSInteger)width andHeight:(NSInteger)height
{
    self = [super init];
    
    if (self) {
        self.width = width;
        self.height = height;
        self.startPositions = [[NSMutableArray alloc] init];
        self.continents = [[NSMutableArray alloc] init];
        self.tiles = [[Array2D alloc] initWithSize:CGSizeMake(width, height)];
        self.thumbnailImage = nil;
        
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                [self.tiles setObject:[[Plot alloc] initWithX:x andY:y andTerrain:MapTerrainDefault onMap:self] atX:x andY:y];
            }
        }
    }
    
    return self;
}

- (instancetype)initWithMapSize:(MapSize)mapSize
{
    // get size
    int mapWidth = 10, mapHeight = 10;
    switch (mapSize) {
        case MapSizeDuel:
            mapWidth = 20, mapHeight = 12;
            break;
        case MapSizeTiny:
            mapWidth = 28, mapHeight = 18;
            break;
        case MapSizeSmall:
            mapWidth = 33, mapHeight = 21;
            break;
        case MapSizeDefault:
        case MapSizeStandard:
            mapWidth = 38, mapHeight = 24;
            break;
        case MapSizeLarge:
            mapWidth = 42, mapHeight = 27;
            break;
        case MapSizeHuge:
            mapWidth = 45, mapHeight = 30;
            break;
        default:
            break;
    }
    
    return [self initWithWidth:mapWidth andHeight:mapHeight];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    
    if (self) {
        self.width = [decoder decodeIntegerForKey:MapDataWidthKey];
        self.height = [decoder decodeIntegerForKey:MapDataHeightKey];
        
        self.startPositions = [[NSMutableArray alloc] init];
        NSInteger numOfPositions = [decoder decodeIntegerForKey:MapDataStartPositionsKey];
        for (int i = 0; i < numOfPositions; i++) {
            id obj = [decoder decodeObjectForKey:[NSString stringWithFormat:MapDataStartPositionKey, i]];
            [self.startPositions addObject:obj];
        }
        
        self.continents = [[NSMutableArray alloc] init];
        NSInteger numOfContinents = [decoder decodeIntegerForKey:MapDataContinentsKey];
        for (int i = 0; i < numOfContinents; i++) {
            Continent *continent = [decoder decodeObjectForKey:[NSString stringWithFormat:MapDataContinentKey, i]];
            [self.continents addObject:continent];
        }
        
        self.tiles = [[Array2D alloc] initWithSize:CGSizeMake(self.width, self.height)];
        
        for (int x = 0; x < self.width; x++) {
            for (int y = 0; y < self.height; y++) {
                Plot *plot = [decoder decodeObjectForKey:[NSString stringWithFormat:MapDataTileKey, x, y]];
                [self.tiles setObject:plot atX:x andY:y];
            }
        }
        
        self.thumbnailImage = nil;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.width forKey:MapDataWidthKey];
    [encoder encodeInteger:self.height forKey:MapDataHeightKey];
    
    [encoder encodeInteger:self.startPositions.count forKey:MapDataStartPositionsKey];
    for (int i = 0; i < self.startPositions.count; i++) {
        [encoder encodeObject:[self.startPositions objectAtIndex:i] forKey:[NSString stringWithFormat:MapDataStartPositionKey, i]];
    }
    
    [encoder encodeInteger:self.continents.count forKey:MapDataContinentsKey];
    for (int i = 0; i < self.continents.count; i++) {
        [encoder encodeObject:[self.continents objectAtIndex:i] forKey:[NSString stringWithFormat:MapDataContinentKey, i]];
    }

    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            Plot *plot = [self.tiles objectAtX:x andY:y];
            [encoder encodeObject:plot forKey:[NSString stringWithFormat:MapDataTileKey, x, y]];
        }
    }
}

- (UIImage *)thumbnail
{
    if (self.thumbnailImage == nil) {
        UIColor *green = [UIColor greenColor];
        UIColor *blue = [UIColor blueColor];
        UIColor *black = [UIColor blackColor];
        
        CGSize newSize = CGSizeMake(self.width * 2, self.height * 2 +1);
        UIGraphicsBeginImageContext(newSize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [black CGColor]);
        CGContextFillRect(context, CGRectMake(0, 0, self.width * 2 - 1, self.height * 2));
        
        for (int y = 0; y < self.height; ++y) {
            for (int x = 0; x < self.width; ++x) {
            
                Plot *item = [self.tiles objectAtX:x andY:y];
                if ([item isOcean]) {
                    CGContextSetFillColorWithColor(context, [blue CGColor]);
                } else {
                    CGContextSetFillColorWithColor(context, [green CGColor]);
                }

                CGContextFillRect(context, CGRectMake(x * 2, y * 2 + (x % 2 == 0 ? 1 : 0), 2, 2));
            }
        }
        
        UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        self.thumbnailImage = finalImage;
    }
    
    return self.thumbnailImage;
}

- (void)generateMapWithOptions:(MapOptions *)options withProgress:(MapGenerateProgress)progress
{
    switch (options.mapType) {
        case MapTypeBipolar: {
            BipolarMapGenerator *generator = [[BipolarMapGenerator alloc] initWithMap:self];
            [generator generateWithProgress:progress];
        }
            break;
        case MapTypeDefault:
        case MapTypeContinents:
        case MapTypePangea: {
            OptionsMapGenerator *generator = [[OptionsMapGenerator alloc] initWithMap:self andOptions:options];
            [generator generateWithProgress:progress];
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark tile functions

- (BOOL)isValidAt:(MapPoint *)point
{
    return point.x >= 0 && point.x < self.width && point.y >= 0 && point.y < self.height;
}

- (BOOL)isValidAtX:(NSInteger)x andY:(NSInteger)y
{
    return x >= 0 && x < self.width && y >= 0 && y < self.height;
}

- (Plot *)tileAtX:(NSInteger)x andY:(NSInteger)y
{
    return [self.tiles objectAtX:x andY:y];
}

#pragma mark -
#pragma mark terrain functions

- (MapTerrain)terrainAtX:(NSInteger)x andY:(NSInteger)y
{
    return [self tileAtX:x andY:y].terrain;
}

- (void)setTerrain:(MapTerrain)terrain atX:(NSInteger)x andY:(NSInteger)y
{
    [self tileAtX:x andY:y].terrain = terrain;
}

- (BOOL)isOceanAtX:(NSInteger)x andY:(NSInteger)y
{
    return [[self tileAtX:x andY:y] isOcean];
}

#pragma mark -
#pragma mark feature functions

- (void)addFeature:(MapFeature)feature atX:(NSInteger)x andY:(NSInteger)y
{
    [[self tileAtX:x andY:y] addFeature:feature];
}

- (BOOL)hasFeature:(MapFeature)feature atX:(NSInteger)x andY:(NSInteger)y
{
    return [[self tileAtX:x andY:y] hasFeature:feature];
}

#pragma mark -
#pragma mark river functions

- (void)setRiver:(BOOL)hasRiver atX:(NSInteger)x andY:(NSInteger)y
{
    [[self tileAtX:x andY:y] setRiver:hasRiver];
}

- (BOOL)hasRiverAtX:(NSInteger)x andY:(NSInteger)y
{
    return [[self tileAtX:x andY:y] hasRiver];
}

#pragma mark -
#pragma mark continent functions

- (Continent *)continentByIdentifier:(NSInteger)identifier
{
    for (Continent *continent in self.continents) {
        if (continent.identifier == identifier) {
            return continent;
        }
    }
    
    return nil;
}

- (void)addContinent:(Continent *)continent
{
    [self.continents addObject:continent];
}

#pragma mark -
#pragma mark turn functions

- (void)turn
{
    for (int x = 0; x < self.width; x++) {
        for (int y = 0; y < self.height; y++) {
            [[self.tiles objectAtX:x andY:y] turn];
        }
    }
}

@end
