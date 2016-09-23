//
//  GraphTitleRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 23.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphTitleRenderer : NSObject

@property (nonatomic) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;

- (void)drawWithContext:(CGContextRef)ctx andCanvasRect:(CGRect)rect;

@end
