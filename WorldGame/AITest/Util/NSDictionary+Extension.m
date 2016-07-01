//
//  NSDictionary+Extension.m
//  AITest
//
//  Created by Michael Rommel on 20.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "NSDictionary+Extension.h"

#import "NSString+Custom.h"

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

- (id)valueForKeyContaining:(NSString *)partialKey
{
    if(!partialKey){
        return nil;
    }
    
    if([partialKey isEqualToString:@""]){
        return nil;
    }
    
    for (NSString* key in self) {
        NSRange range = [key rangeOfString:partialKey];
        if (range.location != NSNotFound) {
            return [self valueForKey: key];
        }
    }
    
    return nil;
}

- (id)objectForKeyContaining:(NSString *)partialKey
{
    if (!partialKey) {
        return nil;
    }
    
    if ([partialKey isEqualToString:@""]) {
        return nil;
    }
    
    for (NSString* key in self) {
        NSRange range = [key rangeOfString:partialKey];
        if (range.location != NSNotFound){
            return [self objectForKey:key];
        }
    }
    
    return nil;
}

- (id)getValueForKeyPath:(NSString *)path
{
    return [self getValueForKeyPath:path withDefaultValue:nil];
}

- (id)getValueForKeyPath:(NSString *)path withDefaultValue:(id)defaultValue
{
    if (!path) {
        return defaultValue;
    }
    
    if ([path isEqualToString:@""]) {
        return defaultValue;
    }
    
    if ([self objectForKeyContaining: path]) {
        
        id val = [self valueForKeyContaining:path];
        
        // return the value
        if([val isKindOfClass: [NSDictionary class]]) {
            return [val valueForKey: @"text"];
        }
        
        if([val isKindOfClass: [NSString class]]) {
            return val;
        }
    }
    
    NSDictionary *tmp = self;
    
    for (NSString *key in [path componentsSeparatedByString:@"/"]) {
        // check if current key is the last
        if ([path hasSuffix: [NSString stringWithFormat:@"/%@", key]]) {
            
            id val = [tmp valueForKeyContaining: key];
            
            // return the value
            if ([val isKindOfClass:[NSDictionary class]]) {
                return [val valueForKey: @"text"];
            }
            
            if ([val isKindOfClass:[NSString class]]) {
                return val;
            }
            
            if ([val isKindOfClass:[NSArray class]]) {
                return val;
            }
            
            //NSLog(@"Unknown type: %@", [val class]);
            return val;
        } else {
            // go deep into dict
            tmp = [tmp objectForKeyContaining: key];
        }
    }
    
    return defaultValue;
}

- (NSArray*)getArrayForKeyPath:(NSString *)path
{
    return [self getValueForKeyPath: path withDefaultValue: nil];
}

-(int)getIntValueForKeyPath:(NSString *)path withDefaultValue: (int)defaultValue
{
    NSString *val = [self getValueForKeyPath: path withDefaultValue: [NSString stringWithFormat: @"%d", defaultValue]];
    
    if(val == nil)
        return defaultValue;
    
    return [val intValue];
}

-(id)getObjectForKeyPath:(NSString *)path withDefaultValue:(id)defaultValue
{
    if (!path) {
        return defaultValue;
    }
    
    if ([path isEqualToString:@""]) {
        return defaultValue;
    }
    
    if ([self objectForKeyContaining:path]) {
        
        id val = [self valueForKeyContaining: path];
        
        return val;
    }
    
    NSDictionary *tmp = self;
    
    for (NSString *key in [path componentsSeparatedByString: @"/"]) {
        
        // check the key exists
        /*if(![tmp containsKey: key])
         return defaultValue;*/
        
        // check if current key is the last
        if ([path hasSuffix: [NSString stringWithFormat: @"/%@", key]]) {
            
            id val = [tmp valueForKeyContaining: key];
            
            // return the value
            return val;
        } else {
            // go deep into dict
            tmp = [tmp objectForKeyContaining: key];
        }
    }
    
    return defaultValue;
}

// experimental
-(void)setTheValue: (id)obj forKeyPath: (NSString*)path {
    
    if(![path contains: @"/"]) {
        [self setValue: obj forKey: path];
        return;
    }
    
    NSMutableDictionary *tmp = (NSMutableDictionary*)self;
    NSArray *keys = [path componentsSeparatedByString: @"/"];
    for(int i = 0; i < [keys count]; ++i) {
        
        NSString *key = [[keys objectAtIndex: i] copy];
        
        NSLog(@"add key: %@", key);
        
        // last entry
        if(i == [keys count] - 1) {
            // store it
            [tmp setObject: obj forKey: key];
        } else {
            if([tmp containsKey: key]) {
                tmp = [tmp objectForKeyContaining: key];
                
                if(![tmp isKindOfClass: [NSDictionary class]]) {
                    /*id v = [tmp copy];
                     
                     NSDictionary *dict = [[NSDictionary alloc] init];
                     
                     [tmp setValue: v forKey: key];*/
                    NSLog(@"something bad happend");
                }
            } else {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
                [tmp setObject: dict forKey: key];
                tmp = [tmp objectForKeyContaining: key];
            }
        }
        
        //NSLog(@"dict: %@", [self description]);
    }
}

-(BOOL)containsKey: (NSString*)key {
    return [self objectForKey: key] != nil;
}

- (NSDictionary *)dictForKey:(NSString *)key
{
    return [self objectForKey:key];
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self objectForKey:key];
}

- (int)intForKey:(NSString *)key
{
    return [[self objectForKey:key] intValue];
}

- (int)intForKey:(NSString *)key withDefault:(int)value
{
    id node = [self objectForKey:key];
    return node != nil ? [node intValue] : value;
}

- (float)floatForKey:(NSString *)key
{
    return [[self objectForKey:key] floatValue];
}

- (float)floatForKey:(NSString *)key withDefault:(float)value
{
    id node = [self objectForKey:key];
    return node != nil ? [node floatValue] : value;
}

- (CC3Vector)vector3ForKey:(NSString *)key
{
    NSString *src = [self stringForKey:key];
    NSArray *vectorComponents = [src componentsSeparatedByString:@","];
    return CC3VectorMake([[vectorComponents objectAtIndex:0] floatValue], [[vectorComponents objectAtIndex:1] floatValue], [[vectorComponents objectAtIndex:2] floatValue]);
}

- (CC3Vector)vector3ForKey:(NSString *)key withDefault:(CC3Vector)value
{
    NSString *src = [self stringForKey:key];
    if (src == nil) {
        return value;
    }
    NSArray *vectorComponents = [src componentsSeparatedByString:@","];
    return CC3VectorMake([[vectorComponents objectAtIndex:0] floatValue], [[vectorComponents objectAtIndex:1] floatValue], [[vectorComponents objectAtIndex:2] floatValue]);
}

- (CC3Vector4)vector4ForKey:(NSString *)key
{
    NSString *src = [self stringForKey:key];
    NSArray *vectorComponents = [src componentsSeparatedByString:@","];
    return CC3Vector4Make([[vectorComponents objectAtIndex:0] floatValue], [[vectorComponents objectAtIndex:1] floatValue], [[vectorComponents objectAtIndex:2] floatValue], [[vectorComponents objectAtIndex:3] floatValue]);
}

- (CC3Vector4)vector4ForKey:(NSString *)key withDefault:(CC3Vector4)value
{
    NSString *src = [self stringForKey:key];
    if (src == nil) {
        return value;
    }
    NSArray *vectorComponents = [src componentsSeparatedByString:@","];
    return CC3Vector4Make([[vectorComponents objectAtIndex:0] floatValue], [[vectorComponents objectAtIndex:1] floatValue], [[vectorComponents objectAtIndex:2] floatValue], [[vectorComponents objectAtIndex:3] floatValue]);
}

- (CC3Vector2)vector2ForKey:(NSString *)key
{
    NSString *src = [self stringForKey:key];
    NSArray *vectorComponents = [src componentsSeparatedByString:@","];
    return CC3Vector2Make([[vectorComponents objectAtIndex:0] floatValue], [[vectorComponents objectAtIndex:1] floatValue]);
}

- (CC3Vector2)vector2ForKey:(NSString *)key withDefault:(CC3Vector2)value
{
    NSString *src = [self stringForKey:key];
    if (src == nil) {
        return value;
    }
    NSArray *vectorComponents = [src componentsSeparatedByString:@","];
    return CC3Vector2Make([[vectorComponents objectAtIndex:0] floatValue], [[vectorComponents objectAtIndex:1] floatValue]);
}

@end
