//
//  TextureAtlas.h
//  SimWorld
//
//  Created by Michael Rommel on 20.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#include <OpenGLES/ES2/gl.h>

#import <UIKit/UIKit.h>

@interface TextureAtlas : NSObject

@property (nonatomic, assign) GLuint texture;

- (id)initWithAtlasFileName:(NSString *)textureFilename;
//- (id)initWithTexture:(NSString *)textureFilename andColumns:(int)columns andRows:(int)rows;

- (CGRect)tileForIndex:(int)frameIndex;
- (CGRect)tileForColumn:(int)col andRow:(int)row;
- (CGRect)tileForName:(NSString *)name;

- (UIImage *)imageForIndex:(int)frameIndex;
- (UIImage *)imageForColumn:(int)col andRow:(int)row;
- (UIImage *)imageForName:(NSString *)name;

@end
