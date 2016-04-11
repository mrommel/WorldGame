//
//  SelectMapSizeTableViewController.m
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "SelectMapSizeTableViewController.h"

#import "Map.h"
#import "ImageAtlas.h"
#import "UIConstants.h"
#import "GameViewController.h"

const static int kMapSizeDuel = 0;
const static int kMapSizeTiny = 1;
const static int kMapSizeSmall = 2;
const static int kMapSizeStandard = 3;
const static int kMapSizes = 4;

@implementation SelectMapSizeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Select Map";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // update table in case the game is already started
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kMapSizes;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case kMapSizeDuel:
            return [[TableViewContent alloc] initWithTitle:@"Duel Map"
                                               andSubtitle:@"Duel"
                                                  andImage:[ImageAtlas imageNamed:@"Duel" fromAtlasNamed:@"MapSizeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath) {
                                                     GameViewController *viewcontroller = [[GameViewController alloc] init];
                                                     viewcontroller.options = [[MapOptions alloc] initWithMapType:weakSelf.mapType andSize:kMapSizeDuel];
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
        case kMapSizeTiny:
            return [[TableViewContent alloc] initWithTitle:@"Tiny Map"
                                               andSubtitle:@"Tiny"
                                                  andImage:[ImageAtlas imageNamed:@"Tiny" fromAtlasNamed:@"MapSizeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath) {
                                                     GameViewController *viewcontroller = [[GameViewController alloc] init];
                                                     viewcontroller.options = [[MapOptions alloc] initWithMapType:weakSelf.mapType andSize:kMapSizeTiny];
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
        case kMapSizeSmall:
            return [[TableViewContent alloc] initWithTitle:@"Small Map"
                                               andSubtitle:@"Small"
                                                  andImage:[ImageAtlas imageNamed:@"Small" fromAtlasNamed:@"MapSizeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath) {
                                                     GameViewController *viewcontroller = [[GameViewController alloc] init];
                                                     viewcontroller.options = [[MapOptions alloc] initWithMapType:weakSelf.mapType andSize:kMapSizeSmall];
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
        case kMapSizeStandard:
            return [[TableViewContent alloc] initWithTitle:@"Standard Map"
                                               andSubtitle:@"Standard"
                                                  andImage:[ImageAtlas imageNamed:@"Standard" fromAtlasNamed:@"MapSizeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath) {
                                                     GameViewController *viewcontroller = [[GameViewController alloc] init];
                                                     viewcontroller.options = [[MapOptions alloc] initWithMapType:weakSelf.mapType andSize:kMapSizeStandard];
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
    }
    
    return nil;
}


@end
