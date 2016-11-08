//
//  AISimulationGroup.m
//  WorldGame
//
//  Created by Michael Rommel on 08.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AISimulationGroup.h"

@interface AISimulationGroup()

@end

@implementation AISimulationGroup

- (instancetype)initWithName:(NSString *)name
                 explanation:(NSString *)explanation
           startingMoodValue:(CGFloat)moodValue
        andStartingFreqValue:(CGFloat)freqValue
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.explanation = explanation;
        
        self.mood = [[AISimulationProperty alloc] initWithName:[NSString stringWithFormat:@"%@ Mood", name] explanation:@"" startingValue:moodValue andCategory:AISimulationCategoryVoter];
        self.freq = [[AISimulationProperty alloc] initWithName:[NSString stringWithFormat:@"%@ Freq", name] explanation:@"" startingValue:freqValue andCategory:AISimulationCategoryVoter];
    }
    
    return self;
}

- (void)calculate
{
    [self.mood calculate];
    [self.freq calculate];
}

@end
