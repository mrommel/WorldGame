//
//  Yield.m
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Yield.h"

@implementation Yield

- (instancetype)initWithYieldType:(YieldType)yieldType andYield:(int)yield
{
    self = [super init];
    
    if (self) {
        self.yieldType = yieldType;
        self.yield = yield;
    }
    
    return self;
}

@end
