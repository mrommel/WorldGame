//
//  BitArray.m
//  AITest
//
//  Created by Michael Rommel on 09.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "BitArray.h"

@interface BitArray() {
    Byte *_array;  // the bits for the array
    NSInteger   _bsize;  // the size of the byte array
    NSInteger   _size;   // the number of bits of space actually in use
}


@end

@implementation BitArray

- (instancetype)init
{
    self = [self initFromNumber:0];
    return self;
}

- (instancetype)initWithSize:(NSInteger)size
{
    self = [super init];
    _size = size;
    _bsize = (size %8) == 0 ? size/8: size/8+1;
    _array = malloc(_bsize);
    [self reset];
    return self;
}

- (instancetype)initFrom:(NSInteger)min to:(NSInteger)max
{
    if (max<min) {
        NSInteger tmp = min;
        min = max;
        max = tmp;
    }
    self = [self initWithSize:max];
    [self setFrom:min to:max];
    return self;
}

- (instancetype)initFromNumber:(NSInteger)number
{
    self = [super init];
    _bsize = sizeof(NSInteger);
    _size = _bsize * 8;
    _array = malloc(_bsize);
    memcpy(_array, &number, _bsize);
    return self;
}

- (void)dealloc
{
    free(_array);
}

#pragma mark -

- (NSUInteger)hash
{
    NSInteger tmp = [self toNumber];
    if (tmp == -1) {
        //I probably should come up with better number than just -1
        return -1;
    }
    return tmp;
}

- (BOOL)isEqualToBitArray:(BitArray *)another
{
    if (_size != another->_size) return NO;
    NSInteger result = memcmp(_array, another->_array, _bsize);
    return (result == 0);
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[BitArray class]]) {
        return NO;
    }
    
    return [self isEqualToBitArray:(BitArray *)object];
}

- (NSString *)description
{
    NSMutableString *bitString=[NSMutableString stringWithCapacity:8*_bsize];
    for (NSInteger i=_bsize-1; i >=0; i--) {
        Byte dest = _array[i];
        NSMutableString *byteString = [NSMutableString stringWithCapacity:8];
        for (NSInteger j=7;j >=0;j--) {
            NSInteger bit = dest & (1 << j) ? 1 : 0;
            [byteString appendFormat:@"%zd",bit];
        }
        [bitString appendFormat:@"%@ ",byteString];
    }
    return bitString;
}

#pragma mark -

- (BOOL)setAs:(BitArray *)another
{
    if (_size != another->_size) {
        return NO;
    }
    memcpy(self->_array, another->_array, another->_bsize);
    return YES;
}

- (BitArray*)clone
{
    BitArray * another = [[BitArray alloc] initWithSize:self->_size];
    [another setAs:self];
    return another;
}

#pragma mark -

- (BOOL)isSetAt:(NSInteger)pos
{
    if (pos >= _size) return NO;
    NSInteger index = pos/8;
    NSInteger bit = pos%8;
    return (_array[index] & (1 << bit)) > 0;
}

- (void)set:(NSInteger) pos
{
    if (pos >= _size) return;
    NSInteger index = pos/8;
    NSInteger bit = pos%8;
    _array[index] = _array[index] | (1 << bit);
}

//fromIndex inclusive, toIndex exclusive
- (void)setFrom:(NSInteger) from to:(NSInteger) to
{
    if (from>to) return;
    if (from <0) from =0;
    if (to > _size) to = _size;
    
    while (from < to)
    {
        _array[from / 8] |= (1 << (from % 8));
        from++;
    }
}

- (void)reset
{
    memset(_array, 0, _bsize);
}

- (void)reset:(NSInteger)pos
{
    if (pos >= _size) return;
    NSInteger index = pos/8;
    NSInteger bit = pos%8;
    _array[index] = _array[index] & (~(1 << bit));
}

//fromIndex inclusive, toIndex exclusive
- (void)resetFrom:(NSInteger) from to:(NSInteger) to
{
    if (from>to) return;
    if (from <0) from =0;
    if (to > _size) to = _size;
    
    while (from < to)
    {
        _array[from / 8] &= ~(1 << (from % 8));
        from++;
    }
}

#pragma mark -

- (NSInteger)count
{
    NSInteger count = 0, index = 0;
    while (index < _size) { //can NOT be <= as the first bit will be sign bit!!
        if (_array[index / 8] & (1 << (index % 8))) {
            count++;
        }
        index++;
    }
    return count;
}

- (BOOL)isFull
{
    NSInteger bound = (_size%8==0) ? _bsize : _bsize -1;
    for (NSInteger i=0; i<bound; i++) {
        if (_array[i] != 255) return NO;
    }
    if (_size%8==0) return YES;
    NSInteger j = _size -bound * 8;
    return _array[bound] == (1<<j)-1;
}

- (BOOL)isEmpty
{
    for (NSInteger i=0; i<_bsize; i++) {
        if (_array[i]!=0) return NO;
    }
    return YES;
}

- (NSInteger)toNumber
{
    NSInteger number = 0;
    NSInteger long_size = sizeof(NSInteger);
    if (_bsize >long_size) {
        return -1;
    }
    memcpy(&number, _array, _bsize);
    return number;
}

#pragma mark -

- (void)and:(BitArray *)another
{
    if (_size != another->_size) return;
    for (int i=0; i<_bsize; i++) {
        _array[i] &= another->_array[i];
    }
}

- (void)or:(BitArray *)another
{
    if (_size != another->_size) return;
    for (int i=0; i<_bsize; i++) {
        _array[i] |= another->_array[i];
    }
}

- (void)xor:(BitArray *)another
{
    if (_size != another->_size) return;
    for (int i=0; i<_bsize; i++) {
        _array[i] ^= another->_array[i];
    }
}

- (void)not
{
    for (int i=0; i<_bsize; i++) {
        _array[i] = ~_array[i];
    }
}

@end
