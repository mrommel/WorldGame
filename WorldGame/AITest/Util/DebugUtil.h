//
//  DebugUtil.h
//  AITest
//
//  Created by Michael Rommel on 13.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>

@interface DebugUtil : NSObject

+ (NSString *)descriptionOfPath:(CGPathRef)cgPath;

@end
