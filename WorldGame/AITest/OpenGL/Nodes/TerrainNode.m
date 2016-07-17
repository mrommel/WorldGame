//
//  TerrainNode.m
//  WorldGame
//
//  Created by Michael Rommel on 05.07.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "TerrainNode.h"

#import "GLPlane.h"
#import "OpenGLUtil.h"
#import "MathHelper.h"
#import "TerrainVertex.h"
#import "Array2D.h"

@interface TerrainNode() {
    
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    NSTimer *_timer;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _depthRenderBuffer;
    
    GLuint _texCoordSlot;
    GLuint _textureContributionsSlot;
    GLint _samplerArrayLoc;
    
    GLuint _vertexBufferTerrains;
    GLuint _indexBufferTerrains;
    
    GLuint texture0, texture1, texture2, texture3;
    
    GLPlane *_groundPlane;
}

@property (atomic) CGSize tileSize;
@property (nonatomic) Array2D *tiles;

@end

#define TERRAIN_GRASS       @"TERRAIN_GRASS"
#define TERRAIN_OCEAN       @"TERRAIN_OCEAN"
#define TERRAIN_PLAIN       @"TERRAIN_PLAIN"
#define TERRAIN_MOUNTAIN    @"TERRAIN_MOUNTAIN"

#define CONTRIBUTION_ROCK    GLKVector4Make(0, 0, 0, 1)
#define CONTRIBUTION_SAND    GLKVector4Make(0, 1, 0, 0)

@implementation TerrainNode

- (id)init
{
    self = [super init];
    
    if (self) {
        self.tiles = [Array2D arrayWithSize:CGSizeMake(3, 3)];
        
        [self.tiles setObject:TERRAIN_MOUNTAIN atX:0 andY:0];
        [self.tiles setObject:TERRAIN_GRASS atX:1 andY:0];
        [self.tiles setObject:TERRAIN_GRASS atX:2 andY:0];
        
        [self.tiles setObject:TERRAIN_GRASS atX:0 andY:1];
        [self.tiles setObject:TERRAIN_OCEAN atX:1 andY:1];
        [self.tiles setObject:TERRAIN_OCEAN atX:2 andY:1];
        
        [self.tiles setObject:TERRAIN_GRASS atX:0 andY:2];
        [self.tiles setObject:TERRAIN_OCEAN atX:1 andY:2];
        [self.tiles setObject:TERRAIN_OCEAN atX:2 andY:2];
        
        [self setupRenderBuffer];
        [self setupDepthBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        [self setupVBOs];
    }
    
    return self;
}

- (void)setupRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, 200, 200);
}

- (void)setupFrameBuffer
{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
}

- (void)setupVBOs
{
    texture0 = [[OpenGLUtil sharedInstance] setupTexture:@"grass512.png"];
    texture1 = [[OpenGLUtil sharedInstance] setupTexture:@"sand512.png"];
    texture2 = [[OpenGLUtil sharedInstance] setupTexture:@"dirt512.png"];
    texture3 = [[OpenGLUtil sharedInstance] setupTexture:@"rock512.png"];
    
    self.tileSize = CGSizeMake(3, 3);
    
    float x0 = 0.0f;
    float y0 = 0.0f;
    float d = 5.0f;
    float r = d / 2.0f;
    float dx = r + cosf(DegreesToRadians(60)) * r;
    float dy = sinf(DegreesToRadians(60)) * r;
    
    TerrainVertex *vertices = malloc(kVerticesPerTile * self.tileSize.width * self.tileSize.height * sizeof(TerrainVertex));
    TerrainIndex *indices = malloc(kIndicesPerTile * self.tileSize.width * self.tileSize.height * sizeof(TerrainIndex));
    
    for (int x = 0; x < self.tileSize.width; x++) {
        for (int y = 0; y < self.tileSize.height; y++) {
            int vi = (x + y * self.tileSize.width) * kVerticesPerTile;
            int ii = (x + y * self.tileSize.width) * kIndicesPerTile;
            
            // points
            GLKVector3 p9 = GLKVector3Make(x0 + x * dx, 0, y0 + y * (2 * dy) + (x % 2) * dy);
            
            GLKVector3 p0 = GLKVector3Add(GLKVector3Make(cosf(DegreesToRadians(120)) * r, 0, -sinf(DegreesToRadians(120)) * r), p9);
            GLKVector3 p2 = GLKVector3Add(GLKVector3Make(cosf(DegreesToRadians(60)) * r, 0, -sinf(DegreesToRadians(60)) * r), p9);
            GLKVector3 p7 = GLKVector3Add(GLKVector3Make(cosf(DegreesToRadians(180)) * r, 0, -sinf(DegreesToRadians(180)) * r), p9);
            GLKVector3 p11 = GLKVector3Add(GLKVector3Make(cosf(DegreesToRadians(0)) * r, 0, -sinf(DegreesToRadians(0)) * r), p9);
            GLKVector3 p16 = GLKVector3Add(GLKVector3Make(cosf(DegreesToRadians(240)) * r, 0, -sinf(DegreesToRadians(240)) * r), p9);
            GLKVector3 p18 = GLKVector3Add(GLKVector3Make(cosf(DegreesToRadians(300)) * r, 0, -sinf(DegreesToRadians(300)) * r), p9);
            
            GLKVector3 p1 = GLKVector3Lerp(p0, p2, 0.5f);
            GLKVector3 p3 = GLKVector3Lerp(p0, p7, 0.5f);
            GLKVector3 p4 = GLKVector3Lerp(p0, p9, 0.5f);
            GLKVector3 p5 = GLKVector3Lerp(p2, p9, 0.5f);
            GLKVector3 p6 = GLKVector3Lerp(p2, p11, 0.5f);
            GLKVector3 p8 = GLKVector3Lerp(p7, p9, 0.5f);
            GLKVector3 p10 = GLKVector3Lerp(p9, p11, 0.5f);
            GLKVector3 p12 = GLKVector3Lerp(p7, p16, 0.5f);
            GLKVector3 p13 = GLKVector3Lerp(p9, p16, 0.5f);
            GLKVector3 p14 = GLKVector3Lerp(p10, p18, 0.5f);
            GLKVector3 p15 = GLKVector3Lerp(p11, p18, 0.5f);
            GLKVector3 p17 = GLKVector3Lerp(p16, p18, 0.5f);
            
            // textures
            GLKVector2 t9 = GLKVector2Make(0.5f, 0.5f);
            
            GLKVector2 t0 = GLKVector2Make(0.3f, 0.0f);
            GLKVector2 t2 = GLKVector2Make(0.7f, 0.0f);
            GLKVector2 t7 = GLKVector2Make(0.0f, 0.5f);
            GLKVector2 t11 = GLKVector2Make(1.0f, 0.5f);
            GLKVector2 t16 = GLKVector2Make(0.3f, 1.0f);
            GLKVector2 t18 = GLKVector2Make(0.7f, 1.0f);
            
            GLKVector2 t1 = GLKVector2Lerp(t0, t2, 0.5f);
            GLKVector2 t3 = GLKVector2Lerp(t0, t7, 0.5f);
            GLKVector2 t4 = GLKVector2Lerp(t0, t9, 0.5f);
            GLKVector2 t5 = GLKVector2Lerp(t2, t9, 0.5f);
            GLKVector2 t6 = GLKVector2Lerp(t2, t11, 0.5f);
            GLKVector2 t8 = GLKVector2Lerp(t7, t9, 0.5f);
            GLKVector2 t10 = GLKVector2Lerp(t9, t11, 0.5f);
            GLKVector2 t12 = GLKVector2Lerp(t7, t16, 0.5f);
            GLKVector2 t13 = GLKVector2Lerp(t9, t16, 0.5f);
            GLKVector2 t14 = GLKVector2Lerp(t9, t18, 0.5f);
            GLKVector2 t15 = GLKVector2Lerp(t11, t18, 0.5f);
            GLKVector2 t17 = GLKVector2Lerp(t16, t18, 0.5f);
            
            vertices[vi + 0] = TerrainVertexMake(p0, t0, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 1] = TerrainVertexMake(p1, t1, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 2] = TerrainVertexMake(p2, t2, GLKVector4Make(1, 0, 0, 0));
            
            vertices[vi + 3] = TerrainVertexMake(p3, t3, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 4] = TerrainVertexMake(p4, t4, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 5] = TerrainVertexMake(p5, t5, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 6] = TerrainVertexMake(p6, t6, GLKVector4Make(1, 0, 0, 0));
            
            vertices[vi + 7] = TerrainVertexMake(p7, t7, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 8] = TerrainVertexMake(p8, t8, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 9] = TerrainVertexMake(p9, t9, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 10] = TerrainVertexMake(p10, t10, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 11] = TerrainVertexMake(p11, t11, GLKVector4Make(1, 0, 0, 0));
            
            vertices[vi + 12] = TerrainVertexMake(p12, t12, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 13] = TerrainVertexMake(p13, t13, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 14] = TerrainVertexMake(p14, t14, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 15] = TerrainVertexMake(p15, t15, GLKVector4Make(1, 0, 0, 0));
            
            vertices[vi + 16] = TerrainVertexMake(p16, t16, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 17] = TerrainVertexMake(p17, t17, GLKVector4Make(1, 0, 0, 0));
            vertices[vi + 18] = TerrainVertexMake(p18, t18, GLKVector4Make(1, 0, 0, 0));
            
            // update heights
            NSString *tileName = [self.tiles objectAtX:x andY:y];
            if ([tileName isEqualToString:TERRAIN_GRASS]) {
                TerrainVertexSetHeight(&vertices[vi + 0], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 1], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 2], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 3], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 4], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 5], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 6], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 7], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 8], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 9], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 10], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 11], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 12], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 13], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 14], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 15], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 16], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 17], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 18], 0.5f);
            } else if ([tileName isEqualToString:TERRAIN_OCEAN]) {
                TerrainVertexSetHeight(&vertices[vi + 0], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 1], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 2], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 3], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 4], -0.5f);
                TerrainVertexSetContribution(&vertices[vi + 4], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 5], -0.5f);
                TerrainVertexSetContribution(&vertices[vi + 5], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 6], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 7], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 8], -0.5f);
                TerrainVertexSetContribution(&vertices[vi + 8], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 9], -1.0f);
                TerrainVertexSetContribution(&vertices[vi + 9], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 10], -0.5f);
                TerrainVertexSetContribution(&vertices[vi + 10], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 11], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 12], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 13], -0.5f);
                TerrainVertexSetContribution(&vertices[vi + 13], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 14], -0.5f);
                TerrainVertexSetContribution(&vertices[vi + 14], CONTRIBUTION_SAND);
                TerrainVertexSetHeight(&vertices[vi + 15], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 16], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 17], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 18], 0.5f);
            } else if ([tileName isEqualToString:TERRAIN_PLAIN]) {
                TerrainVertexSetHeight(&vertices[vi + 0], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 1], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 2], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 3], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 4], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 5], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 6], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 7], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 8], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 9], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 10], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 11], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 12], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 13], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 14], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 15], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 16], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 17], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 18], 0.5f);
            } else if ([tileName isEqualToString:TERRAIN_MOUNTAIN]) {
                TerrainVertexSetHeight(&vertices[vi + 0], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 1], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 2], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 3], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 4], 3.0f);
                TerrainVertexSetContribution(&vertices[vi + 4], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 5], 3.0f);
                TerrainVertexSetContribution(&vertices[vi + 5], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 6], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 7], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 8], 3.0f);
                TerrainVertexSetContribution(&vertices[vi + 8], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 9], 4.0f);
                TerrainVertexSetContribution(&vertices[vi + 9], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 10], 3.0f);
                TerrainVertexSetContribution(&vertices[vi + 10], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 11], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 12], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 13], 3.0f);
                TerrainVertexSetContribution(&vertices[vi + 13], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 14], 3.0f);
                TerrainVertexSetContribution(&vertices[vi + 14], CONTRIBUTION_ROCK);
                TerrainVertexSetHeight(&vertices[vi + 15], 0.5f);
                
                TerrainVertexSetHeight(&vertices[vi + 16], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 17], 0.5f);
                TerrainVertexSetHeight(&vertices[vi + 18], 0.5f);
            }
            
            //
            TRIANGLE(ii + 0, vi + 0, vi + 1, vi + 4);
            TRIANGLE(ii + 3, vi + 1, vi + 2, vi + 5);
            TRIANGLE(ii + 6, vi + 0, vi + 4, vi + 3);
            TRIANGLE(ii + 9, vi + 1, vi + 5, vi + 4);
            TRIANGLE(ii + 12, vi + 2, vi + 6, vi + 5);
            
            TRIANGLE(ii + 15, vi + 3, vi + 4, vi + 8);
            TRIANGLE(ii + 18, vi + 4, vi + 5, vi + 9);
            TRIANGLE(ii + 21, vi + 5, vi + 6, vi + 10);
            TRIANGLE(ii + 24, vi + 3, vi + 8, vi + 7);
            TRIANGLE(ii + 27, vi + 4, vi + 9, vi + 8);
            TRIANGLE(ii + 30, vi + 5, vi + 10, vi + 9);
            TRIANGLE(ii + 33, vi + 6, vi + 11, vi + 10);

            TRIANGLE(ii + 36, vi + 7, vi + 8, vi + 12);
            TRIANGLE(ii + 39, vi + 8, vi + 9, vi + 13);
            TRIANGLE(ii + 42, vi + 9, vi + 10, vi + 14);
            TRIANGLE(ii + 45, vi + 10, vi + 11, vi + 15);
            TRIANGLE(ii + 48, vi + 8, vi + 13, vi + 12);
            TRIANGLE(ii + 51, vi + 9, vi + 14, vi + 13);
            TRIANGLE(ii + 54, vi + 10, vi + 15, vi + 14);
            
            TRIANGLE(ii + 57, vi + 12, vi + 13, vi + 16);
            TRIANGLE(ii + 60, vi + 13, vi + 14, vi + 17);
            TRIANGLE(ii + 63, vi + 14, vi + 15, vi + 18);
            TRIANGLE(ii + 66, vi + 13, vi + 17, vi + 16);
            TRIANGLE(ii + 69, vi + 14, vi + 18, vi + 17);
        }
    }
    
    glGenBuffers(1, &_vertexBufferTerrains);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTerrains);
    glBufferData(GL_ARRAY_BUFFER, kVerticesPerTile * self.tileSize.width * self.tileSize.height * sizeof(TerrainVertex), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBufferTerrains);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferTerrains);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, kIndicesPerTile * self.tileSize.width * self.tileSize.height * sizeof(TerrainIndex), indices, GL_STATIC_DRAW);
}

- (void)compileShaders
{
    // 5
    _positionSlot = glGetAttribLocation(self.program.program, "Position");
    glEnableVertexAttribArray(_positionSlot);
    _colorSlot = glGetAttribLocation(self.program.program, "SourceColor");
    glEnableVertexAttribArray(_colorSlot);
    
    _projectionUniform = glGetUniformLocation(self.program.program, "Projection");
    _modelViewUniform = glGetUniformLocation(self.program.program, "Modelview");
    
    _texCoordSlot = glGetAttribLocation(self.program.program, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    
    _textureContributionsSlot = glGetAttribLocation(self.program.program, "TextureContributionsIn");
    glEnableVertexAttribArray(_textureContributionsSlot);
    
    _samplerArrayLoc = glGetUniformLocation(self.program.program, "TexturesIn");
}

+ (REProgram*)program
{
    return [REProgram programWithVertexFilename:@"TerrainVertex.glsl"
                               fragmentFilename:@"TerrainFragment.glsl"];
}

- (void)draw
{
    [super draw];
    
    glClearColor(0.0/255.0, 20.0/255.0, 0.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    glEnable (GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glFrontFace(GL_CCW);
    
    // Projection Matrix
    const CC3GLMatrix *projectionMatrix = [self.camera projectionMatrix];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.glMatrix);
    
    // View Matrix
    const CC3GLMatrix *viewMatrix = [self.camera viewMatrix];
    
    // ---------------------------------
    
    // Bind the textures
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture0);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture1);
    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, texture2);
    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, texture3);
    
    // we've bound our textures in textures 0 to 3.
    const GLint samplers[4] = {0, 1, 2, 3};
    glUniform1iv(_samplerArrayLoc, 4, samplers);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTerrains);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferTerrains);
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, viewMatrix.glMatrix);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), (GLvoid*) (sizeof(float) * 3));
    glEnableVertexAttribArray(_colorSlot);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), (GLvoid*) (sizeof(float) * 7));
    glEnableVertexAttribArray(_texCoordSlot);
    glVertexAttribPointer(_textureContributionsSlot, 4, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), (GLvoid*) (sizeof(float) * 9));
    glEnableVertexAttribArray(_textureContributionsSlot);
    
    glDrawElements(GL_TRIANGLES, kIndicesPerTile * self.tileSize.width * self.tileSize.height, GL_UNSIGNED_INT, 0);
    
    // unbind textures
    [RETexture unbind];
}

@end
