//
//  KeyValueMap.h
//  WorldGame
//
//  Created by Michael Rommel on 19.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface KeyValueMap : NSObject

- (instancetype)init;

- (void)addValue:(CGFloat)value forKey:(NSString *)key;

- (NSString *)keyOfHeightestValue;

@end
