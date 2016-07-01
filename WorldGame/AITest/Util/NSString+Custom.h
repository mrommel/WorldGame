//
//  NSString+Custom.h
//  AITest
//
//  Created by Michael Rommel on 29.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Custom)

-(NSString*) limitFirstlineToMaxChars:(NSInteger)maxChars;
-(NSString*) limitToMaxChars:(NSInteger)maxChars;

+(NSString*) formatFileSize:(NSInteger)fileSize;
+(NSString*) formatTimeDistance:(NSInteger)seconds;
+(NSString*) formatTimeDistanceShort:(NSInteger) seconds postfix:(NSString*)postfix;

-(BOOL) contains:(NSString*)subString;
-(BOOL) containsString:(NSString *)string;
-(BOOL) containsString:(NSString *)string
               options:(NSStringCompareOptions) options;

-(NSString*) stringByRemovingCharactersInSet:(NSCharacterSet *)set;

- (NSString*)trim;
- (NSString*)trimWithCharacter:(char)character;
-(NSMutableString*) replaceString: (NSString*)pattern
                       withString: (NSString*)replacement;
-(int) indexOf:(NSString *)text;
-(BOOL) isEmpty;

@end
