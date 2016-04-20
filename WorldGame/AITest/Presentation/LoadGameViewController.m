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
#import "DateUtils.h"

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
    
    ActionBlock loadGame = ^(NSIndexPath *indexPath) {
        Game *game = [self.games objectAtIndex:indexPath.row];
        [GameProvider sharedInstance].game = game;
        
        GameViewController *viewcontroller = [[GameViewController alloc] init];
        [self.navigationController pushViewController:viewcontroller animated:YES];
    };
    
    return [[TableViewContent alloc] initWithTitle:game.name
                                       andSubtitle:[NSString stringWithFormat:@"Saved: %@", [DateUtils longStringFromDate:game.date]]
                                          andImage:game.map.thumbnail
                                         andAction:loadGame];
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionRowBlock deleteBlock = ^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Game *game = [self.games objectAtIndex:indexPath.row];
        [game delete];
        [self.games removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    
    UITableViewRowAction *btnDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Delete" handler:deleteBlock];
    btnDelete.backgroundColor = COLOR_MIRO_RED;
    
    return @[btnDelete];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
