//
//  CubeMesh.h
//  SimWorld
//
//  Created by Michael Rommel on 15.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "Mesh.h"

@interface CubeMesh : Mesh

- (id)initWithX:(float)x andY:(float)y andZ:(float)z andTextureFile:(NSString *)textureName;

@end
