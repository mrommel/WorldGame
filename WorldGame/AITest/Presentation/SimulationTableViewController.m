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
#import "AISimulation.h"

@interface SimulationTableViewController ()

@property (nonatomic) AISimulation *simulation;

@property (atomic) BOOL isRiverValue;

@end

@implementation SimulationTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.simulation = [[AISimulation alloc] init];
    [self.simulation calculate];
    
    self.title = @"Simulation";
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
    
    [self setNavigationRightButtonWithImage:[UIImage imageNamed:@"sync"] action:@selector(handleRefreshNavigationBarItem:)];
    
    ActionBlock toggleIsRiverBlock = ^(NSIndexPath *path, NSObject *payload) {
        BOOL isRiverActive = [((NSNumber *)payload) boolValue];
        self.isRiver = isRiverActive;
        [[self.dataSource contentAtIndexPath:path] setBool:isRiverActive];
    };
    
    self.dataSource = [[TableViewContentDataSource alloc] init];
    
    GraphDataBlock soilQualityGraphDataBlock = ^(NSIndexPath *path) {
        GraphData *data = [[GraphData alloc] initWithLabel:@"Soil Quality"];
        data.type = GraphTypeLine;
        
        for (int i = 0; i < self.simulation.sampleCount; i++) {
            [data addValue:[NSNumber numberWithFloat:[self.simulation.soilQuality valueWithDelay:self.simulation.sampleCount - i - 1]] atIndex:i];
        }
        
        return data;
    };
    
    [self.dataSource setTitle:@"Soil Quality" forHeaderInSection:0];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Graph"
                                                           andGraphData:soilQualityGraphDataBlock]
                      inSection:0];
    ValueDataBlock soilQualityValueBlock = ^(NSIndexPath *path) {
        return [NSString stringWithFormat:@"%.2f", [self.simulation.soilQuality valueWithoutDelay]];
    };
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Value" andValueData:soilQualityValueBlock]
                      inSection:0];
    
    GraphDataBlock healthGraphDataBlock = ^(NSIndexPath *path) {
        GraphData *data = [[GraphData alloc] initWithLabel:@"Health"];
        data.type = GraphTypeLine;
        
        for (int i = 0; i < self.simulation.sampleCount; i++) {
            [data addValue:[NSNumber numberWithFloat:[self.simulation.health valueWithDelay:self.simulation.sampleCount - i - 1]] atIndex:i];
        }
        
        return data;
    };
    
    [self.dataSource setTitle:@"Health" forHeaderInSection:0];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Graph"
                                                           andGraphData:healthGraphDataBlock]
                      inSection:0];
    ValueDataBlock healthValueBlock = ^(NSIndexPath *path) {
        return [NSString stringWithFormat:@"%.2f", [self.simulation.health valueWithoutDelay]];
    };
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Value" andValueData:healthValueBlock]
                      inSection:0];
    
    [self.dataSource setTitle:@"deff" forHeaderInSection:2];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"is river"
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleSwitch
                                                              andAction:toggleIsRiverBlock]
                      inSection:2];
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:[NSString stringWithFormat:@"Turn %ld", (long)self.simulation.sampleCount]
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleNormal
                                                              andAction:nil]
                      inSection:2];
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
    
    [self.simulation calculate];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self.tableView reloadData];
}

@end
