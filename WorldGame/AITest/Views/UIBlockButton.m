//
//  UIBlockButton.m
//  WorldGame
//
//  Created by Michael Rommel on 01.07.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "UIBlockButton.h"

@implementation UIBlockButton

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action
{
    _actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _actionBlock();
}

@end
