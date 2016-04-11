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
        self.image = image;
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
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *myImage = [UIImage imageNamed:@"menu-header.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0, 0, 320, 100);
    return imageView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 70;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImage *myImage = [UIImage imageNamed:@"menu-footer.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0, 0, 320, 70);
    return imageView;
}

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
    
    UIImageView *cellBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    cellBackView.backgroundColor = [UIColor clearColor];
    cellBackView.image = [UIImage imageNamed:@"menu-item.png"];
    cell.backgroundView = cellBackView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    TableViewContent *content = nil;
    
    if ([self respondsToSelector:@selector(contentAtIndexPath:)]) {
        content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
    } else {
        content = [[TableViewContent alloc] initWithTitle:@"title" andSubtitle:@"subtitle" andAction:nil];
    }
    
    cell.textLabel.text = content.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = content.subtitle;
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = content.image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self respondsToSelector:@selector(contentAtIndexPath:)]) {
        TableViewContent *content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
        content.action(indexPath);
    }
}

@end
