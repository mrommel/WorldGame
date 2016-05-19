//
//  Game.h
//  AITest
//
//  Created by Michael Rommel on 22.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Map.h"
#import "Plot.h"
#import "PlotEconomy.h"

/*!
 callback for game turn events
 */
typedef void (^GameTurnProgress)(NSString *, int, int);

/*!
 delegate
 */
@protocol GameDelegate <NSObject>

- (void)requestNeedsDisplay;

@end

/*!
 class the holds all the game objects
 */
@interface Game : NSObject<NSCoding, PlotDelegate, PlotEconomyDelegate>

@property (nonatomic) NSString *name;
@property (nonatomic) NSDate *date;

@property (nonatomic) Map *map;
@property (nonatomic) NSMutableArray *players;
@property (atomic) int currentTurn;

@property (copy) NSString *gamePath;

@property (nonatomic) id<GameDelegate> delegate;

// methods

- (instancetype)initWithMap:(Map *)map andNumberOfPlayers:(int)numberOfPlayers;

- (instancetype)initWithPath:(NSString *)gamePath;
- (void)saveWithName:(NSString *)name;
- (void)delete;

- (void)turnWithProgress:(GameTurnProgress)progress;

- (Player *)humanPlayer;
- (Player *)playerForIdentifier:(NSUInteger)identifier;

- (void)logGameState;

@end

/*!
 class that provides the one and only game object
 */
@interface GameProvider : NSObject

@property (nonatomic) Game *game;

+ (GameProvider *)sharedInstance;

@end