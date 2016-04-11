/*
 * Array2D, simple NSMutableArray like collection but two dimensional
 * Objects at positions are mutable, size is immutable.
 *
 * Copyright (c) 2010 <mattias.wadman@gmail.com>
 *
 * MIT License:
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "Array2D.h"

#import <UIKit/UIKit.h>
#import "MapPoint.h"

@interface Array2D ()

@property (nonatomic) NSMutableDictionary *objects;

@end


@implementation Array2D

+ (id)arrayWithSize:(CGSize)aSize
{
    return [[Array2D alloc] initWithSize:aSize];
}

- (id)initWithSize:(CGSize)aSize
{
    self = [super init];
    if (self) {
        self.size = aSize;
        self.objects = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (BOOL)insideX:(NSInteger)x andY:(NSInteger)y
{
    return x >= 0 && x < (int)self.size.width && y >= 0 && y < (int)self.size.height;
}

- (void)insideOrException:(NSInteger)x y:(NSInteger)y
{
    if (![self insideX:x andY:y]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"(%ld,%ld) is outside array with size (%dx%d)", (long)x, (long)y, (int)self.size.width, (int)self.size.height];
    }
}

- (id)objectAtX:(NSInteger)x andY:(NSInteger)y
{
    [self insideOrException:x y:y];
    return [self.objects valueForKey:[NSString stringWithFormat:@"%ld,%ld", (long)x, (long)y]];
}

- (id)objectAt:(CGPoint)pos
{
    return [self objectAtX:pos.x andY:pos.y];
}

- (void)setObject:(id)object atX:(NSInteger)x andY:(NSInteger)y
{
    [self insideOrException:x y:y];
    [self.objects setObject:object forKey:[NSString stringWithFormat:@"%ld,%ld", (long)x, (long)y]];
}

- (void)setObject:(id)object at:(CGPoint)pos
{
    [self setObject:object atX:(NSInteger)pos.x andY:(NSInteger)pos.y];
}

#pragma mark -
#pragma mark float functions

- (void)smoothenFloat
{
    for (int i = 1; i < self.size.width - 1; ++i) {
        for (int j = 1; j < self.size.height - 1; ++j) {
            float total = 0.0f;
            for (int u = -1; u <= 1; u++) {
                for (int v = -1; v <= 1; v++) {
                    total += [[self objectAtX:i + u andY:j + v] floatValue];
                }
            }
            
            [self setObject:[[NSNumber alloc] initWithFloat:total / 9.0f] atX:i andY:j];
        }
    }
}

- (void)fillWithFloat:(float)value
{
    for (int i = 0; i < self.size.width; ++i) {
        for (int j = 0; j < self.size.height; ++j) {
            [self setObject:[[NSNumber alloc] initWithFloat:value] atX:i andY:j];
        }
    }
}

- (float)floatAtX:(NSInteger)x andY:(NSInteger)y
{
    return [[self objectAtX:x andY:y] floatValue];
}

- (void)setFloat:(float)object atX:(NSInteger)x andY:(NSInteger)y
{
    [self setObject:[[NSNumber alloc] initWithFloat:object] atX:x andY:y];
}

#pragma mark -
#pragma mark int functions

- (void)smoothenInt
{
    for (int i = 1; i < self.size.width - 1; ++i) {
        for (int j = 1; j < self.size.height - 1; ++j) {
            float total = 0.0f;
            for (int u = -1; u <= 1; u++) {
                for (int v = -1; v <= 1; v++) {
                    total += [[self objectAtX:i + u andY:j + v] floatValue];
                }
            }
            
            [self setObject:[[NSNumber alloc] initWithFloat:total / 9.0f] atX:i andY:j];
        }
    }
}

- (void)fillWithInt:(int)value
{
    for (int i = 0; i < self.size.width; ++i) {
        for (int j = 0; j < self.size.height; ++j) {
            [self setObject:[[NSNumber alloc] initWithInt:value] atX:i andY:j];
        }
    }
}

- (int)intAtX:(NSInteger)x andY:(NSInteger)y
{
    return [[self objectAtX:x andY:y] intValue];
}

- (void)setInt:(int)value atX:(NSInteger)x andY:(NSInteger)y
{
    [self setObject:[[NSNumber alloc] initWithInt:value] atX:x andY:y];
}

- (void)replaceAllInt:(int)a withInt:(int)b
{
    for (int i = 0; i < self.size.width; ++i) {
        for (int j = 0; j < self.size.height; ++j) {
            if ([self intAtX:i andY:j] == a) {
                [self setInt:b atX:i andY:j];
            }
        }
    }
}

- (int)maximumIntOnHexAtX:(NSInteger)x andY:(NSInteger)y withDefault:(int)def
{
    int maximum = def;
    
    MapPoint *point = [[MapPoint alloc] initWithX:x andY:y];
    
    for (id obj in HEXDIRECTIONS) {
        HexDirection dir = [obj intValue];
        MapPoint *neighbor = [point neighborInDirection:dir];
        if ([self insideX:neighbor.x andY:neighbor.y]) {
            float current = [self floatAtX:neighbor.x andY:neighbor.y];
            maximum = MAX(maximum, current);
        }
    }
    
    return maximum;
}

@end