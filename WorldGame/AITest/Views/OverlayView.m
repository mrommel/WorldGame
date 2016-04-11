//
//  OverlayView.m
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "OverlayView.h"

#import "UIConstants.h"
#import "UIButton+Custom.h"
#import "NSString+Custom.h"

#define SAFECOLOR(color) MIN(255,MAX(0,color))

@interface OverlayView() {
    
    NSTimer *_overlayTimer;
    int _secondsToGo;
}

@property (nonatomic, retain) NSTimer *overlayTimer;
@property (atomic) int secondsToGo;

-(void)applicationDidEnterBackground;
-(void)applicationWillEnterForeground;
-(void)doStartAnimation;
-(void)doStopAnimation;
-(void)setup;
+(OverlayView*)create;

@end

@implementation OverlayView

@synthesize cancelButton = _cancelButton;
@synthesize isAnimating = _isAnimating;
@synthesize titleLabel = _titleLabel;
@synthesize infoLabel = _infoLabel;
@synthesize timerLabel = _timerLabel;
@synthesize imageView = _imageView;
@synthesize container = _container;
@synthesize spinnerImageView = _spinnerImageView;
@synthesize delegate = _delegate;
@synthesize overlayTimer = _overlayTimer;
@synthesize secondsToGo = _secondsToGo;

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [OverlayView create];
    if (self) {
        [self setup];
        self.secondsToGo = 0;
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    self.spinnerImageView = nil;
    self.infoLabel = nil;
    self.titleLabel = nil;
    self.imageView = nil;
    self.container = nil;
    self.cancelButton = nil;
    self.delegate = nil;
    self.overlayTimer = nil;
    self.secondsToGo = 0;
    self.timerLabel = nil;
}

- (void)willMoveToSuperview: (UIView *)newSuperview
{
    self.alpha = 0;
    
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview
{
    [UIView animateWithDuration: .2 animations: ^(void){
        self.alpha = 1;
    }];
    [super didMoveToSuperview];
}

-(void)removeFromSuperview
{
    [UIView animateWithDuration: .2 animations: ^(void) {
        self.alpha = 0;
    } completion: ^(BOOL finished) {
        [super removeFromSuperview];
        if(self.delegate && [self.delegate respondsToSelector: @selector(dismissComplete:)]) {
            [self.delegate dismissComplete: self];
        }
        self.delegate = nil;
    }];
}

-(void)applicationDidEnterBackground
{
    if(self.isAnimating) {
        [self doStopAnimation];
    }
}

-(void)applicationWillEnterForeground
{
    if(self.isAnimating) {
        [self doStartAnimation];
    }
}

#pragma mark -
#pragma mark - TSOverlayView

-(void) setup
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    SETX(self.imageView, DEVICE_WIDTH * 3 / 8);
    SETY(self.imageView, DEVICE_HEIGHT / 4);
    SETWIDTH(self.imageView, DEVICE_WIDTH / 4);
    SETHEIGHT(self.imageView, DEVICE_WIDTH / 4);
    
    SETX(self.spinnerImageView, DEVICE_WIDTH * 3 / 8);
    SETY(self.spinnerImageView, DEVICE_HEIGHT / 4);
    SETWIDTH(self.spinnerImageView, DEVICE_WIDTH / 4);
    SETHEIGHT(self.spinnerImageView, DEVICE_WIDTH / 4);
    
    SETY(self.titleLabel, GETBOTTOM(self.imageView) + BU);
    
    [self.cancelButton setupAsOverlayButtonWithText:NSLocalizedString(@"cancel",nil)];
    self.cancelButton.alpha = 0;
    self.cancelButton.userInteractionEnabled = NO;
    SETX(self.cancelButton, DEVICE_WIDTH / 3);
    SETY(self.cancelButton, DEVICE_HEIGHT * 2 / 3);
    SETWIDTH(self.cancelButton, DEVICE_WIDTH / 3);
    
    self.container.backgroundColor = COLOR_BLACK_A85;
    [self addSubview: self.container];
}

- (void)setTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.titleLabel isKindOfClass:[UILabel class]]) {
            ((UILabel *)self.titleLabel).text = title;
            SETY(self.titleLabel, DEVICE_HEIGHT / 2);
        }
    });
}

-(void) setInfoText: (NSString*) text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.infoLabel isKindOfClass:[UILabel class]]) {
            ((UILabel*)self.infoLabel).text = text;
            SETY(self.infoLabel, DEVICE_HEIGHT * 3 / 5);
        }
    });
}

- (void)setTimerText:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* t = [text copy];
        /*if(![text isEmpty]) {
            t = [NSString stringWithFormat: @"Fertig in ca.%@", text];
        }*/
        
        if ([self.timerLabel isKindOfClass:[UILabel class]]) {
            ((UILabel*)self.timerLabel).text = t;
        }
    });
}

- (void)setImage:(UIImage*)image
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView setImage:image];
    });
}

#pragma mark -
#pragma mark - IOverlayView

- (void)showProgressOnView:(UIView*)view title:(NSString*)title info:(NSString*)info withDelegate:(id<IOverlayDelegate>)delegate
{
    self.delegate = delegate;
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    if (self.superview != view) {
        [view addSubview:self];
    }
    
    if (!delegate) {
        _cancelButton.alpha = 0;
        _cancelButton.userInteractionEnabled = NO;
    } else {
        self.cancelButton.alpha = 1;
        self.cancelButton.userInteractionEnabled = YES;
    }
    
    [self setImage:nil];
    [self setTitle:title];
    [self setInfoText:info];
    [self setTimerText:@""];
}

- (void)showProgressOnView:(UIView*)view title:(NSString*)title info:(NSString*)info withDelegate:(id<IOverlayDelegate>)delegate andTimer:(int)secondsToGo
{
    [self showProgressOnView:view
                       title:title
                        info:info
                withDelegate:delegate];
    
    self.secondsToGo = secondsToGo;
    
    [self setTimerText:[NSString formatTimeDistance:self.secondsToGo]];
    
    // start timer
    [self startTimer];
}

- (void)showActionPickerOnView:(UIView*)view withTitle:(NSString*)title withDelegate:(id<IOverlayDelegate>)delegate
{
    self.delegate = delegate;
    self.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    if(self.superview != view) {
        [view addSubview:self];
    }
    
    if(self.delegate) {
        self.cancelButton.alpha = 1;
        self.cancelButton.userInteractionEnabled = YES;
    }
    
    [self setImage:nil];
    [self setTitle:title];
    [self setInfoText:@""];
    [self setTimerText:@""];
}

- (void)addAction:(int)action
{
    
}

-(void)startTimer
{
    self.overlayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:NO];
}

-(void)updateTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.secondsToGo <= 0) {
            self.secondsToGo = 0;
            [self setTimerText: @""];
            
            if(self.overlayTimer) {
                [self.overlayTimer invalidate];
                self.overlayTimer = nil;
            }
        } else {
            self.secondsToGo--;
            [self setTimerText: [NSString formatTimeDistance: self.secondsToGo]];
            
            if(self.overlayTimer) {
                [self.overlayTimer invalidate];
                self.overlayTimer = nil;
            }
            
            // start timer
            [self startTimer];
        }
    });
}

- (void)doStartAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spinnerImageView.alpha = 1;
        CABasicAnimation* spinAnimation = [CABasicAnimation
                                           animationWithKeyPath: @"transform.rotation"];
        spinAnimation.toValue = [NSNumber numberWithFloat: 5 * 2 * M_PI];
        spinAnimation.duration = 5;
        spinAnimation.repeatCount = HUGE_VALF;
        [self.spinnerImageView.layer addAnimation: spinAnimation forKey: @"spinAnimation"];
    });
}

- (void)doStopAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spinnerImageView.alpha = 0;
        [self.spinnerImageView.layer removeAllAnimations];
    });
}

- (void)startProgressAnimation
{
    _isAnimating = YES;
    
    if(self.delegate){
        self.cancelButton.alpha = 1;
        self.cancelButton.userInteractionEnabled = YES;
    }
    
    [self doStartAnimation];
}

- (void)stopProgressAnimation
{
    _isAnimating = NO;
    self.cancelButton.alpha = 0;
    self.cancelButton.userInteractionEnabled = NO;
    
    // cancel timer
    self.secondsToGo = 0;
    [self updateTimer];
    
    [self doStopAnimation];
}

- (void)startWithoutAnimation
{
    if(self.delegate) {
        self.cancelButton.alpha = 1;
        self.cancelButton.userInteractionEnabled = YES;
    }
}

- (IBAction)didPressCancel:(id)sender
{
    [self.delegate cancelPressed:sender];
}

- (void)forceDismiss
{
    [self dismiss];
}

- (void)dismiss
{
    [self removeFromSuperview];
    self.secondsToGo = 0;
}

+ (OverlayView*)create
{
    NSArray* views = [[NSBundle mainBundle] loadNibNamed: @"OverlayView" owner: self options: nil];
    return [views objectAtIndex: 0];
}

@end
