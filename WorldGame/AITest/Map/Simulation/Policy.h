//
//  Policy.h
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PolicyInfo.h"

/*!
 class that
 */
@interface Policy : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *desc;
@property (atomic) Ministry ministry;
@property (nonatomic) NSMutableArray *items;
@property (atomic, getter=setCurrentItem) int current;

- (instancetype)initWithPolicyInfo:(PolicyInfo *)policyInfo;

- (void)setCurrentItem:(int)current;

- (float)valueWithDelay:(int)delay;

- (void)stack;
- (NSUInteger)stackedValuesCount;
- (NSArray *)stackedValues;

@end
