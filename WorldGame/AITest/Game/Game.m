//
//  Game.m
//  AITest
//
//  Created by Michael Rommel on 22.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Game.h"

#import "Player.h"
#import "Civilization.h"
#import "Leader.h"
#import "GamePersistance.h"
#import "Array2D.h"
#import "MapPoint.h"
#import "KeyValueMap.h"

#define kDataKey        @"Game"
#define kDataFile       @"game.plist"

static NSString* const GameDataNameKey = @"Game.Name";
static NSString* const GameDataDateKey = @"Game.Date";

static NSString* const GameDataMapKey = @"Game.Map";
static NSString* const GameDataPlayersKey = @"Game.Players";
static NSString* const GameDataPlayerKey = @"Game.Player.%d";

@interface Game()

@end

@implementation Game

- (instancetype)initWithMap:(Map *)map andNumberOfPlayers:(int)numberOfPlayers
{
    self = [super init];
    
    if (self) {
        self.map = map;
        self.players = [[NSMutableArray alloc] init];
        
        [self createPlayers:numberOfPlayers];
    }
    
    return self;
}

#pragma mark -
#pragma mark load/save

- (instancetype)initWithPath:(NSString *)gamePath
{
    NSData* decodedData = [NSData dataWithContentsOfFile:gamePath];
    
    if ((self = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData])) {
        _gamePath = [gamePath copy];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        self.name = [decoder decodeObjectForKey:GameDataNameKey];
        self.date = [decoder decodeObjectForKey:GameDataDateKey];
        
        self.map = [decoder decodeObjectForKey:GameDataMapKey];

        NSUInteger numOfPlayers = [decoder decodeIntegerForKey:GameDataPlayersKey];
        for (int i = 0; i < numOfPlayers; i++) {
            Player *player = [decoder decodeObjectForKey:[NSString stringWithFormat:GameDataPlayerKey, i]];
            [self.players addObject:player];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.name forKey:GameDataNameKey];
    [encoder encodeObject:self.date forKey:GameDataDateKey];
    
    [encoder encodeObject:self.map forKey:GameDataMapKey];
    
    [encoder encodeInteger:self.players.count forKey:GameDataPlayersKey];
    for (int i = 0; i < self.players.count; i++) {
        [encoder encodeObject:[self.players objectAtIndex:i] forKey:[NSString stringWithFormat:GameDataPlayerKey, i]];
    }
}

- (void)saveWithName:(NSString *)name
{
    [self createDataPath];
    
    // store the current timestamp
    self.date = [[NSDate alloc] init];
    self.name = name;
    
    NSData* encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:self.gamePath atomically:YES];
}

- (void)delete
{
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:self.gamePath error:&error];
    if (!success) {
        NSLog(@"Error removing document path: %@", error.localizedDescription);
    }
}

- (BOOL)createDataPath
{
    if (_gamePath == nil) {
        self.gamePath = [GamePersistance nextGamePath];
    }
    
    return YES;
}

#pragma mark -

- (void)createPlayers:(int)numberOfPlayers
{
    NSAssert(self.map.startPositions.count >= numberOfPlayers, @"Not enough starting spots in the map: %lu when %d are needed", (unsigned long)self.map.startPositions.count, numberOfPlayers);
    
    // Human player
    Civilization *civilization = [[CivilizationProvider sharedInstance] randomCivilization];
    CGPoint startPosition = [[self.map.startPositions objectAtIndex:0] CGPointValue];
    HumanPlayer *humanPlayer = [[HumanPlayer alloc] initWithStartPosition:startPosition andCivilization:civilization];
    [[self.map tileAtX:startPosition.x andY:startPosition.y] setOwnerIdentifier:humanPlayer.identifier];
    [self.map tileAtX:startPosition.x andY:startPosition.y].inhabitants = 500;
    [self.players addObject:humanPlayer];
    
    // AI players
    for (int i = 1; i < numberOfPlayers; i++) {
        Civilization *civilization = [[CivilizationProvider sharedInstance] randomCivilization];
        CGPoint startPosition = [[self.map.startPositions objectAtIndex:i] CGPointValue];
        AIPlayer *player = [[AIPlayer alloc] initWithStartPosition:startPosition andCivilization:civilization];
        player.leader = [[LeaderProvider sharedInstance] randomLeaderForCivilizationName:civilization.name];
        [[self.map tileAtX:startPosition.x andY:startPosition.y] setOwnerIdentifier:player.identifier];
        [self.map tileAtX:startPosition.x andY:startPosition.y].inhabitants = 500;
        [self.players addObject:player];
    }
    
    // create site evaluater
    
    
    // set start positions
    
    // attach the delegates
    [self attachDelegates];
}

- (void)attachDelegates
{
    // iterate tiles
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            Plot *tile = [self.map tileAtX:i andY:j];
            
            tile.delegate = self;
            tile.economy.delegate = self;
        }
    }
}

#pragma mark -
#pragma mark PlotDelegate functions

- (void)plot:(Plot *)plot handlePopulationStateChangeFrom:(PlotPopulationState)fromPlotPopulationState to:(PlotPopulationState)toPlotPopulationState
{
    NSLog(@"handlePopulationStateChangeFrom");
}

- (void)plot:(Plot *)plot handlePlayerShouldRequestTileDueToPopulationIncrease:(NSInteger)newPopulation
{
    NSLog(@"handlePlayerShouldRequestTileDueToPopulationIncrease");
    
    KeyValueMap *inhabitantsMap = [[KeyValueMap alloc] init];
    
    // we need to find out which player, we should request the tile
    for (NSNumber *direction in HEXDIRECTIONS) {
        MapPoint *pt = [plot.coordinate neighborInDirection:[direction intValue]];
        if ([self.map isValidAt:pt]) {
            Plot *neighbor = [self.map tileAtX:pt.x andY:pt.y];
            
            [inhabitantsMap addValue:neighbor.inhabitants forKey:[NSString stringWithFormat:@"%ld", (long)neighbor.ownerIdentifier]];
        }
    }
    
    NSInteger newOwner = [[inhabitantsMap keyOfHeightestValue] integerValue];
    
    [plot setOwnerIdentifier:newOwner];
    
    if (self.delegate) {
        [self.delegate requestNeedsDisplay];
    }
}

#pragma mark -
#pragma mark PlotEconomyDelegate functions

- (void)economy:(PlotEconomy *)economy handleTooLittleSoilForPeasants:(NSInteger)peasants
{
    // NOOP
}

- (void)economy:(PlotEconomy *)economy handleLittleFood:(NSInteger)foodRemaining
{
    // NOOP
}

- (void)economy:(PlotEconomy *)economy handleTooLittleFood:(NSInteger)foodRemaining
{
    // NOOP
}

#pragma mark -
#pragma mark turn functions

- (void)turnWithProgress:(GameTurnProgress)progress
{
    int numberOfTurns = 3 + (int)self.players.count;
    progress(@"Start", 0, numberOfTurns);
    
    [self.map turn];
    progress(@"Execute Map", 1, numberOfTurns);
    
    [self handleMigration];
    progress(@"handle migration", 1, numberOfTurns);
    
    // an now every ai player
    for (int i = 0; i < self.players.count; i++) {
        Player *player = [self.players objectAtIndex:i];

        if ([player isArtificial]) {
            [player turn];
            progress(@"Turned ai player", 3 + i, numberOfTurns);
        } else {
            [player turn];
            progress(@"Turned human player player", 3 + i, numberOfTurns);
        }
    }
    
    self.currentTurn++;
    progress(@"End", numberOfTurns, numberOfTurns);
}

- (void)handleMigration
{
    Array2D *migrants = [Array2D arrayWithSize:CGSizeMake([GameProvider sharedInstance].game.map.width, [GameProvider sharedInstance].game.map.height)];
    [migrants fillWithFloat:0];
    
    Array2D *weights = [Array2D arrayWithSize:CGSizeMake([GameProvider sharedInstance].game.map.width, [GameProvider sharedInstance].game.map.height)];
    [weights fillWithFloat:0];
    
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            Plot *tile = [self.map tileAtX:i andY:j];
            
            [migrants setFloat:[tile possibleMigrants] atX:i andY:j];
            [weights setFloat:[tile migrationWeight] atX:i andY:j];
        }
    }
    
    for (int i = 0; i < self.map.width; i++) {
        for (int j = 0; j < self.map.height; j++) {
            Plot *tile = [self.map tileAtX:i andY:j];
            
            float tileWeight = [weights intAtX:i andY:j];
            float tileMigrants = [migrants intAtX:i andY:j];
            float neighborsWeight = 0;
            float neighborsMigrants = 0;
            int neighbors = 0;
            
            for (NSNumber *direction in HEXDIRECTIONS) {
                MapPoint *pt = [tile.coordinate neighborInDirection:[direction intValue]];
                if ([self.map isValidAt:pt]) {
                    Plot *neighbor = [self.map tileAtX:pt.x andY:pt.y];
                
                    if ([neighbor isLandmass]) {
                        neighborsWeight += [weights intAtX:neighbor.coordinate.x andY:neighbor.coordinate.y];
                        neighborsMigrants += [migrants intAtX:neighbor.coordinate.x andY:neighbor.coordinate.y];
                        neighbors++;
                    }
                }
            }
            
            // examples:
            // weight: 5 / [2, 1, 0, 0, 1, 1] = 5
            // migrants: 3 + 0 = 3
            // => 1.5 / 1.5
            //
            // weight: 2 / [0.01, 0.01, 0.01, 0.01, 0.01, 2] = 2.5
            // migrants: 6 + 1 = 7
            // => 3.11 / 3.88
            //
            // weight: 0.01 / [0.01, 0.01, 0.01, 0.01, 0.01, 2] = 2.5
            // migrants: 1 + 6 = 7
            // => 3.11 / 3.88
            if (neighbors > 0 && neighborsWeight > 0) {
                float newMigrants = neighborsWeight * (tileMigrants + neighborsWeight) / (tileWeight + neighborsWeight);
                tile.inhabitants -= tileMigrants;
                tile.inhabitants += newMigrants;
            }
        }
    }
}

- (Player *)humanPlayer
{
    for (Player *player in self.players) {
        if ([player isHuman]) {
            return player;
        }
    }
    
    return nil;
}

- (Player *)playerForIdentifier:(NSUInteger)identifier
{
    for (Player *player in self.players) {
        if (player.identifier == identifier) {
            return player;
        }
    }
    
    return nil;
}

@end

@implementation GameProvider

static GameProvider *shared = nil;

+ (GameProvider *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[GameProvider alloc] init];
        }
    }
    
    return shared;
}

@end