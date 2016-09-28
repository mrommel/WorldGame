//
//  GraphBackgroundRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 27.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphRenderer.h"

@interface GraphBackgroundRenderer : GraphRenderer

@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIImage *backgroundImage;

- (instancetype)init;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end
