//
//  Group.m
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Group.h"

#import "Relation.h"
#import "GroupType.h"

/*!
 
 */
@interface Group()

@property (atomic) float freqValue;
@property (nonatomic) NSMutableArray *freqValues;
@property (nonatomic) NSMutableArray *freqRelations;

@property (atomic) float moodValue;
@property (nonatomic) NSMutableArray *moodValues;
@property (nonatomic) NSMutableArray *moodRelations;

@end

@implementation Group

- (instancetype)initWithName:(NSString *)name andGroupType:(GroupType *)groupType
{
    self = [super init];
    
    if (self) {
        self.name = name;
        
        self.freqValues = [NSMutableArray new];
        [self.freqValues addObject:[NSNumber numberWithFloat:0.1f]];
        self.freqRelations = [NSMutableArray new];
        
        self.moodValues = [NSMutableArray new];
        [self.moodValues addObject:[NSNumber numberWithFloat:0.2f]];
        self.moodRelations = [NSMutableArray new];
        
        [groupType addGroup:self];
    }
    
    return self;
}

- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toSimulation:(Simulation *)simulation
{
    if (groupValue == GroupValueFreq) {
        [self.freqRelations addObject:[[Relation alloc] initWithFormula:formula toSimulation:simulation]];
    } else if (groupValue == GroupValueMood) {
        [self.moodRelations addObject:[[Relation alloc] initWithFormula:formula toSimulation:simulation]];
    }
}

- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toSimulation:(Simulation *)simulation withDelay:(int)delay
{
    if (groupValue == GroupValueFreq) {
        [self.freqRelations addObject:[[Relation alloc] initWithFormula:formula toSimulation:simulation withDelay:delay]];
    } else if (groupValue == GroupValueMood) {
        [self.moodRelations addObject:[[Relation alloc] initWithFormula:formula toSimulation:simulation withDelay:delay]];
    }
}

- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toPolicy:(Policy *)policy
{
    if (groupValue == GroupValueFreq) {
        [self.freqRelations addObject:[[Relation alloc] initWithFormula:formula toPolicy:policy]];
    } else if (groupValue == GroupValueMood) {
        [self.moodRelations addObject:[[Relation alloc] initWithFormula:formula toPolicy:policy]];
    }
}

- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toPolicy:(Policy *)policy withDelay:(int)delay
{
    if (groupValue == GroupValueFreq) {
        [self.freqRelations addObject:[[Relation alloc] initWithFormula:formula toPolicy:policy withDelay:delay]];
    } else if (groupValue == GroupValueMood) {
        [self.moodRelations addObject:[[Relation alloc] initWithFormula:formula toPolicy:policy withDelay:delay]];
    }
}

- (float)valueForGroupValue:(GroupValue)groupValue withDelay:(int)delay
{
    if (groupValue == GroupValueFreq) {
        return [self frequencyWithDelay:delay];
    } else if (groupValue == GroupValueMood) {
        return [self moodWithDelay:delay];
    }
    
    return 0.0f;
}

- (float)frequencyWithDelay:(int)delay
{
    if (delay < self.freqValues.count) {
        return [[self.freqValues objectAtIndex:delay] floatValue];
    }
    
    return [[self.freqValues firstObject] floatValue];
}

- (float)moodWithDelay:(int)delay
{
    if (delay < self.moodValues.count) {
        return [[self.moodValues objectAtIndex:delay] floatValue];
    }
    
    return [[self.moodValues firstObject] floatValue];
}

- (void)updateFrequenceValue:(float)frequency
{
    self.freqValue = frequency;
}

- (void)turn
{
    self.moodValue = 0.0f;
    for (Relation *relation in self.moodRelations) {
        self.moodValue += [relation evaluate];
    }
    
    self.freqValue = 0.0f;
    for (Relation *relation in self.freqRelations) {
        self.freqValue += [relation evaluate];
    }
    
    self.moodValue = MAX(0.0f, MIN(1.0f, self.moodValue));
    self.freqValue = MAX(0.0f, MIN(1.0f, self.freqValue));
    
    // fix for groups without grouptype
    if (self.groupType == nil) {
        self.freqValue = 1.0f;
    }
}

- (void)stack
{
    self.freqValue = self.freqValue > 1.0f ? 1.0f : self.freqValue;
    self.freqValue = self.freqValue < 0.0f ? 0.0f : self.freqValue;
    
    [self.freqValues insertObject:[NSNumber numberWithFloat:self.freqValue] atIndex:0];
    [self.moodValues insertObject:[NSNumber numberWithFloat:self.moodValue] atIndex:0];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[Group name: %@, mood: %.2f, freq: %.2f]", self.name, self.moodValue, self.freqValue];
}

@end

