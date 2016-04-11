//
//  Civilization.h
//  AITest
//
//  Created by Michael Rommel on 25.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 class that holds the players civ
 */
@interface Civilization : NSObject<NSCoding>

@property (nonatomic) NSString *name;
@property (nonatomic) UIColor *foregroundColor;
@property (nonatomic) UIColor *backgroundColor;

- (instancetype)initWithName:(NSString *)name;

@end

/*!
 class that provides leader objects
 */
@interface CivilizationProvider : NSObject

+ (CivilizationProvider *)sharedInstance;

- (Civilization *)civilizationForName:(NSString *)civilizationName;
- (Civilization *)randomCivilization;

@end