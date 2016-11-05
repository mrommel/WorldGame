//
//  AISimulationProperty.h
//  WorldGame
//
//  Created by Michael Rommel on 02.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AISimulationCategory)
{
    AISimulationCategoryProduction,
    AISimulationCategoryPeople,
    AISimulationCategoryStatic
};

@interface AISimulationProperty : NSObject

@property (nonatomic) NSString* name;
@property (atomic) AISimulationCategory category;

- (instancetype)initWithName:(NSString *)name startingValue:(CGFloat)value andCategory:(AISimulationCategory)category;

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula;
- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay;
- (void)addStaticInputValue:(CGFloat)staticValue;

- (void)calculate;

- (CGFloat)valueWithoutDelay;
- (CGFloat)valueWithDelay:(NSInteger)delay;

- (NSArray *)listOfInputs;
- (NSArray *)listOfOutputs;

@end
