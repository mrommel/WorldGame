//
//  Distribution.h
//  WorldGame
//
//  Created by Michael Rommel on 10.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Distribution : NSObject

- (instancetype)init;

- (void)addObject:(NSObject *)object withPropability:(CGFloat)propability;

- (void)distribute;

- (NSObject *)objectFromPropability:(CGFloat)propability;

@end
