//
//  Unit.m
//  AITest
//
//  Created by Michael Rommel on 23.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Unit.h"

#import "Map.h"

#define INVALID_POINT   CGPointMake(-1, -1)

@implementation UnitOrder

- (instancetype)initWithType:(UnitOrderType)orderType andDestination:(CGPoint)destination
{
    NSAssert(orderType == UnitOrderTypeStay ||
             orderType == UnitOrderTypeMove, @"Unsupported OrderType for constructor");
    
    self = [super init];
    
    if (self) {
        self.orderType = orderType;
        self.target = nil;
        self.destination = destination;
    }
    
    return self;
}

- (instancetype)initWithType:(UnitOrderType)orderType andTarget:(Unit *)target
{
    NSAssert(orderType == UnitOrderTypeAttack ||
             orderType == UnitOrderTypeSupport, @"Unsupported OrderType for constructor");
    
    self = [super init];
    
    if (self) {
        self.orderType = orderType;
        self.target = target;
        self.destination = INVALID_POINT;
    }
    
    return self;
}

@end

@implementation Unit

- (instancetype)initWithPosition:(CGPoint)position andType:(UnitType)type
{
    self = [super init];
    
    if (self) {
        self.type = type;
        self.position = position;
        self.health = 100;
    }
    
    return self;
}

- (BOOL)executeOrder:(UnitOrder *)order onMap:(Map *)map
{
    switch (order.orderType) {
        case UnitOrderTypeMove:
            
            break;
        default:
            break;
    }
    
    return YES;
}

@end
