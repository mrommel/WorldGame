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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface Array2D : NSObject

@property(atomic) CGSize size;

+ (id)arrayWithSize:(CGSize)aSize;

- (id)initWithSize:(CGSize)aSize;

- (id)objectAtX:(NSInteger)x andY:(NSInteger)y;
- (id)objectAt:(CGPoint)pos;

- (void)setObject:(id)object atX:(NSInteger)x andY:(NSInteger)y;
- (void)setObject:(id)object at:(CGPoint)pos;

#pragma mark -
#pragma mark float functions

- (void)smoothenFloat;
- (void)fillWithFloat:(float)value;
- (float)floatAtX:(NSInteger)x andY:(NSInteger)y;
- (void)setFloat:(float)value atX:(NSInteger)x andY:(NSInteger)y;

#pragma mark -
#pragma mark float functions

- (void)smoothenInt;
- (void)fillWithInt:(int)value;
- (int)intAtX:(NSInteger)x andY:(NSInteger)y;
- (void)setInt:(int)value atX:(NSInteger)x andY:(NSInteger)y;
- (void)replaceAllInt:(int)a withInt:(int)b;
- (int)maximumIntOnHexAtX:(NSInteger)x andY:(NSInteger)y withDefault:(int)def;

@end
