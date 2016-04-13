//
//  UILabel+Custom.m
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

- (void)setSubstituteFontName:(NSString *)name UI_APPEARANCE_SELECTOR
{
    self.font = [UIFont fontWithName:name size:self.font.pointSize];
}

@end
