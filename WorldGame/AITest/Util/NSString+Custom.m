//
//  NSString+Custom.m
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString(Custom)

+ (NSString*)formatTimeDistance:(NSInteger)seconds
{
    NSMutableString* time = [[NSMutableString alloc] init];
    NSInteger days = seconds / (60 * 60 * 24);
    if(days!=0){
        [time appendFormat:@" %ld Tag",(long)days];
        if(days != 1){
            [time appendString:@"en"];
        }
        seconds -= days * (60 * 60 * 24);
    }
    NSInteger hours = seconds / (60 * 60);
    if(hours!=0){
        [time appendFormat:@" %ld Stunde",(long)hours];
        if(hours != 1){
            [time appendString:@"n"];
        }
        seconds -= hours * (60 * 60);
    }
    NSInteger minutes = seconds / 60;
    if(minutes != 0){
        if(days == 0){
            [time appendFormat:@" %ld Minute",(long)minutes];
            if(minutes != 1){
                [time appendString:@"n"];
            }
        }
        seconds -= minutes * 60;
    }
    if(days == 0 && hours == 0){
        [time appendFormat:@" %ld Sekunde",(long)seconds];
        if(seconds != 1){
            [time appendString:@"n"];
        }
    }
    return time;
    
}

@end
