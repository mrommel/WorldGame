//
//  Continent.h
//  AITest
//
//  Created by Michael Rommel on 16.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Continent : NSObject<NSCoding>

@property (atomic) NSInteger identifier;
@property (nonatomic) NSString *name;

- (instancetype)initWithIdentifier:(int)identifier andName:(NSString *)name;

@end
