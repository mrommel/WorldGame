//
//  NSDictionary+Extension.m
//  AITest
//
//  Created by Michael Rommel on 20.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Array)

- (NSArray *)arrayForKey:(NSString *)key
{
    NSArray *array = [self objectForKey:key];
    
    if (array == nil) {
        return [NSArray array];
    }
    
    if (![array isKindOfClass:[NSArray class]])
    {
        // if 'array' isn't an array, we create a new array containing our object
        array = [NSArray arrayWithObject:array];
    }
    
    return array;
}

- (NSMutableArray *)mutableArrayForKey:(NSString *)key
{
    NSArray *array = [self arrayForKey:key];
    
    if (array != nil)
        return [array mutableCopy];
    
    return nil;
}

@end

@implementation NSDictionary (Path)

- (id)objectForPath:(NSString *)path
{
    NSMutableArray *keys = [[path componentsSeparatedByString:@"|"] mutableCopy];
    
    if (keys.count > 1) {
        NSString *key = [keys firstObject];
        [keys removeObjectAtIndex:0];
        NSString *remainder = [keys componentsJoinedByString:@"|"];
        NSDictionary *dict = [self objectForKey:key];
        return [dict objectForPath:remainder];
    }
    
    return [self objectForKey:path];
}

- (NSArray *)arrayForPath:(NSString *)path
{
    NSMutableArray *keys = [[path componentsSeparatedByString:@"|"] mutableCopy];
    
    if (keys.count > 1) {
        NSString *key = [keys firstObject];
        [keys removeObjectAtIndex:0];
        NSString *remainder = [keys componentsJoinedByString:@"|"];
        NSDictionary *dict = [self objectForKey:key];
        return [dict arrayForPath:remainder];
    }
    
    return [self arrayForKey:path];
}

- (NSMutableArray *)mutableArrayForPath:(NSString *)path
{
    NSArray *array = [self arrayForPath:path];
    
    if (array != nil)
        return [array mutableCopy];
    
    return nil;
}

@end
