//
//  DateUtils.m
//  WorldGame
//
//  Created by Michael Rommel on 20.04.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

static NSString *const kShortStringFormat = @"dd.MMM.YYYY";
static NSString *const kLongStringFormat = @"dd.MMM.YYYY HH:mm";

+ (NSString *)shortStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kShortStringFormat;
    
    return [formatter stringFromDate:date];
}

+ (NSString *)longStringFromDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = kLongStringFormat;
    
    return [formatter stringFromDate:date];
}

@end
