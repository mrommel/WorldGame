//
//  AppDelegate.h
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class GameViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Property window
@property (strong, nonatomic) UIWindow *window;

// Property Viewcontroller

@property (strong, nonatomic) GameViewController *viewController;

@end

