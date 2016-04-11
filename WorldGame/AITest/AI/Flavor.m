//
//  Flavor.m
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Flavor.h"

@implementation Flavor

- (instancetype)initWithFlavorType:(FlavorType) flavorType andFlavor:(int)flavor
{
    self = [super init];
    
    if (self) {
        self.flavorType = flavorType;
        self.flavor = flavor;
    }
    
    return self;
}

@end