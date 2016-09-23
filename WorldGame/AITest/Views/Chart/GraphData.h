//
//  GraphData.h
//  WorldGame
//
//  Created by Michael Rommel on 22.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *
 */
typedef NS_ENUM(NSInteger, GraphColorScheme) {
    GraphColorSchemeDefault,
    GraphColorSchemePastell,
    GraphColorSchemeLiberty
};

/*!
 *
 */
typedef NS_ENUM(NSInteger, GraphType) {
    GraphTypeDefault,
    GraphTypeLine,
    GraphTypeBar,
    GraphTypePie
};

/*!
 *
 */
@interface GraphData : NSObject

@property (nonatomic) NSString *label;
@property (nonatomic) NSMutableArray *keys;
@property (nonatomic) NSMutableArray *values;

@property (atomic) GraphColorScheme colorScheme;
@property (atomic) GraphType type;

- (instancetype)initWithLabel:(NSString *)label;

- (void)addKey:(NSString *)key atIndex:(NSInteger)index;

- (void)addValue:(NSNumber *)value atIndex:(NSInteger)index;
- (void)addValue:(NSNumber *)value forKey:(NSString *)key;

@end
