//
//  BaseTableViewController.h
//  AITest
//
//  Created by Michael Rommel on 22.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)(NSIndexPath *indexPath, NSObject *payload);
typedef void (^ActionRowBlock)(UITableViewRowAction *action, NSIndexPath *indexPath);

#pragma mark -

/*!
 type of grand strategy
 */
typedef NS_ENUM(NSInteger, ContentStyle) {
    ContentStyleNormal,
    ContentStyleHighlighted,
    ContentStyleDisabled,
    ContentStyleSwitch
};

#pragma mark -

/*!
 content of list entries
 */
@interface TableViewContent : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) UIImage *image;
@property (atomic) ContentStyle style;
@property (nonatomic, copy) ActionBlock action;

- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andAction:(ActionBlock)action;
- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andImage:(UIImage *)image andAction:(ActionBlock)action;
- (instancetype)initWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle andStyle:(ContentStyle)style andAction:(ActionBlock)action;

- (void)setBool:(BOOL)boolValue;
- (void)setNumber:(NSInteger)integerValue;

@end

#pragma mark -

@protocol TableViewContentSource <NSObject>

- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@interface TableViewContentDataSource : NSObject<TableViewContentSource>

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (void)setTitle:(NSString *)title forHeaderInSection:(NSInteger)section;
- (NSString *)titleForHeaderInSection:(NSInteger)section;

- (void)addContent:(TableViewContent *)content inSection:(NSInteger)section;
- (void)insertContent:(TableViewContent *)content atIndex:(NSInteger)index inSection:(NSInteger)section;
- (void)insertContent:(TableViewContent *)content atIndexPath:(NSIndexPath *)indexPath;

- (TableViewContent *)contentAtIndex:(NSInteger)index inSection:(NSInteger)section;
- (TableViewContent *)contentAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark -

@interface BaseTableViewController : UITableViewController<UITableViewDelegate>

@property (nonatomic) TableViewContentDataSource* dataSource; // can be null, in this case the vc should implement TableViewContentSource

- (void)setNavigationRightButtonWithImage:(UIImage *)image action:(SEL)action;

@end
