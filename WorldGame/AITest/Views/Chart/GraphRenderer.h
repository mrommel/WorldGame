//
//  GraphRenderer.h
//  WorldGame
//
//  Created by Michael Rommel on 26.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

/*!
 *
 */
@interface Line : NSObject

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGPoint destination;

- (instancetype)initWithOrigin:(CGPoint)origin andDestination:(CGPoint)destination;
- (instancetype)initWithOriginX:(CGFloat)originX andOriginY:(CGFloat)originY andDestinationX:(CGFloat)destinationX andDestinationY:(CGFloat)destinationY;

@end

/*!
 *
 */
@interface GraphRenderer : NSObject

/*!
 *
 */
- (void)drawString:(NSString *)string withFont:(UIFont *)font andColor:(UIColor *)color inRect:(CGRect)contextRect;

/*!
 *
 */
- (void)fillContext:(CGContextRef)ctx withRect:(CGRect)rect andColor:(UIColor *)fillColor;

/*!
 *
 */
- (void)drawContext:(CGContextRef)ctx withLine:(Line *)line andColor:(UIColor *)color;


@end
