//
//  GameViewController.m
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GameViewController.h"

#import "UIConstants.h"
#import "Game.h"
#import "Simulation.h"
#import "OverlayView.h"
#import "RelationsNetwork.h"
#import "MinistryTableViewController.h"
#import "Policy.h"
#import "PolicyInfo.h"

#import "SCLAlertView.h"

@interface GameViewController ()

// views
@property (nonatomic) MapView *mapView;
@property (nonatomic) UILabel *turnLabel;
@property (nonatomic) UIButton *turnButton;
@property (nonatomic) UIButton *centerButton;
@property (nonatomic) OverlayView *overlay;

// objects
@property (atomic) BOOL ministriesShown;

@end

@implementation GameViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    // Update the user interface for the detail item.
    [self setupUI];
    
    // start game if needed
    [self startOrResumeGame];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // if the game has a name, use it
    if ([GameProvider sharedInstance].game != nil && [GameProvider sharedInstance].game.name != nil) {
        self.title = [GameProvider sharedInstance].game.name;
    } else {
        self.title = @"Game";
    }
    
    if (self.ministriesShown) {
        [self showActions:nil];
    }
}

- (void)setupUI
{
    self.mapView = [[MapView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT - STATUSBAR_HEIGHT)];
    self.mapView.delegate = self;
    self.mapView.showGrid = YES;
    self.mapView.showDebug = YES;
    [self.view addSubview:self.mapView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 60, DEVICE_WIDTH, 60)];
    bottomView.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f];
    
    self.turnLabel = [[UILabel alloc] initWithFrame:CGRectMake(BU, BU_HALF, DEVICE_WIDTH, BU2)];
    self.turnLabel.textColor = [UIColor whiteColor];
    self.turnLabel.text = [NSString stringWithFormat:@"Players: %lu / current: %d", (unsigned long)[GameProvider sharedInstance].game.players.count, [GameProvider sharedInstance].game.currentTurn];
    [bottomView addSubview:self.turnLabel];
    
    self.turnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.turnButton addTarget:self action:@selector(turnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.turnButton setTitle:@"Turn" forState:UIControlStateNormal];
    self.turnButton.frame = CGRectMake(BU, BU3, 80, BU2);
    [bottomView addSubview:self.turnButton];
    
    [self.view addSubview:bottomView];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerButton addTarget:self action:@selector(centerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerButton setImage:[UIImage imageNamed:@"center.png"] forState:UIControlStateNormal];
    self.centerButton.frame = CGRectMake(DEVICE_WIDTH - BU4, BU8, BU3, BU3);
    [self.view addSubview:self.centerButton];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                  target:self
                                                                  action:@selector(showActions:)];
    self.navigationItem.rightBarButtonItem = flipButton;
}

- (void)startOrResumeGame
{
    if ([GameProvider sharedInstance].game == nil) {
        Map *map = [[Map alloc] initWithMapSize:self.options.mapSize];
        
        self.overlay = [[OverlayView alloc] initWithFrame:CGRectZero];
        [self.overlay showProgressOnView:[[[UIApplication sharedApplication] delegate] window] title:@"create" info:@"" withDelegate:nil];
        [self.overlay startProgressAnimation];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [map generateMapWithOptions:self.options withProgress:^(int step) {
                NSLog(@"Created: %d/%d", step, 100);
                
                [self.overlay setInfoText:[NSString stringWithFormat:@"Created: %d%%", step]];
                
                if (step == 100) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //Update UI
                        [self.overlay dismiss];
                        
                        // update current label
                        self.turnLabel.text = [NSString stringWithFormat:@"Players: %lu / current: %d", (unsigned long)[GameProvider sharedInstance].game.players.count, [GameProvider sharedInstance].game.currentTurn];
                        
                        [GameProvider sharedInstance].game = [[Game alloc] initWithMap:map andNumberOfPlayers:2];
                        [GameProvider sharedInstance].game.delegate = self;
                        
                        [self.mapView setNeedsDisplay];
                    });
                }
            }];
        });
    } else {
        [GameProvider sharedInstance].game.delegate = self;
    }
    
    // update current label
    self.turnLabel.text = [NSString stringWithFormat:@"Players: %lu / current: %d", (unsigned long)[GameProvider sharedInstance].game.players.count, [GameProvider sharedInstance].game.currentTurn];
}

- (void)centerClicked:(id)sender
{
    NSLog(@"center");
    [self.mapView moveToX:0 andY:0];
}

- (void)backButtonPressed
{
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new];
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
        .style(Question)
        .title(@"Quit")
        .subTitle(@"Do you want to quit the game?")
        .duration(0);
    
    [builder.alertView addButton:@"Continue"
                     actionBlock:^(void) {
        NSLog(@"Continue");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [builder.alertView addButton:@"Save"
                     actionBlock:^(void) {
        NSLog(@"Save");
        [self saveGame];
    }];
    [builder.alertView addButton:@"Quit Game"
                     actionBlock:^(void) {
        NSLog(@"Game exited");
        [GameProvider sharedInstance].game = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
}

- (void)saveGame
{
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UITextField *textField = [alert addTextField:@"Enter your name"];
    
    [alert addButton:@"Save" actionBlock:^(void) {
        NSLog(@"Text value: %@", textField.text);
        [[GameProvider sharedInstance].game saveWithName:textField.text];
        [GameProvider sharedInstance].game = nil;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    
    [alert showEdit:self
              title:@"Game name"
           subTitle:@"What should be the name of the game?"
   closeButtonTitle:@"Cancel"
           duration:0.0f];
}

- (void)showActions:(id)sender
{
    NSLog(@"showActions");
    
    self.overlay = [[OverlayView alloc] initWithFrame:CGRectZero];
    [self.overlay showActionPickerOnView:[[[UIApplication sharedApplication] delegate] window]
                               withTitle:@""
                            withDelegate:self];
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(BU, BU * 3, DEVICE_WIDTH - BU2, BU2)];
    info.text = @"Council";
    info.textColor = COLOR_WHITE_A85;
    info.textAlignment = NSTextAlignmentCenter;
    [self.overlay.container addSubview:info];
    
    UIButton *btnOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnOne.frame = CGRectMake(BU, BU6, BU9, BU9);
    [btnOne setTitle:@"Finance" forState:UIControlStateNormal];
    [btnOne setBackgroundImage:[UIImage imageNamed:@"government.png"] forState:UIControlStateNormal];
    [btnOne addTarget:self action:@selector(goFinance:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlay.container addSubview:btnOne];
    
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnTwo.frame = CGRectMake(BU + BU9 + BU, BU6, BU9, BU9);
    [btnTwo setTitle:@"Chancellery" forState:UIControlStateNormal];
    [btnTwo setBackgroundImage:[UIImage imageNamed:@"government.png"] forState:UIControlStateNormal];
    [btnTwo addTarget:self action:@selector(goChancellery:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlay.container addSubview:btnTwo];
    
    UIButton *btnThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnThree.frame = CGRectMake(BU + BU9 + BU + BU9 + BU, BU6, BU9, BU9);
    [btnThree setTitle:@"Justice" forState:UIControlStateNormal];
    [btnThree setBackgroundImage:[UIImage imageNamed:@"government.png"] forState:UIControlStateNormal];
    [btnThree addTarget:self action:@selector(goJustice:) forControlEvents:UIControlEventTouchUpInside];
    [self.overlay.container addSubview:btnThree];
}

- (void)goFinance:(id)sender
{
    [self.overlay dismiss];
    
    MinistryTableViewController *viewController = [[MinistryTableViewController alloc] init];
    viewController.ministry = MinistryFinance;
    viewController.player = [[GameProvider sharedInstance].game humanPlayer];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)goChancellery:(id)sender
{
    [self.overlay dismiss];
    
    MinistryTableViewController *viewController = [[MinistryTableViewController alloc] init];
    viewController.ministry = MinistryChancellery;
    viewController.player = [[GameProvider sharedInstance].game humanPlayer];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)goJustice:(id)sender
{
    [self.overlay dismiss];
    
    MinistryTableViewController *viewController = [[MinistryTableViewController alloc] init];
    viewController.ministry = MinistryJustice;
    viewController.player = [[GameProvider sharedInstance].game humanPlayer];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)focusChanged:(MapPoint *)newFocus
{
    NSLog(@"new focus = %ld, %ld", (long)newFocus.x, (long)newFocus.y);
    if (![[GameProvider sharedInstance].game.map isValidAtX:newFocus.x andY:newFocus.y]) {
        return;
    }
    
    Plot *tile = [[GameProvider sharedInstance].game.map tileAtX:newFocus.x andY:newFocus.y];
    self.turnLabel.text = [NSString stringWithFormat:@"terrain %ld, pop: %d", (long)tile.terrain, (int)tile.inhabitants]; //[NSString stringWithFormat:@"%d, %d", newFocus.x, newFocus.y];
}

-(void)longPressChanged:(MapPoint *)newFocus
{
    NSLog(@"new long press = %ld, %ld", (long)newFocus.x, (long)newFocus.y);
    
    SCLAlertViewBuilder *builder = [SCLAlertViewBuilder new];
    
    SCLAlertViewShowBuilder *showBuilder = [SCLAlertViewShowBuilder new]
        .style(Info)
        .title(@"Help")
        .subTitle(@"Get more info on one these topics")
        .duration(0);
    
    [builder.alertView addButton:@"Second Button" actionBlock:^(void) {
        NSLog(@"Second button tapped");
    }];
    [builder.alertView addButton:@"Cancel" actionBlock:^(void) {
        NSLog(@"Cancel button tapped");
    }];
    
    [showBuilder showAlertView:builder.alertView onViewController:self];
}

- (void)turnClicked:(id)sender
{
    NSLog(@"Turn clicked");
    Game *game = [GameProvider sharedInstance].game;
    
    self.overlay = [[OverlayView alloc] initWithFrame:CGRectZero];
    [self.overlay showProgressOnView:[[[UIApplication sharedApplication] delegate] window] title:@"turn" info:@"" withDelegate:nil];
    [self.overlay startProgressAnimation];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [game turnWithProgress:^(NSString *title, int step, int steps) {
            NSLog(@"Turned: '%@' = %d/%d", title, step, steps);
            
            if (step == steps) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //Update UI
                    [self.overlay dismiss];
                    
                    // update current label
                    self.turnLabel.text = [NSString stringWithFormat:@"Players: %lu / current: %d", (unsigned long)[GameProvider sharedInstance].game.players.count, [GameProvider sharedInstance].game.currentTurn];
                });
            }
        }];
    });
}

- (void)cancelPressed:(id)sender
{
    NSLog(@"cancelPressed");
    [self.overlay dismiss];
}

#pragma mark -
#pragma mark GameDelegate functions

- (void)requestNeedsDisplay
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW,
                                            (int64_t)(0.005 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [self.mapView setNeedsDisplay];
    });
    
}

@end
