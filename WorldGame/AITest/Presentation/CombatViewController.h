//
//  CombatViewController.h
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenGLView.h"

@interface CombatViewController : UIViewController {
    OpenGLView* _glView;
}

@property (nonatomic, retain) IBOutlet OpenGLView *glView;

@end
