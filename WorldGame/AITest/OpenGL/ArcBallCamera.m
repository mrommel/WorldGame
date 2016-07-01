//
//  ArcBallCamera.m
//  SimWorld
//
//  Created by Michael Rommel on 02.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "ArcBallCamera.h"

#import "MathHelper.h"

@implementation ArcBallCamera

-(id) initWithTarget:(GLKVector3)target andRotationX:(GLfloat)rotationX andRotationY:(GLfloat)rotationY
     andMinRotationY:(GLfloat)minRotationY andMaxRotationY:(GLfloat)maxRotationY
         andDistance:(GLfloat)distance
      andMinDistance:(GLfloat)minDistance andMaxDistance:(GLfloat)maxDistance
{
    self = [super init];
    
    if (self) {
        self.target = target;
        self.minRotationY = minRotationY;
        self.maxRotationY = maxRotationY;
        
        // Lock the y axis rotation between the min and max values
        self.rotationY = CLAMP(rotationY, minRotationY, maxRotationY);
        
        self.rotationX = rotationX;
        self.minDistance = minDistance;
        self.maxDistance = maxDistance;
        
        // Lock the distance between the min and max values
        self.distance = CLAMP(distance, minDistance, maxDistance);
    }
    
    return self;
}

-(void) moveBy:(GLfloat)distanceChange
{
    self.distance += distanceChange;
    self.distance = CLAMP(self.distance, self.minDistance, self.maxDistance);
}

-(void) rotateByX:(GLfloat)rotationXChange andY:(GLfloat)rotationYChange
{
    self.rotationX += rotationXChange;
    self.rotationY += -rotationYChange;
    self.rotationY = CLAMP(self.rotationY, self.minRotationY, self.maxRotationY);
}

-(void) translateBy:(GLKVector3)positionChange
{
    self.target = GLKVector3Add(self.target, positionChange);
}

-(void) update
{
    // Calculate rotation matrix from rotation values
    GLKMatrix4 rotation = Matrix4MakeFromYawPitchRoll(self.rotationX, -self.rotationY, 0);
    
    // Translate down the Z axis by the desired distance
    // between the camera and object, then rotate that
    // vector to find the camera offset from the target
    GLKVector3 translation = GLKVector3Make(0.0f, 0.0f, self.distance);
    translation = Vector3Transform(translation, rotation);
    self.position = GLKVector3Add(self.target, translation);
    
    // Calculate the up vector from the rotation matrix
    GLKVector3 up = Vector3Transform(GLKVector3Make(0.0f, 1.0f, 0.0f), rotation);
    self.viewMatrix = GLKMatrix4MakeLookAt(self.position.x, self.position.y, self.position.z, self.target.x, self.target.y, self.target.z, up.x, up.y, up.z);
}
/*
public Vector3 Up
{
    get
    {
        // Calculate the rotation matrix
        Matrix rotation = Matrix.CreateFromYawPitchRoll(RotationX, -RotationY, 0);
        
        return Vector3.Transform(Vector3.Up, rotation);
    }
}

public Vector3 Right
{
    get
    {
        // Calculate the rotation matrix
        Matrix rotation = Matrix.CreateFromYawPitchRoll(RotationX, -RotationY, 0);
        
        return Vector3.Transform(Vector3.Right, rotation);
    }
}
*/

@end
