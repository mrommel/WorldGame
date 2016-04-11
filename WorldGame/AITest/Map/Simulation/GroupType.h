//
//  GroupType.h
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;

/*!
 class that
 */
@interface GroupType : NSObject

@property (nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name;

- (void)addGroup:(Group *)group;

- (void)levelGroups;

@end