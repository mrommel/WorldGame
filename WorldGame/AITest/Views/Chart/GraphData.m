//
//  GraphData.m
//  WorldGame
//
//  Created by Michael Rommel on 22.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphData.h"

#import "GraphDataEntry.h"

@implementation GraphData

- (instancetype)initWithLabel:(NSString *)label
{
    self = [super init];
    
    if (self) {
        self.label = label;
        self.values = [[NSMutableArray alloc] init];
        self.keys = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addKey:(NSString *)key atIndex:(NSInteger)index
{
    [self.keys insertObject:key atIndex:index];
}

- (void)addValue:(NSNumber *)value atIndex:(NSInteger)index
{
    [self.values insertObject:[[GraphDataEntry alloc] initWithValue:value atIndex:index] atIndex:index];
}

- (void)addValue:(NSNumber *)value forKey:(NSString *)key
{
    NSInteger index = [self.keys indexOfObject:key];
    [self.values insertObject:[[GraphDataEntry alloc] initWithValue:value atIndex:index] atIndex:index];
}

@end
