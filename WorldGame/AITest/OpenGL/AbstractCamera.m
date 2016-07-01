//
//  AbstractCamera.m
//  SimWorld
//
//  Created by Michael Rommel on 02.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "AbstractCamera.h"

@implementation AbstractCamera

- (id)init
{
    self = [super init];
    
    if (self) {
        [self generatePerspectiveProjectionMatrixFromFieldOfView:45.0f];
    }
    
    return self;
}

- (void)generatePerspectiveProjectionMatrixFromFieldOfView:(GLfloat)fieldOfView
{
    // Get the size of the screen
    CGRect winRect = [[UIScreen mainScreen] bounds];
    
    // Calculate aspect ratio
    float aspectRatio = winRect.size.width / winRect.size.height;
    
    const GLfloat fieldView = GLKMathDegreesToRadians(fieldOfView);
    self.projectionMatrix = GLKMatrix4MakePerspective(fieldView, aspectRatio, 0.1f, 1000000.0f);
}

- (void)update
{
    
}

- (GLKVector3)gluUnproject:(GLKVector3)screenPoint inView:(UIView*)view withModelMatrix:(GLKMatrix4)model projection:(GLKMatrix4)projection
{
    int viewport[4];
    glGetIntegerv(GL_VIEWPORT, viewport);
    
    bool success;
    GLKVector3 result = GLKMathUnproject(screenPoint, model, projection, &viewport[0], &success);
    
    return result;
}

@end
