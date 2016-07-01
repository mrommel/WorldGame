//
//  OpenGLView.m
//  SimWorld
//
//  Created by Michael Rommel on 04.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "OpenGLView.h"

#import "CC3GLMatrix.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <math.h>

#import "OpenGLUtil.h"
#import "Transformations.h"
#import "ArcBallCamera.h"
#import "MathHelper.h"

#import "ZoomManager.h"
#import "GLPlane.h"
#import "GLRay.h"

#import "CubeMesh.h"
#import "CombatBoardMesh.h"
#import "CombatBoard.h"

#import "UIConstants.h"

static int kREDirectorDrawDatesCount    = 10;
static int kZoomDistance                = 50;

@interface OpenGLView () {
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    GLuint _colorRenderBuffer;
    GLuint _positionSlot;
    GLuint _colorSlot;
    NSTimer *_timer;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    GLuint _depthRenderBuffer;
    
    GLuint _texCoordSlot;
    GLuint _texCoordSlot2;
    GLint _samplerArrayLoc;
    
    GLuint _vertexBufferTerrains;
    GLuint _indexBufferTerrains;
    
    CombatBoardMesh *_terrainMesh;
    GLPlane *_groundPlane;
    
    ZoomManager *_zoomManager;
    BOOL _canZoom;
    
    BOOL showFPS;
    UIView *statsView;
    UILabel *statsLabel;
    NSMutableArray *drawDates;
    
    BOOL isAppInBackground; // Keep track of that the app has entered background to prevent drawing.
    BOOL controllerSetup;
}

@property (nonatomic, strong) ArcBallCamera *camera;

- (void)applicationDidBecomeActive:(NSNotification*)n;
- (void)applicationDidEnterBackground:(NSNotification*)n;
- (void)applicationWillResignActive:(NSNotification*)n;

@end

@implementation OpenGLView

- (id)initWithBoard:(CombatBoard *)board
{
    self = [super initWithFrame:CGRectMake(0, 20 + STATUSBAR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT - 20 - STATUSBAR_HEIGHT)];
    if (self) {
        self.board = board;
        [self setupLayer];
        [self setupContext];
        [self setupDepthBuffer];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        //[self startAnimation];
        [self compileShaders];
        [self setupVBOs];
        
        [self setupDisplayLink];
        [self setupGestureRecognizer];
        
        // Initialize transformations
        _zoomManager = [[ZoomManager alloc] init];
        [_zoomManager addZoomLevel:0.10f withName:@"pico"];
        [_zoomManager addZoomLevel:0.25f withName:@"local"];
        [_zoomManager addZoomLevel:0.50f withName:@"detail"];
        [_zoomManager addZoomLevel:0.75f withName:@"zoomed in"];
        [_zoomManager addZoomLevel:1.00f withName:@"normal"];
        [_zoomManager addZoomLevel:1.25f withName:@"zoomed out"];
        [_zoomManager addZoomLevel:1.50f withName:@"far"];
        [_zoomManager addZoomLevel:2.00f withName:@"global"];
        [_zoomManager setZoomName:@"normal"];
        _canZoom = YES;
        
        _groundPlane = [[GLPlane alloc] initWithPoint:GLKVector3Make(0, 0, 0) andNormal:GLKVector3Make(0, 1, 0)];
        
        GLKVector3 mapCenter = GLKVector3Make(20, 0, 20);
        self.camera = [[ArcBallCamera alloc] initWithTarget:mapCenter andRotationX:0 andRotationY:-(M_PI * 0.75f) andMinRotationY:-M_PI andMaxRotationY:0 andDistance:kZoomDistance andMinDistance:30 andMaxDistance:100];
        [self.camera update];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [self setShowFPS:YES];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Add new method before init
- (void)setupDisplayLink
{
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)detachDisplayLink
{
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
    isAppInBackground = YES;
}

- (void)startAnimation
{
    // no need to start
    if (_timer) {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(onTick:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stopAnimation
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
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

-(void)onTick:(NSTimer *)timer
{
    [self update];
    //[self render];
}

- (void)applicationDidBecomeActive:(NSNotification*)n {
    isAppInBackground = NO;
}

- (void)applicationWillResignActive:(NSNotification*)n {
    isAppInBackground = YES;
    glFinish();
}

- (void)applicationDidEnterBackground:(NSNotification*)n {
    // http://developer.apple.com/library/ios/#documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ImplementingaMultitasking-awareOpenGLESApplication/ImplementingaMultitasking-awareOpenGLESApplication.html#//apple_ref/doc/uid/TP40008793-CH5-SW1
    glFinish();
}

- (void)render:(CADisplayLink*)displayLink
{
    // Don't draw if we're in background!
    if (isAppInBackground) {
        return;
    }
    
    // FPS Stuff. May be moved?
    if (showFPS) {
        if (drawDates == nil) {
            drawDates = [[NSMutableArray alloc] initWithCapacity:kREDirectorDrawDatesCount];
        }
        [drawDates addObject:[NSDate date]];
        if ([drawDates count] > kREDirectorDrawDatesCount) {
            [drawDates removeObjectAtIndex:0];
        }
        [self updateStatsLabel:displayLink];
    }
    
    glClearColor(0.0/255.0, 20.0/255.0, 0.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);

    glEnable (GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    // Projection Matrix
    const GLKMatrix4 projectionMatrix = [self.camera projectionMatrix];
    glUniformMatrix4fv(_projectionUniform, 1, 0, projectionMatrix.m);
    
    // View Matrix
    const GLKMatrix4 viewMatrix = [self.camera viewMatrix];
    
    // ---------------------------------
    
    // Bind the base map
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _terrainMesh.texture);
    
    // Bind the river map
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _terrainMesh.riverTexture);
    
    // we've bound our textures in textures 0 and 1.
    const GLint samplers[2] = {0, 1};
    glUniform1iv(_samplerArrayLoc, 2, samplers);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTerrains);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferTerrains);
    
    glUniformMatrix4fv(_modelViewUniform, 1, 0, viewMatrix.m);

    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 3));
    glVertexAttribPointer(_texCoordSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    glVertexAttribPointer(_texCoordSlot2, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 9));
    
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glEnableVertexAttribArray(_texCoordSlot);
    glEnableVertexAttribArray(_texCoordSlot2);

    glDrawElements(GL_TRIANGLES, _terrainMesh.numberOfIndices, GL_UNSIGNED_INT, 0);
    
    // ---------------------------------
    


    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)update {
    NSLog(@"update");
}

- (void)compileShaders {
    
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
    _texCoordSlot2 = glGetAttribLocation(programHandle, "TexCoordIn2");
    glEnableVertexAttribArray(_texCoordSlot2);
    _samplerArrayLoc = glGetUniformLocation(programHandle, "texture");
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    
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

/*- (HexagonMapItem *)hexagonMapMesh:(HexagonMapMesh *)mesh didChooseX:(int)x andY:(int)y
{
    return [self.map. objectAtX:x andY:y];
}*/

- (void)setupVBOs
{
    TextureAtlas *textureAtlas = [[TextureAtlas alloc] initWithAtlasFileName:@"terrains"];
    TextureAtlas *riverAtlas = [[TextureAtlas alloc] initWithAtlasFileName:@"rivers"];
    _terrainMesh = [[CombatBoardMesh alloc] initWithBoard:self.board andTerrainAtlas:textureAtlas andRiverAtlas:riverAtlas];
    
    glGenBuffers(1, &_vertexBufferTerrains);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferTerrains);
    glBufferData(GL_ARRAY_BUFFER, _terrainMesh.numberOfVertices * sizeof(Vertex), _terrainMesh.vertices, GL_STATIC_DRAW);

    glGenBuffers(1, &_indexBufferTerrains);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferTerrains);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _terrainMesh.numberOfIndices * sizeof(Index), _terrainMesh.indices, GL_STATIC_DRAW);
}

#pragma mark -
#pragma mark fps handling

- (void)updateStatsLabel:(CADisplayLink*)displayLink
{
    NSString *text = nil;
    
    if ([drawDates count] == kREDirectorDrawDatesCount) {
        float targetFPS = 60.0f / displayLink.frameInterval;
        float actualFPS = ((float)kREDirectorDrawDatesCount) / [[drawDates lastObject] timeIntervalSinceDate:[drawDates objectAtIndex:0]];
        
        text = [NSString stringWithFormat:@"fps: %.1f (target %.1f)  -- %@", actualFPS, targetFPS, _zoomManager.currentZoomLevel.name];
    } else {
        text = @"Calculating...";
    }
    
    statsLabel.text = text;
}

- (void)updateStatsViewVisibility
{
    // Only create when first needed
    if (showFPS && statsView == nil) {
        statsView = [[UIView alloc] init];
        statsView.opaque = YES;
        statsView.autoresizesSubviews = YES;
        statsView.backgroundColor = [UIColor colorWithWhite:255.0f/255.0f alpha:0.5f];
        
        statsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, statsView.frame.size.width, statsView.frame.size.height)];
        statsLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        statsLabel.font = [UIFont boldSystemFontOfSize:12];
        [statsView addSubview:statsLabel];
    }
    
    // See if we should show it
    if (showFPS && statsView.superview != self) {
        [statsView removeFromSuperview];
        statsView.frame = CGRectMake(0, 24, self.frame.size.width, 20);
        [self addSubview:statsView];
    } else if (!showFPS && statsView.superview) {
        [statsView removeFromSuperview];
    }
}

- (void)setShowFPS:(BOOL)yesOrNo
{
    showFPS = yesOrNo;
    [self updateStatsViewVisibility];
}

#pragma mark -
#pragma mark gestures

- (void)setupGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:panGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    [self addGestureRecognizer:rotationGestureRecognizer];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Begin transformations
    _canZoom = YES;
}

- (IBAction)tap:(UIPanGestureRecognizer *)recognizer
{
    bool success = NO;
    GLfloat realY;
    
    GLint viewport[4] = {};
    glGetIntegerv(GL_VIEWPORT, viewport);
    NSLog(@"%d, %d, %d, %d", viewport[0], viewport[1], viewport[2], viewport[3]);
    
    CGPoint touchOrigin = [recognizer locationInView:recognizer.view];
    NSLog(@"tap coordinates: %8.2f, %8.2f", touchOrigin.x, touchOrigin.y);
    
    realY = viewport[3] - touchOrigin.y;
    
    const GLKMatrix4 viewMatrix = [self.camera viewMatrix];
    const GLKMatrix4 projectionMatrix = [self.camera projectionMatrix];
    
    // near
    GLKVector3 originInWindowNear = GLKVector3Make(touchOrigin.x, realY, 0.0f);
    
    GLKVector3 result1 = GLKMathUnproject(originInWindowNear, viewMatrix, projectionMatrix, viewport, &success);
    NSAssert(success == YES, @"unproject failure");

    GLKVector3 rayOrigin = GLKVector3Make(result1.x, result1.y, result1.z);
    
    // far
    GLKVector3 originInWindowFar = GLKVector3Make(touchOrigin.x, realY, 1.0f);
    
    GLKVector3 result2 = GLKMathUnproject(originInWindowFar, viewMatrix, projectionMatrix, viewport, &success);
    NSAssert(success == YES, @"unproject failure");

    GLKVector3 rayDirection = GLKVector3Make(result2.x - rayOrigin.x, result2.y - rayOrigin.y, result2.z - rayOrigin.z);
    GLRay *ray = [[GLRay alloc] initWithOrigin:_camera.position andDirection:rayDirection];
    GLKVector3 intersection;
    BOOL intersected = [ray intersectsPlane:_groundPlane atPoint:&intersection];
    
    if (intersected) {
        NSLog(@"Intersected at: %8.2f, %8.2f, %8.2f", intersection.x, intersection.y, intersection.z);
        
        int cursorx, cursory;
        //[HexPoint worldWithX:intersection.x andY:intersection.z toX:&cursorx andY:&cursory];
        
        NSLog(@"Intersected at: %d, %d", cursorx, cursory);
        // @TODO: drawCursor
    } else {
        NSLog(@"No intersection");
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    // Pan (1 Finger)
    if(sender.numberOfTouches == 1)
    {
        CGPoint translation = [sender translationInView:sender.view];
        float scale = 5;
        float dx = translation.x/sender.view.frame.size.width * scale * 0.5f;
        float dy = translation.y/sender.view.frame.size.height * scale;
        [self.camera translateBy:GLKVector3Make(-dx, 0, dy)];
        [self.camera update];
    }
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    // Pinch
    if (!_canZoom) return;
    float scale = [sender scale];
    
    if (scale > 1.0f) {
        [_zoomManager zoomIn];
        self.camera.distance = _zoomManager.currentZoomLevel.zoom * kZoomDistance;
        [self.camera update];
    } else if (scale < 1.0f) {
        [_zoomManager zoomOut];
        self.camera.distance = _zoomManager.currentZoomLevel.zoom * kZoomDistance;
        [self.camera update];
    }
    
    _canZoom = NO;
}

- (IBAction)rotation:(UIRotationGestureRecognizer *)sender
{
    // Rotation
    /*if ((self.transformations.state == S_NEW) || (self.transformations.state == S_ROTATION)) {
        float rotation = [sender rotation];
        [self.transformations rotate:GLKVector3Make(0.0f, 0.0f, rotation) withMultiplier:1.0f];
    }*/
}

@end
