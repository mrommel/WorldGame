//
//  NSDictionary+Extension.h
//  AITest
//
//  Created by Michael Rommel on 20.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Array)

- (NSArray *)arrayForKey:(NSString *)key;
- (NSMutableArray *)mutableArrayForKey:(NSString *)key;

@end

@interface NSDictionary (Path)

- (id)objectForPath:(NSString *)path;
- (NSArray *)arrayForPath:(NSString *)path;
- (NSMutableArray *)mutableArrayForPath:(NSString *)path;

@end