//
//  SimulationTableViewController.m
//  WorldGame
//
//  Created by Michael Rommel on 24.08.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "SimulationTableViewController.h"

#import "UIConstants.h"

@interface PeopleDistribution : NSObject

@property (nonatomic) id<PeopleDistributionTerrainDelegate> terrainDelegate;
@property (nonatomic) id<PeopleDistributionScienceDelegate> scienceDelegate;

@property (atomic) NSInteger hunters;
@property (atomic) NSInteger peasants;

@end

@implementation PeopleDistribution

- (instancetype)initWithTerrainDelegate:(id<PeopleDistributionTerrainDelegate>) terrainDelegate andScienceDelegate:(id<PeopleDistributionScienceDelegate>) scienceDelegate
{
    self = [super init];
    
    if (self) {
        self.hunters = 100; // or fishermen
        self.peasants = 0;
        self.terrainDelegate = terrainDelegate;
        self.scienceDelegate = scienceDelegate;
    }
    
    return self;
}

- (void)turn
{
    if (self.peasants == 0) {
        if ([self.scienceDelegate hasScience:@"AGRICULTURE"]) {
            self.peasants = 5;
        }
    }
}

@end

#pragma mark -

@interface SimulationTableViewController ()

@property (atomic) NSInteger currentTurn;
@property (nonatomic) PeopleDistribution *people;

@end

@implementation SimulationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentTurn = 0;
    self.people = [[PeopleDistribution alloc] initWithTerrainDelegate:self andScienceDelegate:self];
    
    self.title = @"Simulation";
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
    
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"sync"] action:@selector(handleRefreshNavigationBarItem:)];
    
    self.dataSource = [[TableViewContentDataSource alloc] init];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"is river"
                                                           andSubtitle:@""
                                                              andStyle:ContentStyleSwitch
                                                             andAction:^(NSIndexPath *path) {
                                                                 NSLog(@"toggle:::");
                                                             }]];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Turn %ld", (long)self.currentTurn]
                                                           andSubtitle:@""
                                                              andStyle:ContentStyleNormal
                                                              andAction:nil]];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Hunters %ld", (long)self.people.hunters]
                                                           andSubtitle:@""
                                                              andStyle:ContentStyleNormal
                                                              andAction:nil]];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Peasants %ld", (long)self.people.peasants]
                                                           andSubtitle:@""
                                                              andStyle:ContentStyleNormal
                                                              andAction:nil]];
}

- (BOOL)hasScience:(NSString *)science
{
    return NO;
}

- (BOOL)isRiver
{
    return NO;
}

- (NSString *)terrain
{
    return @"GRASSLAND";
}

- (void)handleRefreshNavigationBarItem:(UIBarButtonItem *)sender
{
    NSLog(@"refresh");
    
    self.currentTurn++;
    [self.people turn];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsInSection:section];
}

@end
