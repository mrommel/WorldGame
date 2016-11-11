//
//  Distribution.m
//  WorldGame
//
//  Created by Michael Rommel on 10.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "Distribution.h"

@interface DistributionItem : NSObject

@property (nonatomic) NSObject *object;
@property (atomic) CGFloat propability;

- (instancetype)initWithObject:(NSObject *)object andPropability:(CGFloat)propability;

@end

@implementation DistributionItem

- (instancetype)initWithObject:(NSObject *)object andPropability:(CGFloat)propability
{
    self = [super init];
    
    if (self) {
        self.object = object;
        self.propability = propability;
    }
    
    return self;
}

@end


@interface Distribution()

@property (nonatomic) NSMutableArray *items;

@end

@implementation Distribution

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.items = [NSMutableArray new];
    }
    
    return self;
}

- (void)addObject:(NSObject *)object withPropability:(CGFloat)propability
{
    DistributionItem *distributionItem = [[DistributionItem alloc] initWithObject:object andPropability:propability];
    [self.items addObject:distributionItem];
}

- (void)distribute
{
    CGFloat sum = 0.0;
    for (DistributionItem *distributionItem in self.items) {
        sum += distributionItem.propability;
    }
    
    if (sum == 0.0) {
        return;
    }
    
    for (DistributionItem *distributionItem in self.items) {
        distributionItem.propability /= sum;
    }
}

- (NSObject *)objectFromPropability:(CGFloat)propability
{
    for (DistributionItem *distributionItem in self.items) {
        if (propability < distributionItem.propability) {
            return distributionItem.object;
        }
        
        propability -= distributionItem.propability;
    }
    
    return ((DistributionItem *)[self.items lastObject]).object;
}

@end
