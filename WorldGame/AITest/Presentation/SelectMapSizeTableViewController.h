//
//  SelectMapSizeTableViewController.h
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "BaseTableViewController.h"

#import "Map.h"

@interface SelectMapSizeTableViewController : BaseTableViewController<TableViewContentSource, UITableViewDelegate, UITableViewDataSource>

@property (atomic) MapType mapType;

@end
