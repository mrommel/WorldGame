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

@interface GraphRenderer : NSObject

/*!
 *
 */
- (void)drawString:(NSString *)string withFont:(UIFont *)font andColor:(UIColor *)color inRect:(CGRect)contextRect;

/*!
 *
 */
- (void)fillContext:(CGContextRef)ctx withRect:(CGRect)rect andColor:(UIColor *)fillColor;

@end
