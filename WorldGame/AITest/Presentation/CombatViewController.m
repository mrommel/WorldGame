//
//  CombatViewController.m
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "CombatViewController.h"

@implementation CombatViewController

@synthesize glView=_glView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // At top of application:didFinishLaunchingWithOptions
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self.glView = [[OpenGLView alloc] initWithFrame:screenBounds];
        [self.view addSubview:_glView];
    }
    
    return self;
}

@end
