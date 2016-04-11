//
//  HeightMap.h
//  AITest
//
//  Created by Michael Rommel on 22.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>

/**
 
 HeightMap h = new HeightMap(512);
 h.AddPerlinNoise(6.0f);
 h.Perturb(32.0f, 32.0f);
 for (int i = 0; i < 10; i++ )
 h.Erode(16.0f);
 h.Smoothen();
 
 */
@interface HeightMap : NSObject

- (id)initWithSize:(CGSize)size;

- (void)random;
- (void)smoothen;

- (float)valueAtX:(NSInteger)x andY:(NSInteger)y;

- (float)minValue;
- (float)maxValue;

- (float)findLevelWithPercentage:(float)percentage;

@end
