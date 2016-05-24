//
//  Continent.h
//  AITest
//
//  Created by Michael Rommel on 16.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Area;

@interface Continent : NSObject<NSCoding>

@property (atomic) NSInteger identifier;
@property (nonatomic, nonnull) NSString *name;

- (nonnull instancetype)initWithIdentifier:(NSInteger)identifier andName:(nonnull NSString *)name;

- (void)setObject:(nonnull id<NSCopying>)object forKey:(nonnull id<NSCopying>)key;
- (void)setInteger:(NSInteger)object forKey:(nonnull id<NSCopying>)key;

- (nonnull id<NSCopying>)objectForKey:(nonnull id<NSCopying>)key;
- (NSInteger)integerForKey:(nonnull id<NSCopying>)key;

@end