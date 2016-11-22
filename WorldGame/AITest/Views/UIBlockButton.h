//
//  UIBlockButton.h
//  WorldGame
//
//  Created by Michael Rommel on 01.07.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonActionBlock)();

@interface UIBlockButton : UIButton {
    ButtonActionBlock _actionBlock;
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ButtonActionBlock) action;

@end
