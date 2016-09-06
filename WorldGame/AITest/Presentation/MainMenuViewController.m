//
//  MainMenuViewController.m
//  AITest
//
//  Created by Michael Rommel on 17.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MainMenuViewController.h"

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "AboutViewController.h"
#import "DebugViewController.h"
#import "SelectMapTypeTableViewController.h"
#import "SetupGameTableViewController.h"
#import "LoadGameViewController.h"
#import "Game.h"
#import "UIConstants.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"WorldGame";
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
    return 4;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [[TableViewContent alloc] initWithTitle:([GameProvider sharedInstance].game == nil ? @"New Game" : @"Continue Game")
                                                  andSubtitle:@"Configure your game"
                                                    andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                if ([GameProvider sharedInstance].game == nil) {
                    [self.navigationController pushViewController:[[SetupGameTableViewController alloc] init] animated:YES];
                } else {
                    [self.navigationController pushViewController:[[GameViewController alloc] init] animated:YES];
                }
            }];
            break;
        case 1:
            return [[TableViewContent alloc] initWithTitle:@"Load game"
                                               andSubtitle:@"Load"
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     [self.navigationController pushViewController:[[LoadGameViewController alloc] init] animated:YES];
                                                 }];
            break;
        case 2:
            return [[TableViewContent alloc] initWithTitle:@"About"
                                                  andSubtitle:@"Load"
                                                    andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                        [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
                                                    }];
            break;
        case 3:
            return [[TableViewContent alloc] initWithTitle:@"Debug"
                                                  andSubtitle:@"Load"
                                                    andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                        [self.navigationController pushViewController:[[DebugViewController alloc] init] animated:YES];
                                                    }];
            break;
    }
    
    return nil;
}

@end
