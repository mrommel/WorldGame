//
//  GraphTitleRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphRenderer.h"

@interface GraphTitleRenderer : GraphRenderer

// properties
@property (nonatomic) NSString *title;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *titleColor;

- (instancetype)initWithTitle:(NSString *)title;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end
