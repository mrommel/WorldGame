//
//  AISimulationInput.m
//  WorldGame
//
//  Created by Michael Rommel on 10.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AISimulationInput.h"

@implementation AISimulationInput

- (instancetype)initWithName:(NSString *)name
                 explanation:(NSString *)explanation
               startingValue:(CGFloat)value
                 andCategory:(AISimulationCategory)category
{
    return [super initWithName:name explanation:explanation startingValue:value andCategory:category];
}

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula
{
    @throw [NSException exceptionWithName:@"AISimulationInput" reason:@"input not allowed" userInfo:nil];
}

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay
{
    @throw [NSException exceptionWithName:@"AISimulationInput" reason:@"input not allowed" userInfo:nil];
}

- (void)addStaticInputValue:(CGFloat)staticValue
{
    @throw [NSException exceptionWithName:@"AISimulationInput" reason:@"input not allowed" userInfo:nil];
}

- (void)calculate
{
    [self setValue:[self valueWithoutDelay]];
}

@end
