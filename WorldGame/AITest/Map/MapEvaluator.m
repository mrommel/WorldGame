//
//  MapEvaluator.m
//  AITest
//
//  Created by Michael Rommel on 08.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MapEvaluator.h"

#import "Plot.h"
#import "Map.h"
#import "Continent.h"
#import "Area.h"

//const static NSString *kFoodProduction = @"FOOD_PRODUCTION";
const static NSString *kNumberOfTiles = @"NUMBER_TILES";

@implementation SiteEvaluator

- (instancetype)init
{
    self = [super init];
    
    return self;
}

/// Retrieve the relative fertility of this plot (alone)
- (NSInteger)plotFertilityValueForPlot:(Plot *)plot
{
    NSInteger rtnValue = 0;
    
    if (![plot isOcean]) {
        rtnValue += [self computeFoodValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeProductionValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeGoldValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeScienceValueForPlot:plot andPlayer:nil];
        //rtnValue += [self computeTradeableResourceValueForPlot:plot andPlayer:nil];
    }
    
    if (rtnValue < 0) {
        rtnValue = 0;
    }
    
    return rtnValue;
}

- (NSInteger)computeFoodValueForPlot:(Plot *)plot andPlayer:(Player *)player
{
    NSInteger rtnValue = 0;
    
    // From tile yield
    rtnValue += [plot calculateNatureYield:YieldTypeFood forPlayer:player];
    
    // From resource
    /*ResourceTypes eResource = [plot resourceTypeForPlayer:player];
    
    if (eResource != NO_RESOURCE)
    {
        rtnValue += GC.getResourceInfo(eResource)->getYieldChange(YIELD_FOOD);
        
        CvImprovementEntry *pImprovement = GC.GetGameImprovements()->GetImprovementForResource(eResource);
        if (pImprovement)
        {
            rtnValue += pImprovement->GetImprovementResourceYield(eResource, YIELD_FOOD);
        }
    }*/
    
    return rtnValue; // * m_iFlavorMultiplier[YIELD_FOOD];
}

@end

/*!
 
 */
@implementation SiteEvaluatorForStart

- (instancetype)init
{
    self = [super init];
    
    return self;
}

@end

/*!
 
 */
@interface StartPositioner()

@property (nonatomic) SiteEvaluatorForStart *siteEvaluator;
@property (nonatomic) Map *map;

@end

@implementation StartPositioner

- (instancetype)initWithMap:(Map *)map andSiteEvaluator:(SiteEvaluatorForStart *)siteEvaluator
{
    self = [super init];
    
    if (self) {
        self.siteEvaluator = siteEvaluator;
        self.map = map;
    }
    
    return self;
}

// answer the powerset of array: an array of all possible subarrays of the passed array
- (NSArray *)powerSet:(NSArray *)array
{
    NSInteger length = array.count;
    if (length == 0) return [NSArray arrayWithObject:[NSArray array]];
    
    // get an object from the array and the array without that object
    id lastObject = [array lastObject];
    NSArray *arrayLessOne = [array subarrayWithRange:NSMakeRange(0,length-1)];
    
    // compute the powerset of the array without that object
    // recursion makes me happy
    NSArray *powerSetLessOne = [self powerSet:arrayLessOne];
    
    // powerset is the union of the powerSetLessOne and powerSetLessOne where
    // each element is unioned with the removed element
    NSMutableArray *powerset = [NSMutableArray arrayWithArray:powerSetLessOne];
    
    // add the removed object to every element of the recursive power set
    for (NSArray *lessOneElement in powerSetLessOne) {
        [powerset addObject:[lessOneElement arrayByAddingObject:lastObject]];
    }
    return [NSArray arrayWithArray:powerset];
}

- (CGFloat)distanceOfArea:(Area *)area toSet:(NSArray *)set
{
    CGFloat distance = 0L;
    
    for (Area *area1 in set) {
        distance += [area1 distanceTo:area];
    }
    
    return distance;
}

- (NSArray *)findStartPositionsForPlayers:(NSInteger)numberOfPlayers
{
    NSMutableArray *startPositions = [NSMutableArray new];
    
    // init continent values
    for (Continent *continent in self.map.continents) {
        //[continent setInteger:0 forKey:kFoodProduction];
        [continent setInteger:0 forKey:kNumberOfTiles];
    }
    
    // iterate plots and update continents
    for (int x = 0; x < self.map.width; x++) {
        for (int y = 0; y < self.map.height; y++) {
            Plot *plot = [self.map tileAtX:x andY:y];
            Continent *continent = plot.continent;
            
            if (continent != nil) {
                /*NSInteger foodValue = [self.siteEvaluator computeFoodValueForPlot:plot andPlayer:nil];
                NSInteger oldFoodValue = [continent integerForKey:kFoodProduction];
                [continent setInteger:(oldFoodValue + foodValue) forKey:kFoodProduction];*/
                
                NSInteger numberOfTiles = [continent integerForKey:kNumberOfTiles];
                [continent setInteger:(numberOfTiles + 1) forKey:kNumberOfTiles];
            }
        }
    }
    
    // cut the continent with highest food value until we have some areas
    NSMutableArray *areas = [NSMutableArray new];
    
    // interate continents and put initial areas
    for (Continent *continent in self.map.continents) {
        if ([continent integerForKey:kNumberOfTiles] > 8) {
            [areas addObject:[self.map areaFromContinentByIdentifier:continent.identifier]];
        }
    }
    
    NSInteger numberOfAreas = [areas count];
    while (numberOfAreas < numberOfPlayers + 4) {
        // sort the array
        [areas sortUsingComparator:^(id obj1, id obj2) {
            Area *area1 = (Area *)obj1;
            Area *area2 = (Area *)obj2;
            
            if ([area1 size] < [area2 size]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([area1 size] > [area2 size]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        // split the biggest area
        Area *biggestArea = [areas lastObject];
        [areas removeLastObject];
        
        NSLog(@"areas: %@", areas);
        NSLog(@"biggest: %@", biggestArea);
        
        // and add the new parts
        [biggestArea divideIntoTwoAreas:^(Area *first, Area *second) {
            [areas addObject:first];
            [areas addObject:second];
        } andSplitByPercent:50];
        
        // update exit criteria
        numberOfAreas = [areas count];
    }
    
    NSAssert([areas count] > numberOfPlayers, @"We need more areas than possible starting plots, otherwise we are lost here!");
    
    // create power sets (with N = number of players) with areas to get the largest distanced set
    NSArray *bestSet = nil;
    NSInteger maxDistance = NSIntegerMin;
    for (NSArray *set in [self powerSet:areas]) {
        if ([set count] == numberOfPlayers) {
            NSInteger distance = 0L;
            
            //
            for (Area *area in set) {
                distance += [self distanceOfArea:area toSet:set];
            }
            
            if (distance > maxDistance) {
                maxDistance = distance;
                bestSet = set;
            }
        }
    }
    
    // we have the best set, now we find the best plot in each of them and use this as starting position
    for (Area *area in bestSet) {
        
        Plot *bestPlot = [area maximumTileFromEvaluator:^(Plot *plot) {
            return [self.siteEvaluator computeFoodValueForPlot:plot andPlayer:nil];
        }];
        
        [startPositions addObject:[NSValue valueWithCGPoint:CGPointMake(bestPlot.coordinate.x, bestPlot.coordinate.y)]];
    }
    
    return startPositions;
}

@end
