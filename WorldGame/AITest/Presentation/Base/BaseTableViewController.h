//
//  BaseTableViewController.h
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(NSIndexPath *indexPath);

@interface TableViewContent : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) UIImage *image;
@property (nonatomic, copy) ActionBlock action;

- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andAction:(ActionBlock)action;
- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andImage:(UIImage *)image andAction:(ActionBlock)action;

@end

@protocol TableViewContentSource <NSObject>

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface BaseTableViewController : UITableViewController



@end
