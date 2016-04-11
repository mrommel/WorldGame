//
//  RelationsNetwork.h
//  AITest
//
//  Created by Michael Rommel on 04.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Policy.h"
#import "Player.h"

/*!
 class that holds all simulations
 */
@interface RelationsNetwork : NSObject

- (instancetype)init;

- (void)setPlayer:(Player *)player withEvent:(EventType)eventType;

- (void)turn;

@end
