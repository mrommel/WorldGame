//
//  NSArray+Util.m
//  AITest
//
//  Created by Michael Rommel on 16.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

- (BOOL)boolValueAtIndex:(int)index
{
    return [[self objectAtIndex:index] boolValue];
}

@end

@implementation NSMutableArray (Util)

- (void)replaceObjectAtIndex:(int)index withInt:(int)value
{
    [self replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
}

- (void)replaceObjectAtIndex:(int)index withBool:(BOOL)value
{
    [self replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:value]];
}

- (void)addInteger:(NSInteger)value
{
    [self addObject:[NSNumber numberWithInteger:value]];
}

- (NSInteger)integerAtIndex:(NSInteger)index
{
    return [[self objectAtIndex:index] integerValue];
}

@end
