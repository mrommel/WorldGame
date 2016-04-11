//
//  Relation.m
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Relation.h"

#import "Policy.h"
#import "Simulation.h"

@implementation Relation

- (instancetype)initWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation
{
    self = [super init];
    
    if (self) {
        self.formula = formula;
        self.simulation = simulation;
        self.policy = nil;
        self.group = nil;
        self.delay = 0;
    }
    
    return self;
}

- (instancetype)initWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation withDelay:(int)delay
{
    self = [super init];
    
    if (self) {
        self.formula = formula;
        self.simulation = simulation;
        self.policy = nil;
        self.group = nil;
        self.delay = delay;
    }
    
    return self;
}

- (instancetype)initWithFormula:(NSString *)formula toPolicy:(Policy *)policy
{
    self = [super init];
    
    if (self) {
        self.formula = formula;
        self.simulation = nil;
        self.group = nil;
        self.policy = policy;
        self.delay = 0;
    }
    
    return self;
}

- (instancetype)initWithFormula:(NSString *)formula toPolicy:(Policy *)policy withDelay:(int)delay
{
    self = [super init];
    
    if (self) {
        self.formula = formula;
        self.simulation = nil;
        self.group = nil;
        self.policy = policy;
        self.delay = delay;
    }
    
    return self;
}

- (instancetype)initWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue
{
    self = [super init];
    
    if (self) {
        self.formula = formula;
        self.simulation = nil;
        self.policy = nil;
        self.group = group;
        self.groupValue = groupValue;
        self.delay = 0;
    }
    
    return self;
}

- (instancetype)initWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue withDelay:(int)delay
{
    self = [super init];
    
    if (self) {
        self.formula = formula;
        self.simulation = nil;
        self.policy = nil;
        self.group = group;
        self.groupValue = groupValue;
        self.delay = delay;
    }
    
    return self;
}

- (float)evaluate
{
    NSExpression *expression = [NSExpression expressionWithFormat:self.formula];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.simulation) {
        [dict setObject:[NSNumber numberWithFloat:[self.simulation valueWithDelay:self.delay]] forKey:@"x"];
    } else if (self.policy) {
        [dict setObject:[NSNumber numberWithFloat:[self.policy valueWithDelay:self.delay]] forKey:@"x"];
    } else {
        if (self.groupValue == GroupValueFreq) {
            [dict setObject:[NSNumber numberWithFloat:[self.group frequencyWithDelay:self.delay]] forKey:@"x"];
        } else {
            [dict setObject:[NSNumber numberWithFloat:[self.group moodWithDelay:self.delay]] forKey:@"x"];
        }
    }
    
    NSNumber *result = [expression expressionValueWithObject:dict context:nil];
    //NSLog(@"%@", result);
    return [result floatValue];
}

@end
