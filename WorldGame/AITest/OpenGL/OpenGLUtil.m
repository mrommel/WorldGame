//
//  OpenGLUtil.m
//  SimWorld
//
//  Created by Michael Rommel on 08.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "OpenGLUtil.h"
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@implementation OpenGLUtil

static OpenGLUtil *shared = nil;

+ (OpenGLUtil *)sharedInstance
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[self alloc] init];
        }
    }
    
    return shared;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (GLuint)setupTexture:(NSString *)fileName
{
    // 1
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte *spriteData = (GLubyte *)calloc(width*height*4, sizeof(GLubyte));
    
    //CGColorSpaceRef colorSpace = CGImageGetColorSpace(spriteImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //CGBitmapInfo alphaInfo = CGImageGetBitmapInfo(spriteImage);
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    //glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (int)width, (int)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}

@end
