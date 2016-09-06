//
//  DebugViewController.m
//  AITest
//
//  Created by Michael Rommel on 11.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "DebugViewController.h"

#import "UIConstants.h"

#import "CombatViewController.h"
#import "CombatBoard.h"
#import "Game.h"
#import "SimulationTableViewController.h"

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 10;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return [[TableViewContent alloc] initWithTitle:@"Load / Save games"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleDisabled
                                                 andAction:nil];
            break;
        case 1:
            return [[TableViewContent alloc] initWithTitle:@"Zoom Map"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleDisabled
                                                 andAction:nil];
            break;
        case 2:
            return [[TableViewContent alloc] initWithTitle:@"attach AI calculation"
                                               andSubtitle:@"open"
                                                  andStyle:ContentStyleNormal
                                                 andAction:nil];
            break;
        case 3:
            return [[TableViewContent alloc] initWithTitle:@"add center button to map"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleDisabled
                                                 andAction:nil];
            break;
        case 4:
            return [[TableViewContent alloc] initWithTitle:@"Map/Game thumbnail for map preview"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleDisabled
                                                 andAction:nil];
            break;
        case 5:
            return [[TableViewContent alloc] initWithTitle:@"Save game when enter background (autosave)"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleDisabled
                                                 andAction:nil];
            break;
        case 6:
            return [[TableViewContent alloc] initWithTitle:@"Delete autosave games (keep 10)"
                                               andSubtitle:@"open"
                                                  andStyle:ContentStyleNormal
                                                 andAction:nil];
            break;
        case 7:
            return [[TableViewContent alloc] initWithTitle:@"Log game state"
                                               andSubtitle:@"open"
                                                  andStyle:ContentStyleNormal
                                                 andAction:nil];
            break;
        case 8:
            return [[TableViewContent alloc] initWithTitle:@"OpenGL"
                                               andSubtitle:@"open"
                                                  andStyle:ContentStyleNormal
                                                 andAction:^(NSIndexPath *path, NSObject *payload) {
                                                     CombatViewController *combatViewController = [[CombatViewController alloc] init];
                                                     combatViewController.combatBoard = [[CombatBoard alloc] initWithAttackerPosition:CGPointMake(0, 0) andDefenderPosition:CGPointMake(1, 1) onMap:[GameProvider sharedInstance].game.map];
                                                     [self.navigationController pushViewController:combatViewController animated:YES];
                                                 }];
            break;
        case 9:
            return [[TableViewContent alloc] initWithTitle:@"Simulation"
                                               andSubtitle:@"open"
                                                  andStyle:ContentStyleNormal
                                                 andAction:^(NSIndexPath *path, NSObject *payload) {
                                                     SimulationTableViewController *simulationViewController = [[SimulationTableViewController alloc] init];
                                                     [self.navigationController pushViewController:simulationViewController animated:YES];
                                                 }];
            
    }
    
    return nil;
}

@end
