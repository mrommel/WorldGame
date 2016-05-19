//
//  MapView.m
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MapView.h"

#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

#import "MapPoint.h"
#import "Plot.h"
#import "Map.h"
#import "Game.h"
#import "Continent.h"
#import "Plot.h"

static CGFloat const kHexagonWidth = 48;
static CGFloat const kHexagonHeight = 42;

static CGFloat const kLabelWidth = 100;
static CGFloat const kLabelHeight = 15;

static CGFloat const kZoomFactorOld = 0.7f;
static CGFloat const kZoomFactorNew = 0.3f;

// terrain colors
#define TERRAIN_OCEAN_COLOR     [UIColor blueColor]
#define TERRAIN_SHORE_COLOR     [UIColor colorWithRed:0/255.0f green:0/255.0f blue:128/255.0f alpha:255/255.0f]
#define TERRAIN_GRASS_COLOR     [UIColor greenColor]
#define TERRAIN_PLAIN_COLOR     [UIColor yellowColor]
#define TERRAIN_DESERT_COLOR    [UIColor colorWithRed:233/255.0 green:223/255.0 blue:182/255.0 alpha:1.0f]
#define TERRAIN_SNOW_COLOR      [UIColor colorWithRed:200/255.0f green:200/255.0f blue:255/255.0f alpha:255/255.0f]
#define TERRAIN_TUNDRA_COLOR    [UIColor grayColor]
#define TERRAIN_DEFAULT         [UIColor redColor]

@interface MapView()

@property (atomic) CGPoint lastLocation; // for pan
@property (atomic) CGPoint translation; // translation of the map
    
@property (nonatomic) MapPoint *focus;

@property (atomic) CGFloat scale;

@end

@implementation MapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setupValues];
        [self setupGestures];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self setupValues];
        [self setupGestures];
    }
    
    return self;
}

- (void)setupValues
{
    self.scale = 1.0f;
    self.translation = CGPointMake(0, 0);
    self.focus = [[MapPoint alloc] initWithX:0 andY:0];
    self.showGrid = NO;
}

- (void)setupGestures
{
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)]];
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    [self addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)]];
}

#pragma mark - setters

- (void)moveToX:(NSInteger)x andY:(NSInteger)y
{
    self.translation = CGPointMake(x, y);
    
    // schedule
    [self setNeedsDisplay];
}

- (void)redrawMap
{
    [self setNeedsDisplay];
}

#pragma mark - drawing methods

#define XFROMHEX(i, j, scale)   (i * kHexagonWidth * 3 / 4 * scale)
#define YFROMHEX(i, j, scale)   (j * kHexagonHeight * scale + (ODD(i) ? kHexagonHeight * scale / 2 : 0))

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextFillRect(ctx, self.bounds);
    
    int x, y;
    Plot *tile;
    
    // draw terrain
    for (int i = 0; i < [GameProvider sharedInstance].game.map.width; i++) {
        for (int j = 0; j < [GameProvider sharedInstance].game.map.height; j++) {
            x = self.bounds.origin.x + XFROMHEX(i, j, self.scale) + self.translation.x;
            y = self.bounds.origin.y + YFROMHEX(i, j, self.scale) + self.translation.y;
            tile = [[GameProvider sharedInstance].game.map tileAtX:i andY:j];
            
            [self drawHexagon:ctx atX:x andY:y forTile:tile];
            
            if ([tile hasOwner]) {
                [self drawHexagon:ctx atX:x andY:y forPopulationState:tile.populationState andPlayer:tile.owner];
            }
            
            // draw debug values
            if (self.showDebug) {
                // [self drawText:ctx withText:[NSString stringWithFormat:@"%.0f", tile.inhabitants] atPoint:CGPointMake(x, y)];
                if (tile.continent != nil) {
                    [self drawText:ctx withText:[NSString stringWithFormat:@"%ld", (long)tile.continent.identifier] atPoint:CGPointMake(x, y)];
                }
            }
        }
    }
    
    // draw cursor
    x = self.bounds.origin.x + XFROMHEX(self.focus.x, self.focus.y, self.scale) + self.translation.x;
    y = self.bounds.origin.y + YFROMHEX(self.focus.x, self.focus.y, self.scale) + self.translation.y;
    [self drawHexagonCursor:ctx atX:x andY:y];
}

- (CGMutablePathRef)hexagonPathWithX:(int)x andY:(int)y
{
#ifndef __clang_analyzer__
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, x + 0, y + kHexagonHeight * self.scale / 2);
    CGPathAddLineToPoint(path, NULL, x + kHexagonWidth * self.scale / 4, y + kHexagonHeight * self.scale);
    CGPathAddLineToPoint(path, NULL, x + kHexagonWidth * self.scale * 3 / 4, y + kHexagonHeight * self.scale);
    CGPathAddLineToPoint(path, NULL, x + kHexagonWidth * self.scale, y + kHexagonHeight * self.scale / 2);
    CGPathAddLineToPoint(path, NULL, x + kHexagonWidth * self.scale * 3 / 4, y + 0);
    CGPathAddLineToPoint(path, NULL, x + kHexagonWidth * self.scale / 4, y + 0);
    
    CGPathCloseSubpath(path);
    //NSLog(@"path: %@", [self descriptionOfPath:path]);
    
    return path;
#else
    return nil;
#endif
}

- (void)drawHexagon:(CGContextRef)ctx atX:(int)x andY:(int)y forTile:(Plot *)tile
{
    // draw terrain
    NSString *terrainAsset = [[MapDataProvider sharedInstance] terrainDataForMapTerrain:tile.terrain].image;
    UIImage *terrainImage = [UIImage imageNamed:terrainAsset];
    CGRect imageRect = { CGPointMake(x, y), CGSizeMake(kHexagonWidth * self.scale, kHexagonHeight * self.scale) };
    CGContextDrawImage(ctx, imageRect, terrainImage.CGImage);
    
    for (id featureObj in tile.features) {
        MapFeature feature = (MapFeature)[featureObj intValue];
        NSString *featureAsset = [[MapDataProvider sharedInstance] featureDataForMapFeature:feature].image;
        UIImage *featureImage = [UIImage imageNamed:featureAsset];
        CGRect imageRect = { CGPointMake(x, y), CGSizeMake(kHexagonWidth * self.scale, kHexagonHeight * self.scale) };
        CGContextDrawImage(ctx, imageRect, featureImage.CGImage);
    }
    
    // draw the features
#warning to do: draw features
    
    // Draw the grid lines
    if (self.showGrid) {
        CGMutablePathRef path = [self hexagonPathWithX:x andY:y];
        CGContextAddPath(ctx, path);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextStrokePath(ctx);
        CGPathRelease(path);
    }
    
    // draw the city (if any)
#warning to do: draw city
    
    // draw the units / armies
#warning to do: draw units
}

- (void)drawHexagon:(CGContextRef)ctx atX:(int)x andY:(int)y forPopulationState:(PlotPopulationState)populationState andPlayer:(Player *)player
{
    NSString *populationStateAsset = @"nomads.png";
    
    switch (populationState) {
        case PlotPopulationStateNomads:
            populationStateAsset = @"nomads.png";
            break;
        case PlotPopulationStateVillage:
            populationStateAsset = @"villages.png";
            break;
        case PlotPopulationStateTown:
            populationStateAsset = @"town.png";
            break;
        case PlotPopulationStateCity:
            populationStateAsset = @"city.png";
            break;
        case PlotPopulationStateMetropol:
            populationStateAsset = @"metropol.png";
            break;
    }
    
    UIImage *featureImage = [UIImage imageNamed:populationStateAsset];
    CGRect imageRect = { CGPointMake(x, y), CGSizeMake(kHexagonWidth * self.scale, kHexagonHeight * self.scale) };
    CGContextDrawImage(ctx, imageRect, featureImage.CGImage);
}

- (void)drawHexagonCursor:(CGContextRef)ctx atX:(int)x andY:(int)y
{
    CGMutablePathRef path = [self hexagonPathWithX:x andY:y];
    
    // Draw the path line
    CGContextAddPath(ctx, path);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}

- (void)drawText:(CGContextRef)ctx withText:(NSString *)text atPoint:(CGPoint)point
{
    UIFont *font = [UIFont fontWithName:@"Tele-GroteskNor" size:21];
    
    CGContextSaveGState(ctx);
    // Set an inverse matrix to draw the text
    CGContextSetTextMatrix(ctx, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CTTextAlignment alignment = kCTTextAlignmentCenter;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    // Create an attributed string
    CFStringRef keys[] = { kCTParagraphStyleAttributeName, kCTForegroundColorAttributeName, kCTFontAttributeName };
    CFTypeRef values[] = { paragraphStyle, [UIColor blackColor].CGColor, CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize * self.scale, NULL) };
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFAttributedStringRef attrString = CFAttributedStringCreate(NULL, (CFStringRef)text, attr);
    CFRelease(paragraphStyle);
    CFRelease(attr);
    // Create the Core Text framesetter using the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    // Create the Core Text frame using our current view rect bounds.
    UIBezierPath *tpath = [UIBezierPath bezierPathWithRect:
                           CGRectMake(point.x - kLabelWidth * self.scale / 2 + kHexagonWidth * self.scale / 2, point.y - kLabelHeight * self.scale / 2 + kHexagonHeight * self.scale / 2, kLabelWidth * self.scale, kLabelHeight * self.scale)];
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), [tpath CGPath], NULL);
    CTFrameDraw(frame, ctx);
    CFRelease(attrString);
    CGContextRestoreGState(ctx);
}

#pragma mark - util methods

+ (void)worldWithX:(float)rx andY:(float)ry toX:(int *)hx andY:(int *)hy
{
    //  FI  FII
    //+---+---+
    //|  / \  |
    //|/     \|
    //+       +
    //|       |
    //+       +
    //|\     /|
    //|  \ /  |
    //+---+---+
    
    int deltaWidth = (kHexagonWidth * 3 / 4) / 2;
    int ergx;
    bool moved;
    
    ry -= 10;
    
    //rough rastering
    int ergy = ry / kHexagonHeight;
    if (ergy % 2 == 1)
    {
        moved = false;
        ergx = rx / (kHexagonWidth * 3 / 4);
    }
    else
    {
        moved = true;
        ergx = (rx - deltaWidth) / (kHexagonWidth * 3 / 4);
    }
    
    // fix errors
    int crossPoint; //X
    if (moved)
        crossPoint = ergx * (kHexagonWidth * 3 / 4) + deltaWidth;
    else
        crossPoint = ergx * (kHexagonWidth * 3 / 4);
    
    // error I
#warning the error is here
    double tmp = -(22.0 / 8.0) * (ry - ergy * kHexagonHeight) + crossPoint;
    
    if (((rx - deltaWidth) < tmp) && (moved))
    {
        ergy--;
    }
    if (((rx - deltaWidth) < tmp) && (!moved))
    {
        ergx--;
        ergy--;
    }
    
    // error II
#warning and here
    tmp = (22.0 / 8.0) * (ry - ergy * kHexagonHeight) + crossPoint;
    if (((rx - deltaWidth) > tmp) && (moved))
    {
        ergy--;
        ergx++;
    }
    if (((rx - deltaWidth) > tmp) && (!moved))
    {
        ergy--;
    }
    
    // make it real
    if (hx && hy) {
        (*hx) = (ergx < 0) ? -1 : ergx;
        (*hy) = (ergy < 0) ? -1 : ergy;
    }
}

#pragma mark - gesture methods

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer
{
    if ( recognizer.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press");
        CGPoint location = [recognizer locationInView:self];
        
        // add map transation
        location.x -= self.translation.x;
        location.y -= self.translation.y;
        
        int rx, ry;
        [MapView worldWithX:location.x andY:location.y toX:&rx andY:&ry];
        
        // NSLog(@"tile: %d, %d", rx, ry);
        self.focus.x = rx;
        self.focus.y = ry;
        
        [self.delegate longPressChanged:self.focus];
        
        // schedule
        [self setNeedsDisplay];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    
    // add map transation
    location.x -= self.translation.x;
    location.y -= self.translation.y;
    
    int rx, ry;
    [MapView worldWithX:location.x andY:location.y toX:&rx andY:&ry];
    
    // NSLog(@"tile: %d, %d", rx, ry);
    self.focus.x = rx;
    self.focus.y = ry;
    
    [self.delegate focusChanged:self.focus];

    // schedule
    [self setNeedsDisplay];
}

- (void)handlePan:(UIPanGestureRecognizer *)sender
{
    CGPoint translate = [sender translationInView:self];
   
    self.translation = CGPointMake(self.lastLocation.x + translate.x, self.lastLocation.y + translate.y);
    
    if(sender.state == UIGestureRecognizerStateEnded) {
        // NSLog(@"pan ended");
    }
    
    [self setNeedsDisplay];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)sender
{
    // Pinch
    float scale = [sender scale];
    float step = 0.0f;
    
    if (scale > 1.0f) {
        NSLog(@"zoomIn");
        step = self.scale * 1.3f;
    } else if (scale < 1.0f) {
        NSLog(@"zoomOut");
        step = self.scale * 0.7f;
    }
    self.scale = (kZoomFactorOld * self.scale + kZoomFactorNew * step) / (kZoomFactorOld + kZoomFactorNew);
    
    // schedule
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Remember original location
    self.lastLocation = self.translation;
}

@end
