//
//  UIBlockButton.h
//  WorldGame
//
//  Created by Michael Rommel on 01.07.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

@interface UIBlockButton : UIButton {
    ActionBlock _actionBlock;
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action;

@end
