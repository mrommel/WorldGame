//
//  OpenGLView.m
//  WorldGame
//
//  Created by Michael Rommel on 29.06.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "OpenGLView.h"

#import "CC3GLMatrix.h"

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
} Vertex;

@interface VertexHolder : NSObject {
    int _count;
    Vertex* _values;
}

- (id) initWithCount:(int)count;

// possibly look into this for making access shorter
// http://vgable.com/blog/2009/05/15/concise-nsdictionary-and-nsarray-lookup/
- (Vertex)getValueAtIndex:(int)index;
- (void)setValue:(Vertex)value atIndex:(int)index;

@property(readonly) int count;
@property(readonly) Vertex* values; // allows direct unsafe access to the values

@end

@implementation VertexHolder

@synthesize count = _count;
@synthesize values = _values;

- (id) initWithCount:(int)count
{
    self = [super init];
    if (self != nil) {
        _count = count;
        _values = malloc(sizeof(Vertex)*count);
    }
    return self;
}

- (void) dealloc
{
    free(_values);
}

- (Vertex)getValueAtIndex:(int)index
{
    if(index<0 || index>=_count) {
        @throw [NSException exceptionWithName: @"Exception" reason: @"Index out of bounds" userInfo: nil];
    }
    
    return _values[index];
}

- (void)setValue:(Vertex)value atIndex:(int)index
{
    if(index<0 || index>=_count) {
        @throw [NSException exceptionWithName: @"Exception" reason: @"Index out of bounds" userInfo: nil];
    }
    
    _values[index] = value;
}

@end

@interface IndexHolder : NSObject {
    int _count;
    GLubyte* _values;
}

- (id) initWithCount:(int)count;

// possibly look into this for making access shorter
// http://vgable.com/blog/2009/05/15/concise-nsdictionary-and-nsarray-lookup/
- (GLubyte)getValueAtIndex:(int)index;
- (void)setValue:(GLubyte)value atIndex:(int)index;

@property(readonly) int count;
@property(readonly) GLubyte* values; // allows direct unsafe access to the values

@end

@implementation IndexHolder

@synthesize count = _count;
@synthesize values = _values;

- (id) initWithCount:(int)count {
    self = [super init];
    if (self != nil) {
        _count = count;
        _values = malloc(sizeof(GLubyte)*count);
    }
    return self;
}

- (void) dealloc
{
    free(_values);
}

- (GLubyte)getValueAtIndex:(int)index {
    if(index<0 || index>=_count) {
        @throw [NSException exceptionWithName: @"Exception" reason: @"Index out of bounds" userInfo: nil];
    }
    
    return _values[index];
}

- (void)setValue:(GLubyte)value atIndex:(int)index {
    if(index<0 || index>=_count) {
        @throw [NSException exceptionWithName: @"Exception" reason: @"Index out of bounds" userInfo: nil];
    }
    
    _values[index] = value;
}

@end

#define TEX_COORD_MAX   1

const Vertex Vertices[] = {
    // Front
    {{1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Back
    {{1, 1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, -1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, -1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Left
    {{-1, -1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{-1, 1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}},
    // Right
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{1, 1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{1, -1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Top
    {{1, 1, 0}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, 1, -2}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, 1, -2}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, 1, 0}, {0, 0, 0, 1}, {0, 0}},
    // Bottom
    {{1, -1, -2}, {1, 0, 0, 1}, {TEX_COORD_MAX, 0}},
    {{1, -1, 0}, {0, 1, 0, 1}, {TEX_COORD_MAX, TEX_COORD_MAX}},
    {{-1, -1, 0}, {0, 0, 1, 1}, {0, TEX_COORD_MAX}},
    {{-1, -1, -2}, {0, 0, 0, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    // Front
    0, 1, 2,
    2, 3, 0,
    // Back
    4, 5, 6,
    4, 5, 7,
    // Left
    8, 9, 10,
    10, 11, 8,
    // Right
    12, 13, 14,
    14, 15, 12,
    // Top
    16, 17, 18,
    18, 19, 16,
    // Bottom
    20, 21, 22,
    22, 23, 20
};

#pragma mark -

@interface Model3D : NSObject

@property (nonatomic) VertexHolder *vertices;
@property (nonatomic) IndexHolder *indices;
@property (nonatomic) NSString *pathToTexture;
@property (atomic) GLuint texture;

- (instancetype)initWithVertices:(const Vertex *)vertices andIndices:(const GLubyte *)indices;

@end

@implementation Model3D

- (instancetype)initWithVertices:(const Vertex *)vertices andIndices:(const GLubyte *)indices
{
    self = [super init];
    
    if (self) {
        self.vertices = [[VertexHolder alloc] initWithCount:24];
        
        for (int i = 0; i < 24; i++) {
            [self.vertices setValue:vertices[i] atIndex:i];
        }
        
        self.indices = [[IndexHolder alloc] initWithCount:36];
        for (int i = 0; i < 36; i++) {
            [self.indices setValue:indices[i] atIndex:i];
        }
        self.pathToTexture = @"tile_floor.png";
    }
    
    return self;
}

@end

#pragma mark -

@implementation OpenGLView

// Replace initWithFrame with this
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self compileShaders];
        
        self.models = [[NSMutableArray alloc] init];
        
        Model3D *model1 = [[Model3D alloc] initWithVertices:Vertices andIndices:Indices];
        [self.models addObject:model1];
        
        /*Model3D *model2 = [[Model3D alloc] initWithVertices:Vertices andIndices:Indices];
        [self.models addObject:model2];*/
        
        [self setupVBOs];
        
        [self setupDisplayLink];
    }
    
    return self;
}

// Replace dealloc method with this
- (void)dealloc
{
    _context = nil;
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)setupDisplayLink
{
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

- (void)setupRenderBuffer
{
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupDepthBuffer {
    glGenRenderbuffers(1, &_depthRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);
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

- (void)render:(CADisplayLink*)displayLink
{
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    
    CC3GLMatrix *projection = [CC3GLMatrix matrix];
    float h = 4.0f * self.frame.size.height / self.frame.size.width;
    [projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
    
    CC3GLMatrix *modelView = [CC3GLMatrix matrix];
    [modelView populateFromTranslation:CC3VectorMake(0, 0, -7)];
    _currentRotation += displayLink.duration * 90;
    [modelView rotateBy:CC3VectorMake(_currentRotation, _currentRotation, 0)];
    glUniformMatrix4fv(_modelViewUniform, 1, 0, modelView.glMatrix);
    
    // 1
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    for (int i = 0; i < self.models.count; i++) {
        Model3D *model = [self.models objectAtIndex:i];
        
        // 2
        glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
        glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
        glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, model.texture);
        glUniform1i(_textureUniform, 0);
    
        // 3
        glDrawElements(GL_TRIANGLES, sizeof(model.indices.values)/sizeof(model.indices.values[0]), GL_UNSIGNED_BYTE, model.indices.values);
    }
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType
{
    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4
    glCompileShader(shaderHandle);
    
    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}

- (void)compileShaders
{
    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];
    
    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    // 4
    glUseProgram(programHandle);
    
    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
    _projectionUniform = glGetUniformLocation(programHandle, "Projection");
    _modelViewUniform = glGetUniformLocation(programHandle, "Modelview");
    
    _texCoordSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_texCoordSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
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
    GLsizei width = (GLsizei)CGImageGetWidth(spriteImage);
    GLsizei height = (GLsizei)CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    free(spriteData);        
    return texName;    
}

- (void)setupVBOs
{
    GLuint* vertexBuffers = malloc(sizeof(GLuint)*self.models.count);
    glGenBuffers((GLsizei)self.models.count, vertexBuffers);
    
    GLuint* indexBuffers = malloc(sizeof(GLuint)*self.models.count);
    glGenBuffers((GLsizei)self.models.count, indexBuffers);
    
    for (int i = 0; i < self.models.count; i++) {
        Model3D *model = [self.models objectAtIndex:i];
        glBindBuffer(GL_ARRAY_BUFFER, vertexBuffers[i]);
        glBufferData(GL_ARRAY_BUFFER, sizeof(model.vertices.values), model.vertices.values, GL_STATIC_DRAW);
        
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffers[i]);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(model.indices.values), model.indices.values, GL_STATIC_DRAW);
        
        model.texture = [self setupTexture:model.pathToTexture];
    }
}

@end
