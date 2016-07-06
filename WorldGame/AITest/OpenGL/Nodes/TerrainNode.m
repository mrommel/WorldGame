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

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
    float TextureContributions[4];
} TerrainVertex;

TerrainVertex TerrainVertexMake(float x, float y, float texx, float texy, float tex0, float tex1, float tex2, float tex3)
{
    TerrainVertex vertex;
    vertex.Position[0] = x;
    vertex.Position[1] = 0;
    vertex.Position[2] = y;
    vertex.Color[0] = 1;
    vertex.Color[1] = 1;
    vertex.Color[2] = 1;
    vertex.Color[3] = 1;
    vertex.TexCoord[0] = texx;
    vertex.TexCoord[1] = texy;
    vertex.TextureContributions[0] = tex0;
    vertex.TextureContributions[1] = tex1;
    vertex.TextureContributions[2] = tex2;
    vertex.TextureContributions[3] = tex3;
    return vertex;
}

typedef unsigned int Index;

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

@end

@implementation TerrainNode

- (id)init
{
    self = [super init];
    
    if (self) {
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
    
    TerrainVertex *vertices = malloc(16 * sizeof(TerrainVertex));
    // first quad
    vertices[0] = TerrainVertexMake(0, 0, 0, 0, 1, 0, 0, 0);
    vertices[1] = TerrainVertexMake(10, 0, 1, 0, 1, 0, 0, 0);
    vertices[2] = TerrainVertexMake(0, 10, 0, 1, 1, 0, 0, 0);
    vertices[3] = TerrainVertexMake(10, 10, 1, 1, 0, 0, 1, 0); //center
    // second quad
    vertices[4] = TerrainVertexMake(10, 0, 0, 0, 1, 0, 0, 0);
    vertices[5] = TerrainVertexMake(20, 0, 1, 0, 1, 0, 0, 0);
    vertices[6] = TerrainVertexMake(10, 10, 0, 1, 0, 0, 1, 0); //center
    vertices[7] = TerrainVertexMake(20, 10, 1, 1, 1, 0, 0, 0);
    // third quad
    vertices[8] = TerrainVertexMake(0, 10, 0, 0, 1, 0, 0, 0);
    vertices[9] = TerrainVertexMake(10, 10, 1, 0, 0, 0, 1, 0); //center
    vertices[10] = TerrainVertexMake(0, 20, 0, 1, 1, 0, 0, 0);
    vertices[11] = TerrainVertexMake(10, 20, 1, 1, 1, 0, 0, 0);
    // fourth quad
    vertices[12] = TerrainVertexMake(10, 10, 0, 0, 0, 0, 1, 0); //center
    vertices[13] = TerrainVertexMake(20, 10, 1, 0, 1, 0, 0, 0);
    vertices[14] = TerrainVertexMake(10, 20, 0, 1, 1, 0, 0, 0);
    vertices[15] = TerrainVertexMake(20, 20, 1, 1, 1, 0, 0, 0);

    Index *indices = malloc(24 * sizeof(Index));
    // first quad
    indices[0] = 0; indices[1] = 3; indices[2] = 2; // I
    indices[3] = 0; indices[4] = 1; indices[5] = 3; // II
    // second quad
    indices[6] = 4; indices[7] = 5; indices[8] = 6; // III
    indices[9] = 5; indices[10] = 7; indices[11] = 6; // IV
    // third quad
    indices[12] = 8; indices[13] = 9; indices[14] = 10; // V
    indices[15] = 9; indices[16] = 11; indices[17] = 10; // VI
    // fourth quad
    indices[18] = 12; indices[19] = 13; indices[20] = 15; // VII
    indices[21] = 12; indices[22] = 15; indices[23] = 14; // VIII
    
    glGenBuffers(1, &_vertexBufferTerrains);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTerrains);
    glBufferData(GL_ARRAY_BUFFER, 16 * sizeof(TerrainVertex), vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBufferTerrains);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferTerrains);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 24 * sizeof(Index), indices, GL_STATIC_DRAW);
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
    
    glDrawElements(GL_TRIANGLES, 24, GL_UNSIGNED_INT, 0);
    
    // unbind textures
    [RETexture unbind];
}

@end
