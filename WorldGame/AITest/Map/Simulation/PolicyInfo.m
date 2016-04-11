//
//  PolicyInfo.m
//  AITest
//
//  Created by Michael Rommel on 23.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "PolicyInfo.h"

#import "XMLReader.h"
#import "NSDictionary+Extension.h"

@implementation PolicyRequirement

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.policy = [dict objectForPath:@"Policy|text"];
        self.state = [dict objectForPath:@"State|text"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[PolicyRequirement: Policy: %@, State: %@]", self.policy, self.state];
}

@end

@implementation PolicyAction

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.type = [dict objectForPath:@"Type|text"];
        self.policy = [dict objectForPath:@"Policy|text"];
        self.state = [dict objectForPath:@"State|text"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[PolicyAction: Type: %@, Policy: %@, State: %@]", self.type, self.policy, self.state];
}

@end

@implementation PolicyState

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.name = [dict objectForPath:@"Name|text"];
        self.desc = [dict objectForPath:@"Description|text"];
        
        self.requirements = [[NSMutableArray alloc] init];
        for (NSDictionary *stateDict in [dict arrayForPath:@"Requirements|Requirement"]) {
            [self.requirements addObject:[[PolicyRequirement alloc] initWithDictionary:stateDict]];
        }
        
        self.actions = [[NSMutableArray alloc] init];
        for (NSDictionary *stateDict in [dict arrayForPath:@"Actions|Action"]) {
            [self.actions addObject:[[PolicyAction alloc] initWithDictionary:stateDict]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[PolicyState: %@, Requirements: %@]", self.name, self.requirements];
}

@end

@implementation PolicyInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self) {
        self.identifier = [dict objectForPath:@"Policy|Identifier|text"];
        self.name = [dict objectForPath:@"Policy|Name|text"];
        self.desc = [dict objectForPath:@"Policy|Description|text"];
        
        NSString *ministryString = [dict objectForPath:@"Policy|Ministry|text"];
        if ([ministryString isEqualToString:@"MINISTRY_CHANCELLERY"]) {
            self.ministry = MinistryChancellery;
        } else if ([ministryString isEqualToString:@"MINISTRY_JUSTICE"]) {
            self.ministry = MinistryJustice;
        } else if ([ministryString isEqualToString:@"MINISTRY_HOMEDEPARTMENT"]) {
            self.ministry = MinistryHomeDepartment;
        } else if ([ministryString isEqualToString:@"MINISTRY_FINANCE"]) {
            self.ministry = MinistryFinance;
        } else {
            self.ministry = MinistryDefault;
        }
        
        self.states = [[NSMutableArray alloc] init];
        
        for (NSDictionary *stateDict in [dict arrayForPath:@"Policy|States|State"]) {
            [self.states addObject:[[PolicyState alloc] initWithDictionary:stateDict]];
        }
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[PolicyInfo: %@, Name: %@, States: %@]", self.identifier, self.name, self.states];
}

@end


@interface PolicyInfoProvider()

@property (nonatomic) NSMutableArray* governments;

@end

@implementation PolicyInfoProvider

static PolicyInfoProvider *shared = nil;

+ (PolicyInfoProvider *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[PolicyInfoProvider alloc] init];
        }
    }
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.governments = [[NSMutableArray alloc] init];
        
        // governments
        [self addPolicyInfo:@"Government"];
        
        // policies
        [self addPolicyInfo:@"Parliament"];
        [self addPolicyInfo:@"Feudalism"];
        [self addPolicyInfo:@"Legalism"];
        [self addPolicyInfo:@"StateSchools"];
        
        // military
        [self addPolicyInfo:@"NationalService"];
        [self addPolicyInfo:@"PoliceForce"];
        
        // taxes
        [self addPolicyInfo:@"InheritanceTax"];
        [self addPolicyInfo:@"SalesTax"];
        [self addPolicyInfo:@"IncomeTax"];
    }
    
    return self;
}

- (NSDictionary *)dictFromName:(NSString *)fileName
{
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath1 options:NSDataReadingUncached error:&error];
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    return dict;
}

- (void)addPolicyInfo:(NSString *)fileName
{
    PolicyInfo *policyInfo = [[PolicyInfo alloc] initWithDictionary:[self dictFromName:fileName]];
    [self.governments addObject:policyInfo];
}

- (PolicyInfo *)policyInfoForIdentifier:(NSString *)identifier
{
    for (PolicyInfo *policyInfo in self.governments) {
        if ([policyInfo.identifier isEqualToString:identifier]) {
            return policyInfo;
        }
    }
    
    return nil;
}

@end