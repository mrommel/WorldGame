//
//  DebugViewController.m
//  AITest
//
//  Created by Michael Rommel on 11.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "DebugViewController.h"

#import "UIConstants.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Debug";
    
    UILabel *debugLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, BU2, DEVICE_WIDTH, DEVICE_HEIGHT - BU2)];
    debugLbl.text = @"1) Load / Save games\n\n2) Zoom Map\n\n3)";
    debugLbl.numberOfLines = 0;
    debugLbl.textColor = COLOR_WHITE;
    debugLbl.backgroundColor = COLOR_MIRO_BLACK;
    [self.view addSubview:debugLbl];
}

@end