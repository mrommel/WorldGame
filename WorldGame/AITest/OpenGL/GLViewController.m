//
//  GLViewController.m
//  Rend Example Collection
//
//  Created by Anton Holmquist on 6/26/12.
//  Copyright (c) 2012 Monterosa. All rights reserved.
//

#import "GLViewController.h"

#import "UIConstants.h"
#import "GLPlane.h"
#import "ZoomManager.h"
#import "GLRay.h"

#define kZoomDistance       50

@interface GLViewController () {
    BOOL _canZoom;
    GLPlane *_groundPlane;
    ZoomManager *_zoomManager;
}

@end

@implementation GLViewController

@synthesize glView = glView_;
@synthesize scene = scene_;
@synthesize world = world_;
@synthesize camera = camera_;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scale = 5;
    
    glView_ = [[REGLView alloc] initWithFrame:CGRectMake(0, 20 + STATUSBAR_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT - 20 - STATUSBAR_HEIGHT) colorFormat:kEAGLColorFormatRGBA8 multisampling:YES];
    [self.view addSubview:glView_];
    
    camera_ = [[RECamera alloc] initWithProjection:kRECameraProjectionArcBall];
    camera_.target = CC3VectorMake(0, 0, 0);
    camera_.upDirection = CC3VectorMake(0, -1, 0);
    camera_.lookDirection = CC3VectorMake(0, 0, -1);
    camera_.rotation = CC3VectorMake(3.1415, -(M_PI * 0.75f), 0);
    camera_.distance = kZoomDistance;
    
    scene_ = [[REScene alloc] init];
    scene_.camera = camera_;    
    
    world_ = [[REWorld alloc] init];
    [scene_ addChild:world_];
    
    director_ = [[REDirector alloc] init];
    director_.view = glView_;
    director_.scene = scene_;
    
    // Initialize transformations
    _zoomManager = [[ZoomManager alloc] init];
    [_zoomManager addZoomLevel:0.01f withName:@"nano"];
    [_zoomManager addZoomLevel:0.10f withName:@"pico"];
    [_zoomManager addZoomLevel:0.25f withName:@"local"];
    [_zoomManager addZoomLevel:0.50f withName:@"detail"];
    [_zoomManager addZoomLevel:0.75f withName:@"zoomed in"];
    [_zoomManager addZoomLevel:1.00f withName:@"normal"];
    [_zoomManager addZoomLevel:1.25f withName:@"zoomed out"];
    [_zoomManager addZoomLevel:1.50f withName:@"far"];
    [_zoomManager addZoomLevel:2.00f withName:@"global"];
    [_zoomManager addZoomLevel:10.00f withName:@"luna"];
    [_zoomManager addZoomLevel:50.00f withName:@"alpha centauri"];
    [_zoomManager setZoomName:@"normal"];
    
    _canZoom = YES;
    
    _groundPlane = [[GLPlane alloc] initWithPoint:GLKVector3Make(0, 0, 0) andNormal:GLKVector3Make(0, 1, 0)];
    
    [self setupGestureRecognizer];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    glView_ = nil;
    director_ = nil;
    scene_ = nil;
    world_ = nil;
    camera_ = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    director_.running = YES;
    [[REScheduler sharedScheduler] scheduleUpdateForTarget:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    director_.running = NO;
    [[REScheduler sharedScheduler] unscheduleUpdateForTarget:self];
}

- (void)update:(float)dt
{
}

#pragma mark -
#pragma mark zooming / center

- (void)zoomIn
{
    [_zoomManager zoomIn];
    self.camera.distance = _zoomManager.currentZoomLevel.zoom * kZoomDistance;
}

- (void)zoomOut
{
    [_zoomManager zoomOut];
    self.camera.distance = _zoomManager.currentZoomLevel.zoom * kZoomDistance;
}

- (NSString *)getZoomLevel
{
    return [_zoomManager currentZoomLevel].name;
}

#pragma mark -

- (void)center
{
    camera_.target = CC3VectorMake(0, 0, 0);
}

#pragma mark -
#pragma mark gestures

- (void)setupGestureRecognizer
{
    [self.glView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    [self.glView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [self.glView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
    [self.glView addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)]];
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
    
    const GLKMatrix4 viewMatrix = GLKMatrix4MakeWithArray([self.camera viewMatrix].glMatrix);
    const GLKMatrix4 projectionMatrix = GLKMatrix4MakeWithArray([self.camera projectionMatrix].glMatrix);
    
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
    GLRay *ray = [[GLRay alloc] initWithOrigin:GLKVector3Make(self.camera.position.x, self.camera.position.y, self.camera.position.z) andDirection:rayDirection];
    GLKVector3 intersection;
    BOOL intersected = [ray intersectsPlane:_groundPlane atPoint:&intersection];
    
    if (intersected) {
        NSLog(@"Intersected at: %8.2f, %8.2f, %8.2f", intersection.x, intersection.y, intersection.z);
        
        int cursorx, cursory;
        //[HexPoint worldWithX:intersection.x andY:intersection.z toX:&cursorx andY:&cursory];
        
        //NSLog(@"Intersected at: %d, %d", cursorx, cursory);
        // @TODO: drawCursor
    } else {
        NSLog(@"No intersection");
    }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
    // Pan (1 Finger)
    if (sender.numberOfTouches == 1)
    {
        CGPoint translation = [sender translationInView:sender.view];
        float dx = translation.x/sender.view.frame.size.width * self.scale * 0.5f;
        float dz = translation.y/sender.view.frame.size.height * self.scale;
        self.camera.target = CC3VectorMake(self.camera.target.x - dx, self.camera.target.y, self.camera.target.z + dz);
    }
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    // Pinch
    if (!_canZoom) return;
    float scale = [sender scale];
    
    if (scale > 1.0f) {
        [self zoomIn];
    } else if (scale < 1.0f) {
        [self zoomOut];
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
