//
//  Simulation.h
//  AITest
//
//  Created by Michael Rommel on 26.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Group.h"

@class Simulation;
@class Policy;

/*!
 class that
 */
@interface Simulation : NSObject

@property (nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name andDefaultValue:(float)value;

- (void)addRelationWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation;
- (void)addRelationWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation withDelay:(int)delay;
- (void)addRelationWithFormula:(NSString *)formula toPolicy:(Policy *)policy;
- (void)addRelationWithFormula:(NSString *)formula toPolicy:(Policy *)policy withDelay:(int)delay;
- (void)addRelationWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue;
- (void)addRelationWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue withDelay:(int)delay;

- (float)valueWithDelay:(int)delay;

// calc cycle
- (void)turn;
- (void)stack;

/*- (void)initCycle;
- (void)addValue:(float)value;
- (void)updateCycleWithFactor:(float)factor;*/

@end

