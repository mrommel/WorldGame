//
//  HeightMap.m
//  AITest
//
//  Created by Michael Rommel on 22.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "HeightMap.h"

#import "Array2D.h"
//#import "CC3Math.h"

#define SQR(x) ((x)*(x))

@interface HeightMap() {
    
}

@property (nonatomic) Array2D *heights;

@end

@implementation HeightMap

- (id)initWithSize:(CGSize)size
{
    self = [super init];
    
    if (self) {
        self.heights = [[Array2D alloc] initWithSize:size];
        
        for (int x = 0; x < self.heights.size.width; x++) {
            for (int y = 0; y < self.heights.size.height; y++) {
                [self.heights setObject:[[NSNumber alloc] initWithFloat:0.0f] atX:x andY:y];
            }
        }
    }
    
    return self;
}

#define GETVALUE(x,y) ([[self.heights objectAtX:x andY:y] floatValue])
#define SETVALUE(x,y,v) [self.heights setObject:[[NSNumber alloc] initWithFloat:v] atX:x andY:y]

- (void)random
{
    for (int x = 0; x < self.heights.size.width; x++) {
        for (int y = 0; y < self.heights.size.height; y++) {
            SETVALUE(x, y, (((float)rand() / RAND_MAX)));
        }
    }
    
    float sa[64], ca[64], f1[64], f2[64];
    
    double smooth = 0.049;//causes low amplitude of short waves
    double detail = 0.095;//causes short period of short waves
    //int merge = 5;//elevation merging range at the connection line of the round world,in relation to lx}
    
    //int imerge  = ( 2 * self.heights.size.width ) / merge;
    double v;
    
    for(int i=0;i<64;i++)//prepare formula parameters
    {
        if (i==0) v=M_PI/2;
        else v=((double)rand()/(double)rand())*2*M_PI;//first wave goes horizontal
        sa[i]=sin(v)/(double)self.heights.size.width;
        ca[i]=cos(v)/(double)self.heights.size.height;
        f1[i]=2*M_PI*exp(detail*i);
        f2[i]=exp((-(i+1))*smooth);
    }
    
    for(unsigned x=0;x<self.heights.size.width;x++)
    {
        for(unsigned y=0;y<self.heights.size.height;y++)
        {
            v = 0.0;
            
            for(int i=0;i<64;i++)
                v += sin(f1[i]*((x*2 + y%2)*sa[i]+y*1.5*ca[i]))*f2[i];
            
            //if (x*2<imerge) v=(x*2*v+(imerge-x*2)*value(x+dimx,y))/imerge;
            
            v=v-SQR(SQR(2*y/self.heights.size.height-1));//soft cut at poles
            
            if (v<-4) {
                SETVALUE(x, y, 0);
            } else if (v>8.75) {
                SETVALUE(x, y, 255);
            } else {
                SETVALUE(x, y, (v+4.0)*20.0);
            }
        }
    }
}

- (void)smoothen
{
    [self.heights smoothenFloat];
}

- (float)valueAtX:(int)x andY:(int)y
{
    return [[self.heights objectAtX:x andY:y] floatValue];
}

- (int)countTilesForLevel:(float)level
{
    int tiles = 0;
    for (int i = 0; i < self.heights.size.width; ++i) {
        for (int j = 0; j < self.heights.size.height; ++j) {
            if (GETVALUE(i, j) >= level) {
                tiles++;
            }
        }
    }
    
    return tiles;
}

- (float)findLevelWithPercentage:(float)percentage
{
    NSLog(@"findLevelWithPercentage:%f", percentage);
    float tilesCount = self.heights.size.width * self.heights.size.height;
    float min = [self minValue];
    float max = [self maxValue];
    
    float level = (min + max) / 2;
    float tilesPercentage = [self countTilesForLevel:level] / tilesCount;
    float step = level / 2;
    
    for (int i = 0; i < 20; i++) {
        if (tilesPercentage > percentage) {
            level += step;
        } else {
            level -= step;
        }
        
        tilesPercentage = [self countTilesForLevel:level] / tilesCount;
        step /= 2;
        NSLog(@"calculation: index=%d level=%f, percen=%f, step=%f", i, level, tilesPercentage, step);
    }
    
    return level;
}

- (float)minValue
{
    float min = FLT_MAX;
    
    for (int i = 0; i < self.heights.size.width; ++i) {
        for (int j = 0; j < self.heights.size.height; ++j) {
            min = MIN(min, [[self.heights objectAtX:i andY:j] floatValue]);
        }
    }
    
    return min;
}

- (float)maxValue
{
    float max = FLT_MIN;
    
    for (int i = 0; i < self.heights.size.width; ++i) {
        for (int j = 0; j < self.heights.size.height; ++j) {
            max = MAX(max, [[self.heights objectAtX:i andY:j] floatValue]);
        }
    }
    
    return max;
}

@end
