//
//  SelectMapTableViewController.m
//  AITest
//
//  Created by Michael Rommel on 17.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "SelectMapTypeTableViewController.h"

#import "SelectMapSizeTableViewController.h"
#import "Map.h"
#import "ImageAtlas.h"
#import "UIConstants.h"

const static int kMapTypeBipolar = 0;
const static int kMapTypeContinents = 1;
const static int kMapTypePangea = 2;
const static int kMapTypes = 3;

@implementation SelectMapTypeTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Select Map";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // update first entry in case the game is already started
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kMapTypes;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kMapTypeBipolar:
            return [[TableViewContent alloc] initWithTitle:@"Bipolar Map"
                                               andSubtitle:@"A generic Map that consists of two land masses divided by an ocean, but connects thru a small land bridge."
                                                  andImage:[ImageAtlas imageNamed:@"MapBipolar" fromAtlasNamed:@"MapTypeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     SelectMapSizeTableViewController *viewcontroller = [[SelectMapSizeTableViewController alloc] init];
                                                     viewcontroller.mapType = MapTypeBipolar;
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
        case kMapTypeContinents:
            return [[TableViewContent alloc] initWithTitle:@"Continent Map"
                                               andSubtitle:@"Generates a Map with a multiple continents"
                                                  andImage:[ImageAtlas imageNamed:@"MapContinents" fromAtlasNamed:@"MapTypeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     SelectMapSizeTableViewController *viewcontroller = [[SelectMapSizeTableViewController alloc] init];
                                                     viewcontroller.mapType = MapTypeContinents;
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
        case kMapTypePangea:
            return [[TableViewContent alloc] initWithTitle:@"Pangea Map"
                                               andSubtitle:@"Generates a Map with one big continent"
                                                  andImage:[ImageAtlas imageNamed:@"MapPangea" fromAtlasNamed:@"MapTypeAtlas"]
                                                 andAction:^(NSIndexPath *indexPath, NSObject *payload) {
                                                     SelectMapSizeTableViewController *viewcontroller = [[SelectMapSizeTableViewController alloc] init];
                                                     viewcontroller.mapType = MapTypePangea;
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                 }];
            break;
    }
    
    return nil;
}

@end
