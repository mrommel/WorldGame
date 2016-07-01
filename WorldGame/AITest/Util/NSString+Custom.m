//
//  NSString+Custom.m
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString(Custom)

-(NSString*) limitFirstlineToMaxChars:(NSInteger)maxChars {
    
    NSMutableString* mS = [[NSMutableString alloc] initWithString:self];
    NSInteger indexOfWhitespaceToReplace = 0;
    NSString* scanned = [[NSString alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:mS];
    
    NSCharacterSet *newlineSet = [NSCharacterSet newlineCharacterSet];
    
    [scanner scanUpToCharactersFromSet:newlineSet intoString:&scanned];
    if([scanned length] <= maxChars){
        return self;
    }
    
    scanner = [NSScanner scannerWithString:mS];
    
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
    
    while ([scanner scanUpToCharactersFromSet:whiteSpace intoString:&scanned]){
        if(indexOfWhitespaceToReplace + [scanned length]+1 > maxChars){
            break;
        }else{
            indexOfWhitespaceToReplace += [scanned length]+1;
        }
    }
    
    [mS replaceCharactersInRange:NSMakeRange(indexOfWhitespaceToReplace-1, 1) withString:@"\n"];
    return mS;
}

-(NSString*) limitToMaxChars: (NSInteger)maxChars {
    
    if([self length] < maxChars) {
        return self;
    }
    
    return [self substringToIndex: maxChars];
}

-(NSString*) trim
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString*)trimWithCharacter:(char)character
{
    return [self stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"%c",character]]];
}

-(NSMutableString*) replaceString: (NSString*)pattern
                       withString: (NSString*)replacement {
    
    NSMutableString *help = [self mutableCopy];
    
    if(!replacement){
        return help;
    }
    
    [help replaceOccurrencesOfString: pattern
                          withString: replacement
                             options: NSCaseInsensitiveSearch
                               range: NSMakeRange(0, [help length])];
    
    return help;
}

-(BOOL) isEmpty {
    return [[self trim] isEqualToString: @""];
}

- (int) indexOf:(NSString *)text {
    NSRange range = [self rangeOfString:text];
    if ( range.length > 0 ) {
        return (int)range.location;
    } else {
        return -1;
    }
}

-(BOOL) contains:(NSString*)subString{
    return [self containsString:subString];
}

-(NSString*) stringByRemovingCharactersInSet:(NSCharacterSet *)set{
    return [[self componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
}

- (BOOL)containsString:(NSString *)string
               options:(NSStringCompareOptions)options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

+(NSString*)formatFileSize:(NSInteger) fileSize {
    float floatSize = fileSize;
    floatSize = floatSize / 1024;
    if (floatSize < 1024) {
        return([NSString stringWithFormat:@"%1.1f KB", floatSize]);
    }
    floatSize = floatSize / 1024;
    if (floatSize < 1024) {
        return([NSString stringWithFormat:@"%1.1f MB", floatSize]);
    }
    floatSize = floatSize / 1024;
    
    return([NSString stringWithFormat:@"%1.1f GB", floatSize]);
}

+(NSString*) formatTimeDistanceShort:(NSInteger) seconds postfix:(NSString*)postfix{
    
    NSMutableString* string = [[NSMutableString alloc] init];
    
    NSInteger hrs = seconds / (60 * 60);
    if(hrs != 0){
        seconds -= hrs * (60 * 60);
        
        if(hrs < 10){
            [string appendFormat:@"0%ld:",(long)hrs];
        }else{
            [string appendFormat:@"%ld:",(long)hrs];
        }
    }
    
    NSInteger mins = seconds / 60;
    
    if(mins != 0){
        seconds -= mins * 60;
    }
    
    NSInteger secs = seconds;
    
    if(mins < 10){
        [string appendFormat:@"0%ld:",(long)mins];
    }else{
        [string appendFormat:@"%ld:",(long)mins];
    }
    
    if(secs < 10){
        [string appendFormat:@"0%ld",(long)secs];
    }else{
        [string appendFormat:@"%ld",(long)secs];
    }
    
    return postfix ? [string stringByAppendingString:postfix] : string;
}

+(NSString*) formatTimeDistance:(NSInteger) seconds{
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
