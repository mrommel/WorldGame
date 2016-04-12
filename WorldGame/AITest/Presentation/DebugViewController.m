//
//  DebugViewController.m
//  AITest
//
//  Created by Michael Rommel on 11.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "DebugViewController.h"

#import "UIConstants.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Debug";
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 5;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return [[TableViewContent alloc] initWithTitle:@"Load / Save games"
                                               andSubtitle:@"done"
                                                 andAction:nil];
            break;
        case 1:
            return [[TableViewContent alloc] initWithTitle:@"Zoom Map"
                                               andSubtitle:@"done"
                                                 andAction:nil];
            break;
        case 2:
            return [[TableViewContent alloc] initWithTitle:@"enable AI calculation"
                                               andSubtitle:@"open"
                                                 andAction:nil];
            break;
        case 3:
            return [[TableViewContent alloc] initWithTitle:@"add center button to map"
                                               andSubtitle:@"progress"
                                                 andAction:nil];
            break;
        case 4:
            return [[TableViewContent alloc] initWithTitle:@"Map/Game thumbnail for map preview"
                                               andSubtitle:@"open"
                                                 andAction:nil];
            break;
    }
    
    return nil;
}

@end
