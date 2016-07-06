//
//  CombatViewController.m
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "CombatViewController.h"

#import "CombatBoardNode.h"
#import "UIBlockButton.h"
#import "UIConstants.h"

#import "TerrainNode.h"

@interface CombatViewController () {
}

@property (nonatomic, retain) CombatBoardNode *combatBoardNode;

@end

@implementation CombatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RELight *light = [REDirectionalLight light];
    [self.world addLight:light];
    
    // Board
    //self.combatBoardNode = [[CombatBoardNode alloc] initWithCombatBoard:self.combatBoard];
    //[self.world addChild:self.combatBoardNode];
    
    TerrainNode *terrainNode = [[TerrainNode alloc] init];
    [self.world addChild:terrainNode];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addZoomButtons];
}

- (void)addZoomButtons
{
    UIImage *buttonImage = [[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    __weak typeof(self) weakSelf = self;
    
    UIBlockButton *zoomInButton = [UIBlockButton buttonWithType:UIButtonTypeCustom];
    [zoomInButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [zoomInButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [zoomInButton handleControlEvent:UIControlEventTouchUpInside
                           withBlock:^{
                               NSLog(@"Zoom: +");
                               [weakSelf zoomIn];
                           }];
    [zoomInButton setTitle:@"+" forState:UIControlStateNormal];
    zoomInButton.frame = CGRectMake(BU, 48, BU2, BU2);
    [glView_ addSubview:zoomInButton];
    
    UIBlockButton *zoomOutButton = [UIBlockButton buttonWithType:UIButtonTypeCustom];
    [zoomOutButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [zoomOutButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [zoomOutButton handleControlEvent:UIControlEventTouchUpInside
                            withBlock:^{
                                NSLog(@"Zoom: -");
                                [weakSelf zoomOut];
                            }];
    [zoomOutButton setTitle:@"-" forState:UIControlStateNormal];
    zoomOutButton.frame = CGRectMake(BU, 76, BU2, BU2);
    [glView_ addSubview:zoomOutButton];
    
    UIBlockButton *centerButton = [UIBlockButton buttonWithType:UIButtonTypeCustom];
    [centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [centerButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [centerButton handleControlEvent:UIControlEventTouchUpInside
                           withBlock:^{
                               NSLog(@"Center");
                               [weakSelf center];
                           }];
    [centerButton setTitle:@"C" forState:UIControlStateNormal];
    centerButton.frame = CGRectMake(BU, 104, BU2, BU2);
    [glView_ addSubview:centerButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.combatBoardNode = nil;
}

@end
