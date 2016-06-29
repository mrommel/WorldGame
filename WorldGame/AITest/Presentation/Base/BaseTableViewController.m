//
//  BaseTableViewController.m
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "BaseTableViewController.h"

#import "UIConstants.h"

@implementation TableViewContent

- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andAction:(ActionBlock)action
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.style = ContentStyleNormal;
        self.action = action;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andImage:(UIImage *)image andAction:(ActionBlock)action
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.style = ContentStyleNormal;
        self.image = image;
        self.action = action;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andStyle:(ContentStyle)style andAction:(ActionBlock)action
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.subtitle = subtitle;
        self.style = style;
        self.action = action;
    }
    
    return self;
}

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_MIRO_BLACK;
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
    //self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // header
    UIImage *headerImage = [UIImage imageNamed:@"menu-header.png"];
    UIImageView *headerView = [[UIImageView alloc] initWithImage:headerImage];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 100);
    self.tableView.tableHeaderView = headerView;
    
    // footer
    UIImage *footerImage = [UIImage imageNamed:@"menu-footer.png"];
    UIImageView *footerView = [[UIImageView alloc] initWithImage:footerImage];
    footerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, 70);
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [NSString stringWithFormat:@"%@Cell", [[self class] description] ];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:className];
    }
    
    // Configure the cell...
    TableViewContent *content = nil;
    
    if ([self respondsToSelector:@selector(contentAtIndexPath:)]) {
        content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
    } else {
        content = [[TableViewContent alloc] initWithTitle:@"title" andSubtitle:@"subtitle" andAction:nil];
    }
    
    UIImageView *cellBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    cellBackView.backgroundColor = COLOR_MIRO_BLACK;
    switch (content.style)
    {
        case ContentStyleNormal:
            cellBackView.image = [UIImage imageNamed:@"menu-item-normal.png"];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            break;
        case ContentStyleHighlighted:
            cellBackView.image = [UIImage imageNamed:@"menu-item-highlighted.png"];
            cell.textLabel.textColor = [UIColor yellowColor];
            cell.detailTextLabel.textColor = [UIColor yellowColor];
            break;
        case ContentStyleDisabled:
            cellBackView.image = [UIImage imageNamed:@"menu-item-disabled.png"];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            break;
    }
    
    cell.backgroundView = cellBackView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = content.title;
    cell.detailTextLabel.text = content.subtitle;
    cell.imageView.image = content.image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self respondsToSelector:@selector(contentAtIndexPath:)]) {
        TableViewContent *content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
        
        if (content.action != nil) {
            content.action(indexPath);
        }
    }
}

@end
