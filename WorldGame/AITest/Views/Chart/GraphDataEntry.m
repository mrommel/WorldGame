//
//  GraphDataEntry.m
//  WorldGame
//
//  Created by Michael Rommel on 22.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphDataEntry.h"

@implementation GraphDataEntry

- (instancetype)initWithValue:(NSNumber *)value atIndex:(NSInteger)index
{
    self = [super init];
    
    if (self) {
        self.value = value;
        self.index = index;
    }
    
    return self;
}

@end
