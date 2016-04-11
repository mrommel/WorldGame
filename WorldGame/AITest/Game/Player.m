//
//  Player.m
//  AITest
//
//  Created by Michael Rommel on 22.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Player.h"

#import "GrandStrategyAI.h"
#import "Game.h"
#import "PolicyInfo.h"

static NSString* const PlayerDataXKey = @"Player.Y";
static NSString* const PlayerDataYKey = @"Player.X";
static NSString* const PlayerDataCivilizationKey = @"Player.Civilization";

@implementation Player

- (instancetype)initWithStartPosition:(CGPoint)position andCivilization:(Civilization *)civilization
{
    self = [super init];
    
    if (self) {
        self.position = position;
        self.civilization = civilization;
        self.units = [[NSMutableArray alloc] init];
        self.cities = [[NSMutableArray alloc] init];
        
        self.policies = [NSMutableArray new];
        
        // policies
        [self.policies addObject:[[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_GOVERNMENT"]]];
        [self.policies addObject:[[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_LEGALISM"]]];
        [self.policies addObject:[[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_FEUDALISM"]]];
        [self.policies addObject:[[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_PARLIAMENT"]]];
        
        self.inheritanceTax = [[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_INHERITANCETAX"]];
        [self.policies addObject:self.inheritanceTax];
        self.incomeTax = [[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_INCOMETAX"]];
        [self.policies addObject:self.incomeTax];
        self.salesTax = [[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_SALESTAX"]];
        [self.policies addObject:self.salesTax];
        
        self.policeForce = [[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_POLICEFORCE"]];
        [self.policies addObject:self.policeForce];
        self.stateSchools = [[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_STATESCHOOLS"]];
        [self.policies addObject:self.stateSchools];
        self.nationalService = [[Policy alloc] initWithPolicyInfo:[[PolicyInfoProvider sharedInstance] policyInfoForIdentifier:@"POLICY_NATIONALSERVICE"]];
        [self.policies addObject:self.nationalService];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        CGFloat x = [decoder decodeFloatForKey:PlayerDataXKey];
        CGFloat y = [decoder decodeFloatForKey:PlayerDataYKey];
        self.position = CGPointMake(x, y);
        self.civilization = [decoder decodeObjectForKey:PlayerDataCivilizationKey];
        self.units = [[NSMutableArray alloc] init];
        self.cities = [[NSMutableArray alloc] init];
        
        self.policies = [NSMutableArray new];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeFloat:self.position.x forKey:PlayerDataXKey];
    [encoder encodeFloat:self.position.y forKey:PlayerDataYKey];
    [encoder encodeObject:self.civilization forKey:PlayerDataCivilizationKey];
}

- (BOOL)isHuman
{
    return NO;
}

- (BOOL)isArtificial
{
    return NO;
}

- (void)addUnit:(Unit *)unit
{
    [self.units addObject:unit];
}

- (void)settleAtX:(int)x andY:(int)y
{
    [[[GameProvider sharedInstance].game.map tileAtX:x andY:y] settleWithPlayer:self];
}

- (NSMutableArray *)policiesForMinistry:(Ministry)ministry
{
    NSMutableArray *policies = [NSMutableArray new];
    
    for (Policy *policy in self.policies) {
        if (policy.ministry == ministry) {
            [policies addObject:policy];
        }
    }
    
    return policies;
}

- (void)turn
{
    for (Policy *policy in self.policies) {
        [policy stack];
    }
}

@end

@implementation HumanPlayer

- (instancetype)initWithStartPosition:(CGPoint)position andCivilization:(Civilization *)civilization
{
    self = [super initWithStartPosition:position andCivilization:civilization];
    
    if (self) {
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        // NOOP
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // NOOP
}

- (BOOL)isHuman
{
    return YES;
}

@end

@implementation AIPlayer

- (instancetype)initWithStartPosition:(CGPoint)position andCivilization:(Civilization *)civilization
{
    self = [super initWithStartPosition:position andCivilization:civilization];
    
    if (self) {
        self.grandStrategyAI = [[GrandStrategyAI alloc] initWithGrandStrategyType:GrandStrategyTypeConquest];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        // NOOP
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    // NOOP
}

- (BOOL)isArtificial
{
    return YES;
}

@end