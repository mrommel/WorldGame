//
//  GrandStrategyAI.m
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GrandStrategyAI.h"

#import "Flavor.h"
#import "Yield.h"

@implementation GrandStrategyAI

- (instancetype)initWithGrandStrategyType:(GrandStrategyType)type
{
    self = [super init];
    
    if (self) {
        self.grandStrategyType = type;
        self.flavors = [[NSMutableArray alloc] init];
        self.yields = [[NSMutableArray alloc] init];
        
        switch (type) {
            case GrandStrategyTypeConquest:
                [self.flavors addObject:[[Flavor alloc] initWithFlavorType:FlavorTypeOffense andFlavor:9]];
                [self.yields addObject:[[Yield alloc] initWithYieldType:YieldTypeProduction andYield:200]];
                break;
            case GrandStrategyTypeCulture:
                [self.flavors addObject:[[Flavor alloc] initWithFlavorType:FlavorTypeCulture andFlavor:9]];
                [self.yields addObject:[[Yield alloc] initWithYieldType:YieldTypeGold andYield:50]];
                [self.yields addObject:[[Yield alloc] initWithYieldType:YieldTypeScience andYield:200]];
                break;
        }
    }
    
    return self;
}

@end
