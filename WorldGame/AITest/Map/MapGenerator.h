//
//  MapGenerator.h
//  AITest
//
//  Created by Michael Rommel on 15.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Map.h"

/*!
 
 */
@interface MapGenerator : NSObject

@property (nonatomic) Map* map;

- (instancetype)initWithMap:(Map *)map;

- (void)generateWithProgress:(MapGenerateProgress)progress;
- (void)fillWithTerrain:(MapTerrain)terrain;
- (void)addTerrainRectWithX:(int)x andY:(int)y andWidth:(int)width andHeight:(int)height andFillItWithTerrain:(MapTerrain)terrain;
- (void)identifyContinents;

@end

/*!
 
 */
@interface BipolarMapGenerator : MapGenerator

@end

/*!
 
 */
@interface OptionsMapGenerator : MapGenerator

- (instancetype)initWithMap:(Map *)map andOptions:(MapOptions *)options;

@end