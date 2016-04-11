//
//  AboutViewController.m
//  AITest
//
//  Created by Michael Rommel on 11.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AboutViewController.h"

#import "UIConstants.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"About";
    
    // content
    // SCLAlertView: https://github.com/dogo/SCLAlertView/blob/master/LICENSE
    UILabel *aboutLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, BU2, DEVICE_WIDTH, DEVICE_HEIGHT - BU2)];
    aboutLbl.text = @"SCLAlertView:\nhttps://github.com/dogo/SCLAlertView/blob/master/LICENSE\n\n";
    aboutLbl.numberOfLines = 0;
    aboutLbl.textColor = COLOR_WHITE;
    aboutLbl.backgroundColor = COLOR_MIRO_BLACK;
    [self.view addSubview:aboutLbl];
}


@end
