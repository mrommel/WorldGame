//
//  Policy.m
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Policy.h"
#import "PolicyInfo.h"

@interface Policy()

@property (nonatomic) NSMutableArray *values;

@end

@implementation Policy

- (instancetype)initWithPolicyInfo:(PolicyInfo *)policyInfo;
{
    self = [super init];
    
    if (self) {
        NSAssert(policyInfo != nil, @"PolicyInfo must not be nil");
        
        self.name = policyInfo.name;
        self.desc = policyInfo.desc;
        self.ministry = policyInfo.ministry;
        self.items = [[NSMutableArray alloc] init];
        self.current = 0;
        
        self.values = [NSMutableArray new];
        [self.values addObject:[NSNumber numberWithFloat:self.current]];
        
        for (PolicyState *state in policyInfo.states) {
            [self.items addObject:state];
        }
    }
    
    return self;
}

- (void)setCurrentItem:(int)current
{
    NSAssert(current >= 0, @"Current item must be greater than zero");
    NSAssert(current < self.items.count, @"Current item must be smaller than items list");
    
    self.current = current;
}

- (float)valueWithDelay:(int)delay
{
    NSAssert(self.items.count > 0, @"Policy %@ does not have any items", self.name);
    
    if (delay < self.values.count) {
        return [[self.values objectAtIndex:delay] floatValue] / (float)(self.items.count - 1);
    }
    
    return [[self.values firstObject] floatValue] / (float)(self.items.count - 1);
}

- (void)stack
{
    // limit ?
    [self.values insertObject:[NSNumber numberWithFloat:self.current] atIndex:0];
}

- (NSUInteger)stackedValuesCount
{
    return self.values.count;
}

- (NSArray *)stackedValues
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i = 0; i < self.values.count; i++) {
        [array addObject:[NSNumber numberWithFloat:[self valueWithDelay:i]]];
    }
    
    return array;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Policy name: %@, current: %@, value: %.2f]", self.name, [self.values objectAtIndex:self.current], [self valueWithDelay:0]];
}

@end
