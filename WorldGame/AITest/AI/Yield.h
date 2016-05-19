//
//  Yield.h
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 type of yields
 */
typedef NS_ENUM(NSInteger, YieldType) {
    YieldTypeNone,
    YieldTypeFood,
    YieldTypeProduction,
    YieldTypeGold,
    YieldTypeScience,
};

/*!
 yields object class
 */
@interface Yield : NSObject

@property (atomic) YieldType yieldType;
@property (atomic) int yield;

- (instancetype)initWithYieldType:(YieldType)yieldType andYield:(int)yield;

@end
