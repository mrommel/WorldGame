//
//  KeyValueMap.m
//  WorldGame
//
//  Created by Michael Rommel on 19.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "KeyValueMap.h"

@interface KeyValueMap()

@property (nonatomic) NSMutableDictionary *map;

@end

@implementation KeyValueMap

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.map = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)addValue:(CGFloat)value forKey:(NSString *)key
{
    [self.map setObject:[NSNumber numberWithFloat:value] forKey:key];
}

- (NSString *)keyOfHeightestValue
{
    NSString *highestKey = @"";
    CGFloat highestValue = CGFLOAT_MIN;
    
    for (NSString *key in self.map.allKeys) {
        CGFloat currentValue = [[self.map valueForKey:key] floatValue];
        
        if (highestValue < currentValue) {
            highestValue = currentValue;
            highestKey = key;
        }
    }
    
    return highestKey;
}

@end
