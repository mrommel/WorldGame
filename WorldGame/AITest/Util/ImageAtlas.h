//
//  ImageAtlas.h
//  AITest
//
//  Created by Michael Rommel on 18.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageAtlas : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *texture;
@property (atomic) int rows;
@property (atomic) int columns;

- (instancetype)initWithFilename:(NSString *)atlasFileName;

+ (UIImage *)imageNamed:(NSString *)imageKey fromAtlasNamed:(NSString *)atlas;

@end
