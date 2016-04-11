//
//  GrandStrategyAI.h
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 type of grand strategy
 */
typedef NS_ENUM(NSInteger, GrandStrategyType) {
    GrandStrategyTypeCulture,
    GrandStrategyTypeConquest
};

/*!
 grand strategy
 */
@interface GrandStrategyAI : NSObject

@property (atomic) GrandStrategyType grandStrategyType;

// flavors are for AI to choose
@property (nonatomic) NSMutableArray *flavors;
@property (nonatomic) NSMutableArray *yields;

- (instancetype)initWithGrandStrategyType:(GrandStrategyType)type;

@end
