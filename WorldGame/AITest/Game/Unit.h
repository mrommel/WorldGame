//
//  Unit.h
//  AITest
//
//  Created by Michael Rommel on 23.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Unit;
@class Army;

/*!
 type of unit
 */
typedef NS_ENUM(NSInteger, UnitClass) {
    UnitTypeMelee = 0, /* Infantry */
    UnitTypeRanged = 1, /* Archer */
    UnitTypeCavalry = 2,
    UnitTypeSiege = 3,
};

/*!
 type of unit
 */
typedef NS_ENUM(NSInteger, UnitPromotion) {
    UnitPromotionEmbark = 0,
    UnitPromotionSight = 1,
    UnitPromotionHealing = 2,
    UnitPromotionRoadBuilding = 3,
};

/*!
 class that parses unit types / promotions
 */
@interface NSString (EnumParser)

- (UnitClass)unitClassValue;
- (UnitPromotion)unitPromotionValue;

@end

/*!
 class that handles units
 
 loaded from file system
 */
@interface UnitType : NSObject

@property (atomic) UnitClass unitClass;

@property (atomic) int maxHealth;
@property (atomic) int maxFuel;
@property (atomic) int maxAmmo;
@property (atomic) int maxFood;

@property (nonatomic) NSMutableArray *promotions;

@end

/*!
 class that returns all unit types
 */
@interface UnitTypeProvider : NSObject

+ (UnitTypeProvider *)sharedInstance;

- (UnitType *)unitTypeForTypeKey:(NSString *)typeKey;

@end

@class Map;

/*!
 class that handles units
 */
@interface Unit : NSObject

@property (atomic) CGPoint position;
@property (nonatomic) NSString *typeKey;

// variables
@property (nonatomic) UnitType *unitType; // prefilled from typeKey

@property (atomic) int health; // max health from type

// supply
@property (atomic) int fuel; // max fuel from type
@property (atomic) int ammo; // max ammo from type
@property (atomic) int food; // max food from type

@property (nonatomic) NSMutableArray *promotions; // prefilled from type (but can get extended)

- (instancetype)initWithType:(NSString *)typeKey atPosition:(CGPoint)position onMap:(Map *)map;

- (BOOL)hasPromotion:(UnitPromotion)promotion;
- (void)addPromotion:(UnitPromotion)promotion;

@end

@class ArmyLeader;

/*!
 class that handles an unit combat results
 */
@interface UnitCombatResult : NSObject

@property (nonatomic) Unit *attacker;
@property (nonatomic) Unit *defender;

@property (atomic) int attackerLosesHealth;
@property (atomic) int defenderLosesHealth;

@property (atomic) int attackerGainsExperience;
@property (atomic) int defenderGainsExperience;

@property (atomic) int defenderLosesEntrenchment;

@end

/*!
 type of combat result
 */
typedef NS_ENUM(NSInteger, CombatResultType) {
    CombatResultTypeAbort = 0,
    CombatResultTypeMajorVictory = 1,
    CombatResultTypeMinorVictory = 2,
    CombatResultTypeUndetermined = 3,
    CombatResultTypeMinorDefeat = 3,
    CombatResultTypeMajorDefeat = 5
};

/*!
 class that handles an unit combat results
 */
@interface CombatResult : NSObject

@property (atomic) CombatResultType combatResultType;
@property (nonatomic) NSMutableArray *unitCombatResults;

- (instancetype)initWithCombatResultType:(CombatResultType)combatResultType;

@end

/*!
 callback for game turn events
 */
typedef void (^CombatCallback)(CombatResult *combatResult);

/*!
 class that handles an army
 */
@interface Army : NSObject

@property (nonatomic) NSMutableArray *units;
@property (nonatomic) ArmyLeader *leader;
@property (nonatomic) NSString *name;

- (instancetype)initWithLeader:(ArmyLeader *)leader;

- (void)addUnit:(Unit *)unit;
- (void)join:(Army *)army;

- (void)attackArmy:(Army *)army withCallback:(CombatCallback)callback;
- (void)siegeCityAt:(CGPoint)position withCallback:(CombatCallback)callback;

@end

/*!
 class that handles an army leader
 */
@interface ArmyLeader : NSObject

- (instancetype)initWithName:(NSString *)name;

@end


