//
//  Relation.h
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Group.h"

@class Simulation;
@class Policy;

/*!
 class that
 */
@interface Relation : NSObject

@property (nonatomic) NSString *formula;
@property (nonatomic) Simulation *simulation;
@property (nonatomic) Policy *policy;
@property (nonatomic) Group *group;
@property (atomic) GroupValue groupValue;

@property (atomic) int delay;

- (instancetype)initWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation;
- (instancetype)initWithFormula:(NSString *)formula toSimulation:(Simulation *)simulation withDelay:(int)delay;
- (instancetype)initWithFormula:(NSString *)formula toPolicy:(Policy *)policy;
- (instancetype)initWithFormula:(NSString *)formula toPolicy:(Policy *)policy withDelay:(int)delay;
- (instancetype)initWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue;
- (instancetype)initWithFormula:(NSString *)formula toGroup:(Group *)group forGroupValue:(GroupValue)groupValue withDelay:(int)delay;

- (float)evaluate;

@end
