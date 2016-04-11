//
//  PolicyInfo.h
//  AITest
//
//  Created by Michael Rommel on 23.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 type of ministry
 */
typedef NS_ENUM(NSInteger, Ministry) {
    MinistryDefault,
    MinistryChancellery,
    MinistryHomeDepartment,
    MinistryFinance,
    MinistryJustice,
    //MinistryForeign,
    //MinistryDefense,
    //MinistryHealth,
    //MinistryCivilService,
};

/*!
 
 */
@interface PolicyRequirement : NSObject

@property (nonatomic) NSString *policy;
@property (nonatomic) NSString *state;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

/*!
 
 */
@interface PolicyAction : NSObject

@property (nonatomic) NSString *type;
@property (nonatomic) NSString *policy;
@property (nonatomic) NSString *state;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

/*!
 
 */
@interface PolicyState : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *desc;
@property (nonatomic) NSMutableArray *requirements;
@property (nonatomic) NSMutableArray *actions;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

/*!
 
 */
@interface PolicyInfo : NSObject

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *desc;
@property (atomic) Ministry ministry;
@property (nonatomic) NSMutableArray *states;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

/*!
 
 */
@interface PolicyInfoProvider : NSObject

+ (PolicyInfoProvider *)sharedInstance;

- (PolicyInfo *)policyInfoForIdentifier:(NSString *)name;

@end