//
//  Player.h
//  AITest
//
//  Created by Michael Rommel on 22.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Policy.h"

@class Unit;
@class GrandStrategyAI;
@class Civilization;
@class Leader;
@class Government;

/*!
 type of ministry
 */
typedef NS_ENUM(NSInteger, EventType) {
    EventTypeClaim,
    EventTypeConquest,
    EventTypeSold,
};

/*!
 class that hold an player (human or ai)
 */
@interface Player : NSObject<NSCoding>

@property (nonatomic) Civilization *civilization;
@property (nonatomic) Leader *leader;
@property (nonatomic) NSMutableArray *units;
@property (nonatomic) NSMutableArray *cities;
@property (atomic) CGPoint position; // start position

// government system
@property (nonatomic) Government *government;

// policies
@property (nonatomic) NSMutableArray *policies;

@property (nonatomic) Policy *inheritanceTax;
@property (nonatomic) Policy *incomeTax;
@property (nonatomic) Policy *salesTax;

@property (nonatomic) Policy *policeForce;
@property (nonatomic) Policy *stateSchools;
@property (nonatomic) Policy *nationalService;

- (instancetype)initWithStartPosition:(CGPoint)position andCivilization:(Civilization *)civilization;

- (BOOL)isHuman;
- (BOOL)isArtificial;

- (void)addUnit:(Unit *)unit;
- (void)settleAtX:(int)x andY:(int)y;

- (NSMutableArray *)policiesForMinistry:(Ministry)ministry;

- (void)turn;

@end

/*!
 class that hold an Human player
 */
@interface HumanPlayer : Player

- (instancetype)initWithStartPosition:(CGPoint)position andCivilization:(Civilization *)civilization;

- (BOOL)isHuman;

@end

/*!
 class that hold an AI player
 */
@interface AIPlayer : Player

// AI Grand Strategies
@property (nonatomic) GrandStrategyAI *grandStrategyAI;

// Diplomacy AI
// @property (nonatomic) DiplomacyAI *diplomacyAI;

// AI Tactics
// @property (nonatomic) TacticalAI *tacticalAI;
// @property (nonatomic) HomelandAI *homelandAI;

- (instancetype)initWithStartPosition:(CGPoint)position andCivilization:(Civilization *)civilization;

- (BOOL)isArtificial;

@end
