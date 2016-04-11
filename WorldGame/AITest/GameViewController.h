//
//  GameViewController.h
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapOptions;

#import "MapView.h"
#import "OverlayView.h"
#import "UINavigationController+BackButtonHandler.h"

@interface GameViewController : UIViewController<MapViewDelegate, IOverlayDelegate, UINavigationControllerBackButtonDelegate>

@property (nonatomic) MapOptions *options;

@end

