//
//  UINavigationController+BackButtonHandler.h
//  AITest
//
//  Created by Michael Rommel on 19.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UINavigationControllerBackButtonDelegate <NSObject>
/**
 * Indicates that the back button was pressed.
 * If this message is implemented the pop logic must be manually handled.
 */
- (void)backButtonPressed;
@end

@interface UINavigationController(BackButtonHandler)
@end
