//
//  CombatViewController.h
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GLViewController.h"

@class CombatBoard;

@interface CombatViewController : GLViewController

@property (nonatomic, retain) CombatBoard *combatBoard;

@end
