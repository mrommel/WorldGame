//
//  SimulationTableViewController.h
//  WorldGame
//
//  Created by Michael Rommel on 24.08.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "BaseTableViewController.h"

/*!
 delegates
 */
@protocol PeopleDistributionTerrainDelegate <NSObject>

- (BOOL)isRiver;
- (NSString *)terrain;

@end

@protocol PeopleDistributionScienceDelegate <NSObject>

- (BOOL)hasScience:(NSString *)science;

@end



@interface SimulationTableViewController : BaseTableViewController<PeopleDistributionTerrainDelegate, PeopleDistributionScienceDelegate>

@end
