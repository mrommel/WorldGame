//
//  MinistryViewController.h
//  AITest
//
//  Created by Michael Rommel on 05.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Policy.h"
@class Player;

@interface MinistryTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>

@property (atomic) Ministry ministry;
@property (atomic) Player* player;

@end
