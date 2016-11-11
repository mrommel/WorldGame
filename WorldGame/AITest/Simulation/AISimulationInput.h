//
//  AISimulationInput.h
//  WorldGame
//
//  Created by Michael Rommel on 10.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AISimulationProperty.h"

@interface AISimulationInput : AISimulationProperty

- (instancetype)initWithName:(NSString *)name
                 explanation:(NSString *)explanation
               startingValue:(CGFloat)value
                 andCategory:(AISimulationCategory)category;

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula;
- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay;
- (void)addStaticInputValue:(CGFloat)staticValue;

@end
