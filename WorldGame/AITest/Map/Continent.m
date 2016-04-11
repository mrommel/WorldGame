//
//  Continent.m
//  AITest
//
//  Created by Michael Rommel on 16.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Continent.h"

static NSString* const ContinentDataIdentifierKey = @"Continent.Identifier";
static NSString* const ContinentDataNameKey = @"Continent.Name";

@implementation Continent

- (instancetype)initWithIdentifier:(int)identifier andName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.identifier = identifier;
        self.name = name;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    
    if (self) {
        self.identifier = [decoder decodeIntegerForKey:ContinentDataIdentifierKey];
        self.name = [decoder decodeObjectForKey:ContinentDataNameKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.identifier forKey:ContinentDataIdentifierKey];
    [encoder encodeObject:self.name forKey:ContinentDataNameKey];
}

@end
