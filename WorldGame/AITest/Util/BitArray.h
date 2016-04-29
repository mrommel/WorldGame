//
//  BitArray.h
//  AITest
//
//  Created by Michael Rommel on 09.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BitArray : NSObject

- (instancetype)initWithSize:(NSInteger)size NS_DESIGNATED_INITIALIZER;
- (instancetype)initFromNumber:(NSInteger)number NS_DESIGNATED_INITIALIZER;
- (instancetype)initFrom:(NSInteger) min to:(NSInteger) max; //min inclusive, max exclusive
- (instancetype)init;

- (BOOL)isSetAt:(NSInteger)pos;

- (void)set:(NSInteger)pos;
- (void)setFrom:(NSInteger)from to:(NSInteger)to;  //fromIndex inclusive, toIndex exclusive
- (void)reset;
- (void)reset:(NSInteger)pos;
- (void)resetFrom:(NSInteger)from to:(NSInteger)to; //fromIndex inclusive, toIndex exclusive

- (BOOL)isFull;
- (BOOL)isEmpty;
- (NSInteger)count;
- (NSInteger)toNumber;

- (BOOL)isEqualToBitArray:(BitArray *)another;
- (BOOL)setAs:(BitArray *) another;
- (BitArray*)clone;

- (void)and:(BitArray *) another;
- (void)xor:(BitArray *) another;
- (void)or:(BitArray *) another;
- (void)not;

@end
