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

typedef CGFloat (^ValueBlock)(NSInteger delay);

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
    
    
    self.dataSource = [[TableViewContentDataSource alloc] init];
    
    weakify(self);
    
    // ///////////////////
    [self.dataSource setTitle:@"Policies" forHeaderInSection:0];
    ActionBlock propertyTaxBlock = ^(NSIndexPath *path, NSObject *payload) {
        NSInteger sliderValue = [((NSNumber *)payload) integerValue];
        [weakSelf.simulation.propertyTax setValue:(CGFloat)sliderValue / 10];
        [[self.dataSource contentAtIndexPath:path] setInteger:sliderValue];
    };
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Property Tax"
                                                            andSubtitle:@""
                                                               andStyle:ContentStyleSlider
                                                              andAction:propertyTaxBlock]
                      inSection:0];
    [self addGraphWithTitle:@"Property Tax" andValueBlock:^(NSInteger delay) {
        return [weakSelf.simulation.propertyTax valueWithDelay:delay];
    } inSection:0];

    // ///////////////////
    [self.dataSource setTitle:@"Simulations" forHeaderInSection:1];
    [self addGraphWithTitle:@"Soil Quality" andValueBlock:^(NSInteger delay) {
        return [weakSelf.simulation.soilQuality valueWithDelay:delay];
    } inSection:1];
    [self addGraphWithTitle:@"Health" andValueBlock:^(NSInteger delay) {
        return [weakSelf.simulation.health valueWithDelay:delay];
    } inSection:1];
    [self addGraphWithTitle:@"Food safety" andValueBlock:^(NSInteger delay) {
        return [weakSelf.simulation.foodSafety valueWithDelay:delay];
    } inSection:1];
    [self addGraphWithTitle:@"Poverty" andValueBlock:^(NSInteger delay) {
        return [weakSelf.simulation.poverty valueWithDelay:delay];
    } inSection:1];
    // ///////////////////
    
    [self.dataSource setTitle:@"Misc" forHeaderInSection:2];
    ActionBlock toggleIsRiverBlock = ^(NSIndexPath *path, NSObject *payload) {
        BOOL isRiverActive = [((NSNumber *)payload) boolValue];
        self.isRiver = isRiverActive;
        [[self.dataSource contentAtIndexPath:path] setBool:isRiverActive];
    };
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

- (void)addGraphWithTitle:(NSString *)title andValueBlock:(ValueBlock)valueBlock inSection:(NSInteger)section
{
    GraphDataBlock healthGraphDataBlock = ^(NSIndexPath *path) {
        GraphData *data = [[GraphData alloc] initWithLabel:title];
        data.type = GraphTypeLine;
        
        for (int i = 0; i < self.simulation.sampleCount; i++) {
            [data addValue:[NSNumber numberWithFloat:valueBlock(self.simulation.sampleCount - i - 1)] atIndex:i];
        }
        
        return data;
    };
    
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:title
                                                           andGraphData:healthGraphDataBlock]
                      inSection:section];
    ValueDataBlock healthValueBlock = ^(NSIndexPath *path) {
        return [NSString stringWithFormat:@"%.2f", valueBlock(0)];
    };
    [self.dataSource addContent:[[TableViewContent alloc] initWithTitle:@"Value" andValueData:healthValueBlock]
                      inSection:section];
}

- (BOOL)isRiver
{
    return self.isRiverValue;
}

- (void)setIsRiver:(BOOL)isRiverValue
{
    self.isRiverValue = isRiverValue;
}

- (void)handleRefreshNavigationBarItem:(UIBarButtonItem *)sender
{
    NSLog(@"refresh");
    
    [self.simulation calculate];
    
    [self.tableView reloadData];
}

@end
