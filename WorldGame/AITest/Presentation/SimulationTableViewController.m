//
//  SimulationTableViewController.m
//  WorldGame
//
//  Created by Michael Rommel on 24.08.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "SimulationTableViewController.h"

#import "UIConstants.h"
#import "GraphData.h"

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

@property (atomic) BOOL isRiverValue;

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
    
    ActionBlock toggleIsRiverBlock = ^(NSIndexPath *path, NSObject *payload) {
        BOOL isRiverActive = [((NSNumber *)payload) boolValue];
        self.isRiver = isRiverActive;
        [[self.dataSource contentAtIndexPath:path] setBool:isRiverActive];
    };
    
    self.dataSource = [[TableViewContentDataSource alloc] init];
    
    GraphDataBlock graphDataBlock = ^(NSIndexPath *path) {
        GraphData *data = [[GraphData alloc] initWithLabel:@"abc"];
        [data addValue:[NSNumber numberWithFloat:0.5f] atIndex:0];
        [data addValue:[NSNumber numberWithFloat:0.4f] atIndex:1];
        [data addValue:[NSNumber numberWithFloat:0.6f] atIndex:2];
        [data addValue:[NSNumber numberWithFloat:0.2f] atIndex:3];
        [data addValue:[NSNumber numberWithFloat:0.2f] atIndex:4];
        [data addValue:[NSNumber numberWithFloat:0.8f] atIndex:5];
        [data addValue:[NSNumber numberWithFloat:1.2f] atIndex:6];
        [data addValue:[NSNumber numberWithFloat:0.5f] atIndex:7];
        return data;
    };
    
    [self.dataSource setTitle:@"Graphs" forHeaderInSection:0];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Graph"
                                                           andGraphData:graphDataBlock]
                      inSection:0];
    
    
    [self.dataSource setTitle:@"deff" forHeaderInSection:1];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"is river"
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleSwitch
                                                              andAction:toggleIsRiverBlock]
                      inSection:1];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Turn %ld", (long)self.currentTurn]
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleNormal
                                                              andAction:nil]
                      inSection:1];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Hunters %ld", (long)self.people.hunters]
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleNormal
                                                              andAction:nil]
                      inSection:1];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Peasants %ld", (long)self.people.peasants]
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleNormal
                                                              andAction:nil]
                      inSection:1];
}

- (BOOL)hasScience:(NSString *)science
{
    return NO;
}

- (BOOL)isRiver
{
    return self.isRiverValue;
}

- (void)setIsRiver:(BOOL)isRiverValue
{
    self.isRiverValue = isRiverValue;
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
    
    //[self.tableView reloadData];
}

@end
