//
//  OpenGLUtil.h
//  SimWorld
//
//  Created by Michael Rommel on 08.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <OpenGLES/ES2/gl.h>

@interface OpenGLUtil : NSObject

+ (OpenGLUtil *)sharedInstance;

- (GLuint)setupTexture:(NSString *)fileName;

@end
