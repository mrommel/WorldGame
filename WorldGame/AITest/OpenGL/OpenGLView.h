//
//  OpenGLView.h
//  SimWorld
//
//  Created by Michael Rommel on 04.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "CombatBoardMesh.h"

@class CombatBoard;

@interface OpenGLView : UIView<CombatBoardMeshDelegate> {
}

@property (nonatomic, retain) CombatBoard *board;

- (id)initWithBoard:(CombatBoard *)board;

- (void)setupDisplayLink;
- (void)detachDisplayLink;

@end
