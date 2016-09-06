//
//  SetupGameTableViewController.m
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "SetupGameTableViewController.h"

#import "UIConstants.h"
#import "GameViewController.h"
#import "SelectMapTypeTableViewController.h"
#import "Map.h"

@implementation SetupGameTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Setup";
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // update first entry in case the game is already started
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [[TableViewContent alloc] initWithTitle:@"Quick Start"
                                               andSubtitle:@"default params"
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     GameViewController *viewcontroller = [[GameViewController alloc] init];
                                                     viewcontroller.options = [[MapOptions alloc] initWithMapType:MapTypeDefault andSize:MapSizeDefault];
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
        case 1:
            return [[TableViewContent alloc] initWithTitle:@"Setup Game"
                                               andSubtitle:@"Setup"
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     // NOOP
                                                     [self.navigationController pushViewController:[[SelectMapTypeTableViewController alloc] init] animated:YES];
                                                 }];
            break;
        case 2:
            return [[TableViewContent alloc] initWithTitle:@"Load Game"
                                               andSubtitle:@"Load"
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     
                                                 }];
            break;
    }
    
    return nil;
}

@end
