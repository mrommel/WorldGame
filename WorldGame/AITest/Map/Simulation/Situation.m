//
//  Situation.m
//  AITest
//
//  Created by Michael Rommel on 08.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Situation.h"

@implementation Situation

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.name = name;
    }
    
    return self;
}

@end
