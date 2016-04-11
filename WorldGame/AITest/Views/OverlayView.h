//
//  OverlayView.h
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IOverlayDelegate <NSObject>
- (void)cancelPressed:(id)sender;

@optional
- (void)dismissComplete:(id)sender;
- (void)pickAction:(int)action fromSender:(id)sender;

@end

/*!
 overlay
 */
@interface OverlayView : UIView

@property (nonatomic, assign, readonly) BOOL isAnimating;
@property (nonatomic, retain) IBOutlet UIView* container;
@property (nonatomic, retain) IBOutlet UIView* titleLabel;
@property (nonatomic, retain) IBOutlet UIView* infoLabel;
@property (nonatomic, retain) IBOutlet UIView* timerLabel;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UIImageView* spinnerImageView;
@property (nonatomic, retain) IBOutlet UIButton* cancelButton;
@property (nonatomic, retain) id<IOverlayDelegate> delegate;

- (void)showProgressOnView:(UIView*)view title:(NSString*)title info:(NSString*)info withDelegate:(id<IOverlayDelegate>)delegate;
- (void)showProgressOnView:(UIView*)view title:(NSString*)title info:(NSString*)info withDelegate:(id<IOverlayDelegate>)delegate andTimer:(int)secondsToGo;
- (void)showActionPickerOnView:(UIView*)view withTitle:(NSString*)title withDelegate:(id<IOverlayDelegate>)delegate;

- (void)addAction:(int)action;

- (void)forceDismiss;
- (void)dismiss;
- (void)setImage:(UIImage*)image;
- (void)setTitle:(NSString*)title;
- (void)setInfoText:(NSString*)info;
- (void)setTimerText:(NSString*)text;

- (void)startProgressAnimation;
- (void)stopProgressAnimation;
- (void)startWithoutAnimation;

@end
