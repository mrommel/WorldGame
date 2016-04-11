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

/*!
 type of unitorder
 */
typedef NS_ENUM(NSInteger, UnitOrderType) {
    UnitOrderTypeDefault,
    UnitOrderTypeStay, /* Idle */
    UnitOrderTypeMove,
    UnitOrderTypeFound,
    UnitOrderTypeBuild,
    UnitOrderTypeAttack,
    UnitOrderTypeDefend,
    UnitOrderTypeSupport
};

/*!
 this class represents something a Unit can execute
 */
@interface UnitOrder : NSObject

@property (atomic) UnitOrderType orderType;
@property (atomic) CGPoint destination;
@property (nonatomic) Unit *target;

- (instancetype)initWithType:(UnitOrderType)orderType andDestination:(CGPoint)destination;
- (instancetype)initWithType:(UnitOrderType)orderType andTarget:(Unit *)target;

@end

/*!
 type of unit
 */
typedef NS_ENUM(NSInteger, UnitType) {
    UnitTypeDefault,
    UnitTypeWorker,
    UnitTypeWarrior,
    UnitTypeArcher
};

@class Map;

/*!
 class that handles units
 */
@interface Unit : NSObject

@property (atomic) CGPoint position;
@property (atomic) UnitType type;
@property (atomic) int health; /* 0 .. 100 */

- (instancetype)initWithPosition:(CGPoint)position andType:(UnitType)type;

- (BOOL)executeOrder:(UnitOrder *)order onMap:(Map *)map;

@end
