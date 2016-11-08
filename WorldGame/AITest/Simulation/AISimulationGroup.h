//
//  AISimulationGroup.h
//  WorldGame
//
//  Created by Michael Rommel on 08.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AISimulationProperty.h"

@interface AISimulationGroup : NSObject

@property (nonatomic) NSString* name;
@property (nonatomic) NSString* explanation;

@property (nonatomic) AISimulationProperty* mood;
@property (nonatomic) AISimulationProperty* freq;

- (instancetype)initWithName:(NSString *)name
                 explanation:(NSString *)explanation
           startingMoodValue:(CGFloat)moodValue
        andStartingFreqValue:(CGFloat)freqValue;

- (void)calculate;

@end
