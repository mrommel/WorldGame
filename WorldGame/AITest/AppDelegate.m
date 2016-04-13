//
//  AppDelegate.m
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "AppDelegate.h"

#import "UILabel+Custom.h"
#import "MainMenuViewController.h"
#include <time.h>
#include <stdlib.h>
#import "UIConstants.h"

#import "Game.h"
#import "PolicyInfo.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    srand((unsigned int)time(NULL));
    
    [PolicyInfoProvider sharedInstance];
    
    [[UILabel appearance] setSubstituteFontName:@"Tele-GroteskNor"];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = COLOR_MIRO_BLACK;
    
    MainMenuViewController *viewController = [[MainMenuViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigation;
    
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
 
    // do autosave if game is active
    if ([GameProvider sharedInstance].game != nil) {
        [[GameProvider sharedInstance].game saveWithName:@"Autosave"];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
