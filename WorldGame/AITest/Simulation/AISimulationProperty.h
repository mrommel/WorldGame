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
    AISimulationCategoryEconomy,
    AISimulationCategoryWelfare,
    AISimulationCategoryStatic,
    AISimulationCategoryForeign,
    AISimulationCategoryLawOrder,
    AISimulationCategoryPublicServices,
    
    AISimulationCategoryVoter
};

@interface AISimulationProperty : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* explanation;
@property (atomic) AISimulationCategory category;

- (instancetype)initWithName:(NSString *)name
                 explanation:(NSString *)explanation
               startingValue:(CGFloat)value
                 andCategory:(AISimulationCategory)category;

- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula;
- (void)addInputProperty:(AISimulationProperty *)property withFormula:(NSString *)formula andDelay:(NSInteger)delay;
- (void)addStaticInputValue:(CGFloat)staticValue;

- (void)calculate;

- (void)setValue:(CGFloat)value;
- (CGFloat)valueWithoutDelay;
- (CGFloat)valueWithDelay:(NSInteger)delay;

- (NSArray *)listOfInputs;
- (NSArray *)listOfOutputs;

@end
