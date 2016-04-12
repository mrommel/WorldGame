//
//  LoadGameViewController.m
//  WorldGame
//
//  Created by Michael Rommel on 11.04.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "LoadGameViewController.h"

#import "UIConstants.h"
#import "Game.h"
#import "GamePersistance.h"
#import "OverlayView.h"
#import "GameViewController.h"

@interface LoadGameViewController ()

@property (nonatomic) NSMutableArray *games;

@property (nonatomic) OverlayView *overlay;

@end

@implementation LoadGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Load Game";
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // update entries
    self.games = [GamePersistance loadGames];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.games.count;
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    Game *game = [self.games objectAtIndex:indexPath.row];
    
    return [[TableViewContent alloc] initWithTitle:game.name
                                       andSubtitle:[NSString stringWithFormat:@"date: %@", game.date]
                                         andAction:^(NSIndexPath *indexPath) {
                                             [GameProvider sharedInstance].game = game;
                                             /*self.overlay = [[OverlayView alloc] initWithFrame:CGRectZero];
                                             [self.overlay showProgressOnView:[[[UIApplication sharedApplication] delegate] window] title:@"load" info:@"" withDelegate:nil];
                                             [self.overlay startProgressAnimation];*/
                                             
                                                     GameViewController *viewcontroller = [[GameViewController alloc] init];
                                                     [self.navigationController pushViewController:viewcontroller animated:YES];
                                                }];
    
}

@end
