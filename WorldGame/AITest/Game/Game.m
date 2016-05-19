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
}

- (void)turnWithProgress:(GameTurnProgress)progress
{
    int numberOfTurns = 2 + (int)self.players.count;
    progress(@"Start", 0, numberOfTurns);
    
    [self.map turn];
    progress(@"Execute Map", 1, numberOfTurns);
    
    // an now every ai player
    for (int i = 0; i < self.players.count; i++) {
        Player *player = [self.players objectAtIndex:i];

        if ([player isArtificial]) {
            [player turn];
            progress(@"Turned ai player", 2 + i, numberOfTurns);
        } else {
            [player turn];
            progress(@"Turned human player player", 2 + i, numberOfTurns);
        }
    }
    
    self.currentTurn++;
    progress(@"End", numberOfTurns, numberOfTurns);
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