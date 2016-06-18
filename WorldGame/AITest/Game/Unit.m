//
//  Unit.m
//  AITest
//
//  Created by Michael Rommel on 23.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Unit.h"

#import "Map.h"
#import "XMLReader.h"
#import "NSDictionary+Extension.h"

#define INVALID_POINT   CGPointMake(-1, -1)

@implementation NSString (EnumParser)

- (UnitClass)unitClassValue
{
    NSDictionary<NSString*, NSNumber*> *unitTypes = @{
                                                        @"Melee": @(UnitTypeMelee),
                                                        @"Ranged": @(UnitTypeRanged),
                                                        @"Cavalry": @(UnitTypeCavalry)
                                                    };
    return unitTypes[self].integerValue;
}

- (UnitPromotion)unitPromotionValue
{
    return UnitPromotionEmbark;
}

@end

#pragma mark -

@implementation UnitType

- (instancetype)initFromFile:(NSString *)fileName
{
    self = [super init];
    
    if (self) {
        // laod the file
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:filePath
                                              options:NSDataReadingUncached
                                                error:&error];
        NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                     options:XMLReaderOptionsProcessNamespaces
                                                       error:&error];
        // fill the values
        self.unitClass = [[dict objectForPath:@"UnitType|UnitClass|text"] unitClassValue];
        self.maxAmmo = [[dict objectForPath:@"UnitType|MaxAmmo|text"] intValue];
        self.maxFood = [[dict objectForPath:@"UnitType|MaxFood|text"] intValue];
        self.maxFuel = [[dict objectForPath:@"UnitType|MaxFuel|text"] intValue];
        self.maxHealth = [[dict objectForPath:@"UnitType|MaxHealth|text"] intValue];
    }
    
    return self;
}

@end

#pragma mark -

@interface UnitTypeProvider()

@property (nonatomic) NSMutableDictionary *unitTypes;

@end

@implementation UnitTypeProvider

static UnitTypeProvider *shared = nil;

+ (UnitTypeProvider *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[self alloc] init];
        }
    }
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.unitTypes = [NSMutableDictionary new];
        
        NSArray *unitTypes = @[@"Hoplites"];
        
        for (NSString *unitType in unitTypes) {
            [self.unitTypes setObject:[[UnitType alloc] initFromFile:unitType] forKey:unitType];
        }
    }
    
    return self;
}

- (UnitType *)unitTypeForTypeKey:(NSString *)typeKey
{
    return [self.unitTypes objectForKey:typeKey];
}

@end

#pragma mark -

@implementation Unit

- (instancetype)initWithType:(NSString *)typeKey atPosition:(CGPoint)position onMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.typeKey = typeKey;
        self.position = position;
        
        UnitType *type = [[UnitTypeProvider sharedInstance] unitTypeForTypeKey:typeKey];
        self.health = type.maxHealth;
        self.ammo = type.maxAmmo;
        self.food = type.maxFood;
        self.fuel = type.maxFuel;

        // copy promotions
        self.promotions = [NSMutableArray new];
        
        for (NSNumber *promotionNumber in type.promotions) {
            [self addPromotion:[promotionNumber intValue]];
        }
    }
    
    return self;
}

- (BOOL)hasPromotion:(UnitPromotion)promotion
{
    for (NSNumber *promotionNumber in self.promotions) {
        if ([promotionNumber intValue] == promotion) {
            return YES;
        };
    }
    
    return NO;
}

- (void)addPromotion:(UnitPromotion)promotion
{
    [self.promotions addObject:[NSNumber numberWithInt:promotion]];
}

@end

#pragma mark -

@implementation Army

- (instancetype)initWithLeader:(ArmyLeader *)leader
{
    self = [super init];
    
    if (self) {
        self.leader = leader;
        self.units = [NSMutableArray new];
    }
    
    return self;
}

- (void)addUnit:(Unit *)unit
{
    
}

- (void)join:(Army *)army
{
    
}

- (void)attackArmyAt:(CGPoint)position withCallback:(CombatCallback)callback
{
    
}

- (void)siegeCityAt:(CGPoint)position withCallback:(CombatCallback)callback
{
    
}

@end
