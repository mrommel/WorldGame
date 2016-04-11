//
//  Flavor.h
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 type of flavors
 */
typedef NS_ENUM(NSInteger, FlavorType) {
    FlavorTypeOffense,
    FlavorTypeDefense,
    FlavorTypeCityDefense,
    FlavorTypeMilitaryTraining,
    FlavorTypeRecon,
    FlavorTypeRanged,
    FlavorTypeMobile,
    FlavorTypeNaval,
    FlavorTypeNavalRecon,
    FlavorTypeNavalGrowth,
    FlavorTypeNavalTileImprovement,
    FlavorTypeAir,
    FlavorTypeExpansion,
    FlavorTypeGrowth,
    FlavorTypeTileImprovement,
    FlavorTypeInfrastructure,
    FlavorTypeProduction,
    FlavorTypeGold,
    FlavorTypeScience,
    FlavorTypeCulture,
    FlavorTypeHappiness,
    FlavorTypeGreatPeople,
    FlavorTypeWonder,
    FlavorTypeReligion,
    FlavorTypeDiplomacy,
    FlavorTypeSpaceship,
    FlavorTypeWaterConnection,
    FlavorTypeNuke,
    FlavorTypeUseNuke,
    FlavorTypeEspionage,
    FlavorTypeAntiAir,
    FlavorTypeAirCarrier,
};

/*!
 flavor object class
 */
@interface Flavor : NSObject

@property (atomic) FlavorType flavorType;
@property (atomic) int flavor;

- (instancetype)initWithFlavorType:(FlavorType)flavorType andFlavor:(int)flavor;

@end
