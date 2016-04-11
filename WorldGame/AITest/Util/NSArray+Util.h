//
//  NSArray+Util.h
//  AITest
//
//  Created by Michael Rommel on 16.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Util)

- (BOOL)boolValueAtIndex:(int)index;

@end

@interface NSMutableArray (Util)

- (void)replaceObjectAtIndex:(int)index withInt:(int)value;
- (void)replaceObjectAtIndex:(int)index withBool:(BOOL)value;

- (void)addInteger:(NSInteger)value;
- (NSInteger)integerAtIndex:(NSInteger)index;

@end