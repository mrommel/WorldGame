//
//  Group.h
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Simulation;
@class Policy;
@class GroupType;

/*!
 @brief type of group 
 
 can be of type mood or freq
 */
typedef NS_ENUM(NSInteger, GroupValue) {
    GroupValueMood,
    GroupValueFreq
};

/*! 
 class that holds a group of people
 */
@interface Group : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) GroupType *groupType;

/*!
 constructor of group
 
 @param name name of the group
 @param groupType type of the group (used level the frequency)
 */
- (instancetype)initWithName:(NSString *)name andGroupType:(GroupType *)groupType;

/*!
 add a relation to a simulation for the given groupValue
 
 @param groupValue freq or mood
 @param formula string containing the formula (including x) 
 */
- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toSimulation:(Simulation *)simulation;
- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toSimulation:(Simulation *)simulation withDelay:(int)delay;
- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toPolicy:(Policy *)policy;
- (void)addRelationTo:(GroupValue)groupValue withFormula:(NSString *)formula toPolicy:(Policy *)policy withDelay:(int)delay;

/*! 
 get the value for mood or freq with delay
 
 @param groupValue mood or freq
 @param delay value with delay in turns
 @return value for mood or freq with delay
 */
- (float)valueForGroupValue:(GroupValue)groupValue withDelay:(int)delay;

/*!
 get the frequence value with delay
 
 @param delay value with delay in turns
 @return value for freq with delay
 */
- (float)frequencyWithDelay:(int)delay;

/*!
 get the mood value with delay
 
 @param delay value with delay in turns
 @return value for mood with delay
 */
- (float)moodWithDelay:(int)delay;

/*!
 sets new frequency value
 
 @param frequency new frequency value
 */
- (void)updateFrequenceValue:(float)frequency;

/*! 
 evaluates the relation of the group and updates the mood and freq
 */
- (void)turn;

/*!
 current value is put to the stack
 */
- (void)stack;

@end

