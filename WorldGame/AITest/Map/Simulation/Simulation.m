//
//  Simulation.m
//  AITest
//
//  Created by Michael Rommel on 26.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Simulation.h"

#import "Relation.h"

@interface Simulation()

@property (atomic) float value;
@property (nonatomic) NSMutableArray *values;
@property (nonatomic) NSMutableArray *relations;

@end

@implementation Simulation

- (instancetype)initWithName:(NSString *)name andDefaultValue:(float)value
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.value = value;
        
        self.relations = [NSMutableArray new];
        self.values = [NSMutableArray new];
        [self.values addObject:[NSNumber numberWithFloat:value]];
    }
    
    return self;
}

- (void)addRelationWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation
{
    [self.relations addObject:[[Relation alloc] initWithFormula:formula toSimulation:simulation]];
}

- (void)addRelationWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation withDelay:(int)delay
{
    [self.relations addObject:[[Relation alloc] initWithFormula:formula toSimulation:simulation withDelay:delay]];
}

- (void)addRelationWithFormula:(NSString *)formula toPolicy:(Policy *)policy
{
    [self.relations addObject:[[Relation alloc] initWithFormula:formula toPolicy:policy]];
}

- (void)addRelationWithFormula:(NSString *)formula toPolicy:(Policy *)policy withDelay:(int)delay
{
    [self.relations addObject:[[Relation alloc] initWithFormula:formula toPolicy:policy withDelay:delay]];
}

- (void)addRelationWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue
{
    [self.relations addObject:[[Relation alloc] initWithFormula:formula toGroup:group forGroupValue:groupValue]];
}

- (void)addRelationWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue withDelay:(int)delay
{
    [self.relations addObject:[[Relation alloc] initWithFormula:formula toGroup:group forGroupValue:groupValue withDelay:delay]];
}

- (float)valueWithDelay:(int)delay
{
    if (delay < self.values.count) {
        return [[self.values objectAtIndex:delay] floatValue];
    }
    
    return [[self.values firstObject] floatValue];
}

- (void)turn
{
    self.value = 0.0f;
    
    for (Relation *relation in self.relations) {
        self.value += [relation evaluate];
    }
    
    self.value = MAX(0.0f, MIN(1.0f, self.value));
}

- (void)stack
{
    // limit
    float factor = 0.3f;
    float reverseFactor = 1.0f - factor;
    self.value = self.value * factor + [[self.values firstObject] floatValue] * reverseFactor;
    self.value = MAX(0, MIN(self.value, 1));
    
    [self.values insertObject:[NSNumber numberWithFloat:self.value] atIndex:0];
}
          
- (NSString *)description
{
    return [NSString stringWithFormat:@"[Simulation name: %@, value: %.2f]", self.name, self.value];
}

@end

