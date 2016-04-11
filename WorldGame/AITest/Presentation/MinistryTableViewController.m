//
//  MinistryViewController.m
//  AITest
//
//  Created by Michael Rommel on 05.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MinistryTableViewController.h"

#import "RelationsNetwork.h"
#import <CorePlot/CorePlot.h>
#import "PolicyViewController.h"

@interface MinistryTableViewController ()

@property (nonatomic) NSArray *policies;

@end

@implementation MinistryTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)configureView
{
    self.policies = [self.player policiesForMinistry:self.ministry];
    
    switch (self.ministry) {
        case MinistryChancellery:
            self.title = @"Ministry Chancellery";
            break;
        case MinistryFinance:
            self.title = @"Ministry Finance";
            break;
        case MinistryJustice:
            self.title = @"Ministry Justice";
            break;
        default:
            self.title = @"Ministry";
            break;
    }
    
    /*for (Policy *policy in self.policies) {
        
    }*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.policies.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MinistryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Policy *policy = [self.policies objectAtIndex:indexPath.row];
    cell.textLabel.text = policy.name;
    cell.detailTextLabel.text = policy.desc;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 3;  // 0 means no max.

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PolicyViewController *viewController = [[PolicyViewController alloc] init];
    viewController.policy = [self.policies objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
