//
//  GroupType.m
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GroupType.h"

#import "Group.h"

/*!
 
 */
@interface GroupType()

@property (nonatomic) NSMutableArray *groups;

@end

@implementation GroupType

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.groups = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addGroup:(Group *)group
{
    [self.groups addObject:group];
}

- (void)levelGroups
{
    float sum = 0.0f;
    for (Group *group in self.groups) {
        sum += [group frequencyWithDelay:0];
    }
    
    for (Group *group in self.groups) {
        [group updateFrequenceValue:([group frequencyWithDelay:0] / sum)];
    }
}

- (NSString *)description
{
    NSMutableString *groups = [@"" mutableCopy];
    
    for (Group *group in self.groups) {
        [groups appendFormat:@"%@, ", group];
    }
    
    return [NSString stringWithFormat:@"[GroupType '%@']", groups];
}

@end
