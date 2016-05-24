//
//  Continent.m
//  AITest
//
//  Created by Michael Rommel on 16.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Continent.h"

#import "Area.h"

static NSString* const ContinentDataIdentifierKey = @"Continent.Identifier";
static NSString* const ContinentDataNameKey = @"Continent.Name";

@interface Continent()

@property (nonatomic) NSMutableDictionary *dict;

@end

@implementation Continent

- (instancetype)initWithIdentifier:(NSInteger)identifier andName:(nonnull NSString *)name
{
    self = [super init];
    
    if (self) {
        self.identifier = identifier;
        self.name = name;
        
        self.dict = [NSMutableDictionary new];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    
    if (self) {
        self.identifier = [decoder decodeIntegerForKey:ContinentDataIdentifierKey];
        self.name = [decoder decodeObjectForKey:ContinentDataNameKey];
        
        self.dict = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.identifier forKey:ContinentDataIdentifierKey];
    [encoder encodeObject:self.name forKey:ContinentDataNameKey];
}

#pragma mark -
#pragma mark key value store handling

- (void)setObject:(nonnull id<NSCopying>)object forKey:(nonnull id<NSCopying>)key
{
    [self.dict setObject:object forKey:key];
}

- (void)setInteger:(NSInteger)object forKey:(nonnull id<NSCopying>)key
{
    [self setObject:[NSNumber numberWithInteger:object] forKey:key];
}

- (nonnull id<NSCopying>)objectForKey:(nonnull id<NSCopying>)key
{
    return [self.dict objectForKey:key];
}

- (NSInteger)integerForKey:(nonnull id<NSCopying>)key
{
    return [((NSNumber *)[self objectForKey:key]) integerValue];
}

@end
