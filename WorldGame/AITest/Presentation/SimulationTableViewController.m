//
//  SimulationTableViewController.m
//  WorldGame
//
//  Created by Michael Rommel on 24.08.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "SimulationTableViewController.h"

#import "UIConstants.h"

@interface SimulationTableViewController ()

@property (atomic) NSInteger numberOfEntries;

@end

@implementation SimulationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberOfEntries = 1;
    
    self.title = @"Simulation";
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
    
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"sync"] action:@selector(handleRefreshNavigationBarItem:)];
}

- (void)setNavigationRightButtonWithImage:(UIImage *)image action:(SEL)action
{
    self.navigationItem.rightBarButtonItem.action = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                            action:action];
}

- (void)handleRefreshNavigationBarItem:(UIBarButtonItem *)sender
{
    NSLog(@"refresh");
    
    self.numberOfEntries = 2;
    
    [self.tableView reloadData];
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
    return self.numberOfEntries;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return [[TableViewContent alloc] initWithTitle:@"1"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleNormal
                                                 andAction:nil];
            break;
        case 1:
            return [[TableViewContent alloc] initWithTitle:@"2"
                                               andSubtitle:@"done"
                                                  andStyle:ContentStyleNormal
                                                 andAction:nil];
            break;
            
    }
    
    return nil;
}

@end
