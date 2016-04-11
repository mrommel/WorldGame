//
//  Leader.m
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Leader.h"

@implementation Leader

- (instancetype)initWithName:(NSString *)name andCivilizationName:(NSString *)civilizationName
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.civilizationName = civilizationName;
        self.flavors = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addFlavorWithType:(FlavorType)flavorType andValue:(int)flavorValue
{
    [self.flavors addObject:[[Flavor alloc] initWithFlavorType:flavorType andFlavor:flavorValue]];
}

@end


@interface LeaderProvider()

@property (nonatomic) NSMutableArray *leaders;

@end

@implementation LeaderProvider

static LeaderProvider *shared = nil;

+ (LeaderProvider *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[LeaderProvider alloc] init];
        }
    }
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.leaders = [[NSMutableArray alloc] init];
        
        // fill with data
        Leader *leaderBismarck = [[Leader alloc] initWithName:@"Bismarck" andCivilizationName:@"German"];
        [leaderBismarck addFlavorWithType:FlavorTypeOffense andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeDefense andValue:6];
        [leaderBismarck addFlavorWithType:FlavorTypeCityDefense andValue:6];
        [leaderBismarck addFlavorWithType:FlavorTypeMilitaryTraining andValue:8];
        [leaderBismarck addFlavorWithType:FlavorTypeRecon andValue:8];
        [leaderBismarck addFlavorWithType:FlavorTypeRanged andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeMobile andValue:7];
        [leaderBismarck addFlavorWithType:FlavorTypeNaval andValue:3];
        [leaderBismarck addFlavorWithType:FlavorTypeNavalRecon andValue:3];
        [leaderBismarck addFlavorWithType:FlavorTypeNavalGrowth andValue:4];
        [leaderBismarck addFlavorWithType:FlavorTypeNavalTileImprovement andValue:4];
        [leaderBismarck addFlavorWithType:FlavorTypeAir andValue:6];
        [leaderBismarck addFlavorWithType:FlavorTypeExpansion andValue:7];
        [leaderBismarck addFlavorWithType:FlavorTypeGrowth andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeTileImprovement andValue:6];
        [leaderBismarck addFlavorWithType:FlavorTypeInfrastructure andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeProduction andValue:8];
        [leaderBismarck addFlavorWithType:FlavorTypeGold andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeScience andValue:7];
        [leaderBismarck addFlavorWithType:FlavorTypeCulture andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeHappiness andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeGreatPeople andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeWonder andValue:4];
        [leaderBismarck addFlavorWithType:FlavorTypeReligion andValue:3];
        [leaderBismarck addFlavorWithType:FlavorTypeDiplomacy andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeSpaceship andValue:8];
        [leaderBismarck addFlavorWithType:FlavorTypeWaterConnection andValue:4];
        [leaderBismarck addFlavorWithType:FlavorTypeNuke andValue:7];
        [leaderBismarck addFlavorWithType:FlavorTypeUseNuke andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeEspionage andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeAntiAir andValue:5];
        [leaderBismarck addFlavorWithType:FlavorTypeAirCarrier andValue:5];
        [self.leaders addObject:leaderBismarck];
        
        Leader *leaderFriedrich = [[Leader alloc] initWithName:@"Friedrich" andCivilizationName:@"German"];
        [self.leaders addObject:leaderFriedrich];
        
        Leader *leaderNapoleon = [[Leader alloc] initWithName:@"Napoleon" andCivilizationName:@"French"];
        [self.leaders addObject:leaderNapoleon];
        
        Leader *leaderAlexander = [[Leader alloc] initWithName:@"Alexander" andCivilizationName:@"Greece"];
        [self.leaders addObject:leaderAlexander];
    }
    
    return self;
}

- (Leader *)randomLeaderForCivilizationName:(NSString *)civilizationName
{
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    
    for (Leader *leader in self.leaders) {
        if ([leader.civilizationName isEqualToString:civilizationName]) {
            [filtered addObject:leader];
        }
    }
    
    NSAssert(filtered.count > 0, @"No Leader for civilization: %@", civilizationName);
    
    return [filtered objectAtIndex:(arc4random() % filtered.count)];
}

@end