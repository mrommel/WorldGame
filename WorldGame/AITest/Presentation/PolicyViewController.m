//
//  MinistryViewController.m
//  AITest
//
//  Created by Michael Rommel on 06.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "PolicyViewController.h"

#import "ChartView.h"
#import "UIConstants.h"
#import "Policy.h"

@interface PolicyViewController ()

@property (nonatomic) ChartView *chartView;

@end

@implementation PolicyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.chartView = [[ChartView alloc] initWithFrame:CGRectMake(BU, BU8, DEVICE_WIDTH - BU2, BU8)];
    self.chartView.values = [self.policy stackedValues];
    [self.view addSubview:self.chartView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
