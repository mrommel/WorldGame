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
#import "CC3GLMatrix+Extension.h"

@interface TerrainNode() {
    
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    NSTimer *_timer;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _modelUniform;
    GLuint _depthRenderBuffer;
    
    GLuint _texCoordSlot;
    GLuint _textureContributionsSlot;
    GLint _samplerArrayLoc;
    
    GLuint _vertexBufferTerrains;
    GLuint _indexBufferTerrains;
    
    GLuint texture0, texture1, texture2, texture3;
    
    GLPlane *_groundPlane;
    GLKVector4 m_clipPlane;
    GLuint _clipPlainSlot;
    
    // skybox
    REProgram *skyboxProgram;
    GLuint _skyboxVertexBuffer;
    GLuint _skyBoxIndexBuffer;
    GLuint _skyboxPositionSlot;
    GLuint _skyboxColorSlot;
    GLuint _skyboxProjectionUniform;
    GLuint _skyboxModelViewUniform;
    GLuint _skyboxModelUniform;
    GLuint _skyboxTexCoordSlot;
    GLuint _skyboxTextureUniform;
    GLuint skyboxTexture;
    
    //
    GLfloat _waterHeight, _waterOffset;
    
    // viewport
    REProgram *viewportProgram;
    GLuint _viewportSizedQuadVertexBuffer;
    GLuint _viewportSizedQuadIndexBuffer;
    
    GLuint _viewportPositionSlot;
    GLuint _viewportColorSlot;
    GLuint _viewportTexCoordSlot;
    GLuint _viewportTextureUniform;
    
    // refraction
    GLuint _refractionFrameBuffer;
    GLuint _refractionTexture;
    GLuint _refractionDepthBuffer;
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

#define TEX_COORD_MAX 1

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} ViewportVertex;

typedef unsigned int ViewportIndex;

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} SkyboxVertex;

typedef unsigned int SkyboxIndex;

const ViewportVertex viewPortQuadVertices[] = {
    {{1, -1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, 0}, {1, 1, 1, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, 0}, {1, 1, 1, 1}, {0, 0}},
};

const ViewportIndex viewPortQuadIndices[] = {
    0, 1, 2,
    2, 3, 0,
};

const SkyboxVertex skyboxVertices[] = {
    {{0, 0, 0}, {1, 1, 1, 1}, {0, 0}},
    {{10, 0, 0}, {1, 1, 1, 1}, {1, 0}},
    {{10, 0, 10}, {1, 1, 1, 1}, {1, 1}},
    {{0, 0, 10}, {1, 1, 1, 1}, {0, 1}},
};

const SkyboxIndex skyboxIndices[] = {
    0, 1, 2,
    2, 3, 0,
};

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
        
        _waterHeight = 0.0f;
        _waterOffset = 0.55f;
        
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

- (void)setupDepthBuffer
{
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, 1024, 1024);
}

- (void)setupFrameBuffer
{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthRenderBuffer);
    
    // ---------------------
    // create skybox buffers
    glGenBuffers (1, &_skyboxVertexBuffer);
    glBindBuffer (GL_ARRAY_BUFFER, _skyboxVertexBuffer);
    glBufferData (GL_ARRAY_BUFFER, sizeof(skyboxVertices), skyboxVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_skyBoxIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _skyBoxIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(skyboxIndices), skyboxIndices, GL_STATIC_DRAW);
    
    // ---------------------
    // create viewport buffers
    glGenBuffers(1, &_viewportSizedQuadVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _viewportSizedQuadVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(viewPortQuadVertices), viewPortQuadVertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_viewportSizedQuadIndexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _viewportSizedQuadIndexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(viewPortQuadIndices), viewPortQuadIndices, GL_STATIC_DRAW);
    
    // ---------------------
    // refraction frame buffer
    GLint maxRenderBufferSize;
    glGetIntegerv(GL_MAX_RENDERBUFFER_SIZE, &maxRenderBufferSize);
    
    GLuint textureWidth = 1024;
    GLuint textureHeight = 1024;
    
    if (maxRenderBufferSize <= textureWidth || maxRenderBufferSize <= textureHeight) {
        NSLog(@"FBO cant allocate that much space");
    }
    
    // The framebuffer, which regroups 0, 1, or more textures, and 0 or 1 depth buffer.
    glGenFramebuffers(1, &_refractionFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _refractionFrameBuffer);
    
    // The texture we're going to render to
    glGenTextures(1, &_refractionTexture);
    
    // "Bind" the newly created texture : all future texture functions will modify this texture
    glBindTexture(GL_TEXTURE_2D, _refractionTexture);
    
    // Give an empty image to OpenGL ( the last "0" )
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGB, textureWidth, textureHeight, 0, GL_RGB, GL_UNSIGNED_BYTE, 0);
    
    // Poor filtering. Needed !
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    // The depth buffer
    glGenRenderbuffers(1, &_refractionDepthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _refractionDepthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, textureWidth, textureHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _refractionDepthBuffer);
    
    // Set "renderedTexture" as our colour attachement #0
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _refractionTexture, 0);
    
    GLuint status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"refraction buffers are not complete :%u", status);
    }
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
                
                //NSLog(@"Ocean: %@", TerrainVertexToString(vertices[vi + 9]));
                //http://www.calculatorsoup.com/calculators/algebra/dot-product-calculator.php
                
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
    _modelViewUniform = glGetUniformLocation(self.program.program, "ModelView");
    _modelUniform = glGetUniformLocation(self.program.program, "ModelMatrix");
    
    _texCoordSlot = glGetAttribLocation(self.program.program, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    
    _textureContributionsSlot = glGetAttribLocation(self.program.program, "TextureContributionsIn");
    glEnableVertexAttribArray(_textureContributionsSlot);
    
    _samplerArrayLoc = glGetUniformLocation(self.program.program, "TexturesIn");
    
    // clipping
    _clipPlainSlot = glGetUniformLocation(self.program.program, "u_clipPlane");
    
    // ------------------------------
    // skybox shader
    skyboxProgram = [REProgram programWithVertexFilename:@"SkyboxVertex.glsl"
                                        fragmentFilename:@"SkyboxFragment.glsl"];
    
    _skyboxPositionSlot = glGetAttribLocation(skyboxProgram.program, "Position");
    glEnableVertexAttribArray(_skyboxPositionSlot);
    _skyboxColorSlot = glGetAttribLocation(skyboxProgram.program, "SourceColor");
    glEnableVertexAttribArray(_skyboxColorSlot);
    _skyboxTexCoordSlot = glGetAttribLocation(skyboxProgram.program, "TexCoordIn");
    glEnableVertexAttribArray(_skyboxTexCoordSlot);
    
    _skyboxProjectionUniform = glGetUniformLocation(skyboxProgram.program, "Projection");
    _skyboxModelViewUniform = glGetUniformLocation(skyboxProgram.program, "ModelView");
    _skyboxModelUniform = glGetUniformLocation(skyboxProgram.program, "ModelMatrix");
    
    skyboxTexture = [[OpenGLUtil sharedInstance] setupTexture:@"grass512.png"];
    _skyboxTextureUniform = glGetUniformLocation(skyboxProgram.program, "Texture");
    
    // ------------------------------
    // viewport shader
    viewportProgram = [REProgram programWithVertexFilename:@"ViewportVertex.glsl"
                                          fragmentFilename:@"ViewportFragment.glsl"];
    
    _viewportPositionSlot = glGetAttribLocation(viewportProgram.program, "texPosition");
    glEnableVertexAttribArray(_viewportPositionSlot);
    _viewportColorSlot = glGetAttribLocation(viewportProgram.program, "texSourceColor");
    glEnableVertexAttribArray(_viewportColorSlot);
    _viewportTexCoordSlot = glGetAttribLocation(viewportProgram.program, "texTexCoordIn");
    glEnableVertexAttribArray(_viewportTexCoordSlot);
    _viewportTextureUniform = glGetUniformLocation(viewportProgram.program, "Texture");
}

+ (REProgram *)program
{
    return [REProgram programWithVertexFilename:@"TerrainVertex.glsl"
                               fragmentFilename:@"TerrainFragment.glsl"];
}

/*!
 @param plane (x, y, z) direction of normal, w distance
 */
- (void)drawTerrainWithClipPlane:(GLKVector4)plane andCameraToggle:(BOOL)cameraToogle andClear:(BOOL)clearToogle
{
    if (clearToogle) {
        glClearColor(214.0/255.0, 226.0/255.0, 255.0/255.0, 1.0);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    }
    
    glEnable(GL_DEPTH_TEST);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glFrontFace(GL_CCW);
    
    glUseProgram(self.program.program);
    
    // Model Matrix
    const CC3GLMatrix *modelMatrix = [CC3GLMatrix identity];
    glUniformMatrix4fv(_modelUniform, 1, 0, modelMatrix.glMatrix);
    
    if (cameraToogle) { // reflection
        RECamera *reflectionCamera = [[RECamera alloc] initWithProjection:kRECameraProjectionArcBall];
        
        reflectionCamera.target = CC3VectorMake(0, 0, 0);
        reflectionCamera.upDirection = CC3VectorMake(0, 1, 0); // (0, -1, 0)
        reflectionCamera.lookDirection = CC3VectorMake(0, 0, -1);
        reflectionCamera.rotation = CC3VectorMake(3.1415, -(M_PI * 0.75f), 0);
        reflectionCamera.distance = self.camera.distance;
        
        // View Matrix
        const CC3GLMatrix *viewMatrix = [modelMatrix copyMultipliedBy:[reflectionCamera viewMatrix]];
        glUniformMatrix4fv(_modelViewUniform, 1, 0, viewMatrix.glMatrix);
        
        // Projection Matrix
        const CC3GLMatrix *projectionMatrix = [reflectionCamera projectionMatrix];
        glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.glMatrix);
    } else { // normal
        // View Matrix
        const CC3GLMatrix *viewMatrix = [modelMatrix copyMultipliedBy:[self.camera viewMatrix]];
        glUniformMatrix4fv(_modelViewUniform, 1, 0, viewMatrix.glMatrix);
    
        // Projection Matrix
        const CC3GLMatrix *projectionMatrix = [self.camera projectionMatrix];
        glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.glMatrix);
    }
    
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
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), 0);
    glEnableVertexAttribArray(_positionSlot);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), (GLvoid*) (sizeof(float) * 3));
    glEnableVertexAttribArray(_colorSlot);
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), (GLvoid*) (sizeof(float) * 7));
    glEnableVertexAttribArray(_texCoordSlot);
    glVertexAttribPointer(_textureContributionsSlot, 4, GL_FLOAT, GL_FALSE, sizeof(TerrainVertex), (GLvoid*) (sizeof(float) * 9));
    glEnableVertexAttribArray(_textureContributionsSlot);
    
    // apply the clipping
    glUniform4f(_clipPlainSlot, plane.x, plane.y, plane.z, plane.w);
    
    glDrawElements(GL_TRIANGLES, kIndicesPerTile * self.tileSize.width * self.tileSize.height, GL_UNSIGNED_INT, 0);
}

/*!
 *
 */
- (void)drawSkybox
{
    glClearColor(214.0/255.0, 226.0/255.0, 255.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glDisable(GL_DEPTH_TEST);   // skybox should be drawn behind anything else
    glFrontFace(GL_CW);
    
    glUseProgram(skyboxProgram.program);
    
    // Model Matrix
    const CC3GLMatrix *modelMatrix = [CC3GLMatrix identity];
    glUniformMatrix4fv(_skyboxModelUniform, 1, 0, modelMatrix.glMatrix);

    // View Matrix
    const CC3GLMatrix *viewMatrix = [modelMatrix copyMultipliedBy:[self.camera viewMatrix]];
    glUniformMatrix4fv(_skyboxModelViewUniform, 1, 0, viewMatrix.glMatrix);
        
    // Projection Matrix
    const CC3GLMatrix *projectionMatrix = [self.camera projectionMatrix];
    glUniformMatrix4fv(_skyboxProjectionUniform, 1, 0, projectionMatrix.glMatrix);
    
    // bind buffers
    glBindBuffer(GL_ARRAY_BUFFER, _skyboxVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _skyBoxIndexBuffer);
    
    // bind position
    glVertexAttribPointer(_skyboxPositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(SkyboxVertex), 0);
    glEnableVertexAttribArray(_skyboxPositionSlot);
    glVertexAttribPointer(_skyboxColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(SkyboxVertex), (GLvoid*) (sizeof(float) * 3));
    glEnableVertexAttribArray(_skyboxColorSlot);
    glVertexAttribPointer(_skyboxTexCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(SkyboxVertex), (GLvoid*) (sizeof(float) * 7));
    glEnableVertexAttribArray(_skyboxTexCoordSlot);
    
    // bind texture
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, skyboxTexture);
    glUniform1i(_skyboxTextureUniform, 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(skyboxIndices) / sizeof(skyboxIndices[0]) /* number of indices */, GL_UNSIGNED_INT, 0);
}

- (void)drawViewport
{
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_BLEND);
    
    glFrontFace(GL_CCW);
    
    glClearColor(127.0/255.0, 0.0/255.0, 127.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    glUseProgram(viewportProgram.program);
    
    glBindBuffer(GL_ARRAY_BUFFER, _viewportSizedQuadVertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _viewportSizedQuadIndexBuffer);
    
    glVertexAttribPointer(_viewportPositionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(ViewportVertex), 0);
    glEnableVertexAttribArray(_viewportPositionSlot);
    glVertexAttribPointer(_viewportColorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(ViewportVertex), (GLvoid*) (sizeof(float) * 3));
    glEnableVertexAttribArray(_viewportColorSlot);
    glVertexAttribPointer(_viewportTexCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(ViewportVertex), (GLvoid*) (sizeof(float) * 7));
    glEnableVertexAttribArray(_viewportTexCoordSlot);
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _refractionTexture);
    glUniform1i(_viewportTextureUniform, 0);
    
    glDrawElements(GL_TRIANGLES, 6/* number of indices */, GL_UNSIGNED_INT, 0);
}

- (void)draw
{
    [super draw];
    
    // First save the default frame buffer.
    static GLint default_frame_buffer = 0;
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &default_frame_buffer);
    
    // ///////////////////////////////////
    
    // first we render the under water part into refraction buffer
    glBindFramebuffer(GL_FRAMEBUFFER, _refractionFrameBuffer);
    glViewport(0, 0, 1024, 1024);
    //[self drawTerrainWithClipPlane:GLKVector4Make(0.0f, -1.0f, 0.0f, _waterHeight + _waterOffset) andCameraToggle:NO andClear:YES];
    
    //[self drawTerrainWithClipPlane:GLKVector4Make(0.0f, 1.0f, 0.0f, -_waterHeight) andCameraToggle:NO andClear:NO];
    
    // ///////////////////////////////////
    [self drawSkybox];
    
    // ///////////////////////////////////
    
    // second we render the above water part into reflection buffer
    /*glBindFramebuffer(GL_FRAMEBUFFER, _reflectionFrameBuffer);
    glViewport(0, 0, 1024, 1024);*/
    //[self drawTerrainWithClipPlane:GLKVector4Make(0.0f, 1.0f, 0.0f, -_waterHeight) andCameraToggle:NO andClear:NO];
    
    // ///////////////////////////////////

    // now we switch back to default buffer
    glBindFramebuffer(GL_FRAMEBUFFER, default_frame_buffer);
    glViewport(0, 0, 1024, 1024);
    
    [self drawViewport];

    // unbind textures
    [RETexture unbind];
}

@end
