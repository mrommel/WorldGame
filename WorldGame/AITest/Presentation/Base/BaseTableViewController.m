//
//  BaseTableViewController.m
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "BaseTableViewController.h"

#import "UIConstants.h"

#define SECTION_KEY(section)    [NSString stringWithFormat:@"SECTION_%ld", section]
#define kSectionHeaderHeight    36

@interface TableViewContent()

@property (nonatomic) NSObject *payload;

@end

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

- (void)setBool:(BOOL)boolValue
{
    self.payload = [NSNumber numberWithBool:boolValue];
}

- (BOOL)boolValue
{
    if (self.payload) {
        return [((NSNumber *)self.payload) boolValue];
    }
    
    return NO;
}

- (void)setNumber:(NSInteger)integerValue
{
    self.payload = [NSNumber numberWithInteger:integerValue];
}

- (NSInteger)integerValue
{
    if (self.payload) {
        return [((NSNumber *)self.payload) integerValue];
    }
    
    return 0;
}

@end

#pragma mark -

@interface TableViewContentDataSource()

@property (nonatomic) NSMutableDictionary *headers;
@property (nonatomic) NSMutableDictionary *contents;

@end

@implementation TableViewContentDataSource

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.contents = [[NSMutableDictionary alloc] init];
        self.headers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (NSInteger)numberOfSections
{
    return [self.contents count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return [[self.contents objectForKey:SECTION_KEY(section)] count];
}

- (void)setTitle:(NSString *)title forHeaderInSection:(NSInteger)section
{
    [self.headers setObject:title forKey:SECTION_KEY(section)];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section
{
    return [self.headers objectForKey:SECTION_KEY(section)];
}

- (void)addContent:(TableViewContent *)content inSection:(NSInteger)section
{
    if ([self.contents objectForKey:SECTION_KEY(section)] == nil) {
        [self.contents setObject:[[NSMutableArray alloc] init] forKey:SECTION_KEY(section)];
    }
    
    [[self.contents objectForKey:SECTION_KEY(section)] addObject:content];
}

- (void)insertContent:(TableViewContent *)content atIndex:(NSInteger)index inSection:(NSInteger)section
{
    if ([self.contents objectForKey:SECTION_KEY(section)] == nil) {
        [self.contents setObject:[[NSMutableArray alloc] init] forKey:SECTION_KEY(section)];
    }
    
    [[self.contents objectForKey:SECTION_KEY(section)] insertObject:content atIndex:index];
}

- (void)insertContent:(TableViewContent *)content atIndexPath:(NSIndexPath *)indexPath
{
    [self insertContent:content atIndex:indexPath.row inSection:indexPath.section];
}

- (TableViewContent *)contentAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    return [[self.contents objectForKey:SECTION_KEY(section)] objectAtIndex:index];
}

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.contents objectForKey:SECTION_KEY(indexPath.section)] objectAtIndex:indexPath.row];
}

@end

#pragma mark -

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_MIRO_BLACK;
    self.tableView.backgroundColor = COLOR_MIRO_BLACK;
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

- (void)setNavigationRightButtonWithImage:(UIImage *)image action:(SEL)action
{
    self.navigationItem.rightBarButtonItem.action = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:action];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource) {
        return [self.dataSource numberOfSections];
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataSource && [self.dataSource numberOfSections] > 1) {
        return kSectionHeaderHeight;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kSectionHeaderHeight)];
    [view setBackgroundColor:COLOR_MIRO_SAND];
    
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, kSectionHeaderHeight)];
    [label setFont:[UIFont boldSystemFontOfSize:18]];
    if (self.dataSource) {
        [label setText:[self.dataSource titleForHeaderInSection:section]];
    } else {
        [label setText:@"title"];
    }
    [view addSubview:label];
    
    return view;
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
        // check if vc is the data source
        content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
    } else if (self.dataSource) {
        // maybe we have a data source attached
        content = [self.dataSource contentAtIndexPath:indexPath];
    } else {
        // fallback
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
        case ContentStyleSwitch:
            cellBackView.image = [UIImage imageNamed:@"menu-item-normal.png"];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            
            UISwitch *uiswitch = [[UISwitch alloc] init];
            [uiswitch setOn:[content boolValue]];
            uiswitch.tintColor = [UIColor blackColor];
            uiswitch.tag = indexPath.section * 1000 + indexPath.row;
            [uiswitch addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = uiswitch;
            break;
    }
    
    cell.backgroundView = cellBackView;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = content.title;
    cell.detailTextLabel.text = content.subtitle;
    cell.imageView.image = content.image;
    
    return cell;
}

- (void)toggleChanged:(UISwitch *)uiswitch
{
    NSLog(@"toggled: %d, tag: %ld", uiswitch.isOn, (long)uiswitch.tag);
    
    NSInteger row = uiswitch.tag % 1000;
    NSInteger section = uiswitch.tag / 1000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    if ([self respondsToSelector:@selector(contentAtIndexPath:)]) {
        TableViewContent *content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
        
        if (content.action != nil) {
            content.action(indexPath, [NSNumber numberWithBool:uiswitch.isOn]);
        }
    } else if (self.dataSource) {
        TableViewContent *content = [self.dataSource contentAtIndexPath:indexPath];
        
        if (content.action != nil) {
            content.action(indexPath, [NSNumber numberWithBool:uiswitch.isOn]);
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self respondsToSelector:@selector(contentAtIndexPath:)]) {
        TableViewContent *content = [self performSelector:@selector(contentAtIndexPath:) withObject:indexPath];
        
        if (content.action != nil) {
            content.action(indexPath, nil);
        }
    } else if (self.dataSource) {
        TableViewContent *content = [self.dataSource contentAtIndexPath:indexPath];
        
        if (content.action != nil) {
            content.action(indexPath, nil);
        }
    }
}

@end
