//
//  AISimulationProperty.m
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AISimulationProperty.h"

@interface AISimulationPropertyRelation : NSObject

@property (nonatomic) AISimulationProperty *property;
@property (nonatomic) NSString *formula;
@property (atomic) NSInteger delay;

- (instancetype)initWithProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay;

@end

@implementation AISimulationPropertyRelation

- (instancetype)initWithProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay
{
    self = [super init];
    
    if (self) {
        self.property = property;
        self.formula = formula;
        self.delay = delay;
    }
    
    return self;
}

@end

#pragma mark -
#pragma mark SimulationProperty methods

@interface AISimulationProperty()

@property (nonatomic) NSMutableArray *values; // values are feed in from the start
@property (nonatomic) NSMutableArray *inputs;
@property (nonatomic) NSMutableArray *outputs;

@end

@implementation AISimulationProperty

- (instancetype)initWithName:(NSString *)name
                 explanation:(NSString *)explanation
               startingValue:(CGFloat)value
                 andCategory:(AISimulationCategory)category
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.explanation = explanation;
        self.values = [NSMutableArray new];
        [self.values addObject:[NSNumber numberWithDouble:value]];
        self.inputs = [NSMutableArray new];
        self.outputs = [NSMutableArray new];
        self.category = category;
    }
    
    return self;
}

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula
{
    [self addInputProperty:property withFormula:formula andDelay:0];
}

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay
{
    [self.inputs addObject:[[AISimulationPropertyRelation alloc] initWithProperty:property withFormula:formula andDelay:delay]];
    
    if (property != nil) {
        [property addOutputProperty:self];
    }
}

- (void)addStaticInputValue:(CGFloat)staticValue
{
    [self addInputProperty:nil withFormula:[NSString stringWithFormat:@"%f", staticValue] andDelay:0];
}

- (void)addOutputProperty:(AISimulationProperty *)property
{
    [self.outputs addObject:property];
}

- (void)calculate
{
    CGFloat newValue = 0;
    
    for (AISimulationPropertyRelation *relation in self.inputs) {
        NSExpression *expression = [NSExpression expressionWithFormat:relation.formula];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        if (relation.property != nil) {
            [dict setObject:[NSNumber numberWithFloat:[relation.property valueWithDelay:relation.delay]] forKey:@"x"];
        }
        
        NSNumber *result = [expression expressionValueWithObject:dict context:nil];
        //NSLog(@"%@", result);

        newValue += [result floatValue];
    }
    
    CGFloat weigthedValue = newValue * 0.5 + [self valueWithoutDelay] * 0.5;
    
    [self setValue:weigthedValue];
}

- (void)setValue:(CGFloat)value
{
    [self.values insertObject:[NSNumber numberWithDouble:value] atIndex:0];
}

- (CGFloat)valueWithoutDelay
{
    return [self valueWithDelay:0];
}

- (CGFloat)valueWithDelay:(NSInteger)delay
{
    if ([self.values count] > delay) {
        return [[self.values objectAtIndex:delay] floatValue];
    }
    
    return [[self.values firstObject] floatValue];
}

#warning todo: maybe we need keep the relation and not only the property
- (NSArray *)listOfInputs
{
    NSMutableArray *listOfInputProperties = [NSMutableArray new];
    
    [self.inputs enumerateObjectsUsingBlock:^(AISimulationPropertyRelation* obj, NSUInteger idx, BOOL *stop) {
        [listOfInputProperties addObject:obj.property];
    }];
    
    return listOfInputProperties;
}

- (NSArray *)listOfOutputs
{
    return self.outputs;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{ AISimulationProperty: { Name: %@, Value: %.4f } }", self.name, [self valueWithoutDelay]];
}

@end
