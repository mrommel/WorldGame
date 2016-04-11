//
//  UINavigationController+BackButtonHandler.m
//  AITest
//
//  Created by Michael Rommel on 19.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "UINavigationController+BackButtonHandler.h"

@implementation UINavigationController(BackButtonHandler)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *topViewController = self.topViewController;
    BOOL wasBackButtonClicked = topViewController.navigationItem == item;
    SEL backButtonPressedSel = @selector(backButtonPressed);
    if (wasBackButtonClicked && [topViewController respondsToSelector:backButtonPressedSel]) {
        [topViewController performSelector:backButtonPressedSel];
        return NO;
    } else {
        [self popViewControllerAnimated:YES];
        return YES;
    }
}

@end
