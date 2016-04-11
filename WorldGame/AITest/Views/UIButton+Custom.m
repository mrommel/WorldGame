//
//  UIButton+Custom.m
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "UIButton+Custom.h"

#import "UIConstants.h"

@implementation UIButton(Custom)

- (void)setupAsOverlayButtonWithText:(NSString *)text
{
    self.titleLabel.text = text;
    
    // due to ipad
    SETX(self, BU);
    SETWIDTH(self, DEVICE_WIDTH-BU2);
    
    SETY(self, DEVICE_HEIGHT / 3);
    PRINTFRAME(@"setupAsOverlayButtonWithText", self);
}

@end
