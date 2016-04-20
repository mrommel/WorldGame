//
//  DateUtils.h
//  WorldGame
//
//  Created by Michael Rommel on 20.04.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+ (NSString *)shortStringFromDate:(NSDate *)date;
+ (NSString *)longStringFromDate:(NSDate *)date;

@end
