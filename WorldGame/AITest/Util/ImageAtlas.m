//
//  ImageAtlas.m
//  AITest
//
//  Created by Michael Rommel on 18.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "ImageAtlas.h"

#import <UIKit/UIKit.h>

#import "XMLReader.h"
#import "NSDictionary+Extension.h"
#import "UIImage+Sprite.h"

@interface ImageAtlasItem : NSObject

@property (atomic) int identifier;
@property (nonatomic) NSString *name;

- (instancetype)initWithName:(NSString *)name andIdentifier:(int)identifier;

@end

@implementation ImageAtlasItem

- (instancetype)initWithName:(NSString *)name andIdentifier:(int)identifier
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.identifier = identifier;
    }
    
    return self;
}

@end



@interface ImageAtlas()

@property (nonatomic) NSMutableDictionary *atlasEntries;

@end

@implementation ImageAtlas

static NSMutableDictionary *shared = nil;

+ (NSMutableDictionary *)sharedAtlasses
{
    @synchronized (self) {
        if (shared == nil) {
            shared = [[NSMutableDictionary alloc] init];
        }
    }
    
    return shared;
}

+ (UIImage *)imageNamed:(NSString *)imageKey fromAtlasNamed:(NSString *)atlasName
{
    NSMutableDictionary *atlasses = [ImageAtlas sharedAtlasses];
    ImageAtlas *atlas = [atlasses objectForKey:atlasName];
    
    if (atlas == nil) {
        atlas = [[ImageAtlas alloc] initWithFilename:atlasName];
        [atlasses setObject:atlas forKey:atlasName];
    }
    
    return [atlas imageForName:imageKey];
}

- (instancetype)initWithFilename:(NSString *)atlasFileName
{
    self = [super init];
    
    if (self) {
        NSDictionary *dict = [self dictFromName:atlasFileName];
        
        self.name = [dict objectForPath:@"Atlas|Name|text"];
        self.texture = [dict objectForPath:@"Atlas|TextureName|text"];
        self.rows = [[dict objectForPath:@"Atlas|Rows|text"] intValue];
        self.columns = [[dict objectForPath:@"Atlas|Columns|text"] intValue];
        
        self.atlasEntries = [NSMutableDictionary new];
        
        NSMutableArray *items = [NSMutableArray new];
        for (id entry in [dict arrayForPath:@"Atlas|Tiles|Item"]) {
            //NSLog(@"entry: %@",entry );
            NSString *name = [entry objectForPath:@"Name|text"];
            int identifier = [[entry objectForPath:@"Index|text"] intValue];
            [items addObject:[[ImageAtlasItem alloc] initWithName:name andIdentifier:identifier]];
        }
        
        UIImage *source = [UIImage imageNamed:self.texture];
        NSArray *tiles = [source spritesWithSpriteSheetImage:source spriteSize:CGSizeMake(source.size.width / self.columns, source.size.height / self.rows)];
        for (ImageAtlasItem *item in items) {
            UIImage *image = [tiles objectAtIndex:item.identifier];
            [self.atlasEntries setObject:image forKey:item.name];
        }
    }
    
    return self;
}

- (UIImage *)imageForName:(NSString *)name
{
    UIImage *image = [self.atlasEntries objectForKey:name];
    
    NSAssert(image != nil, @"Image with name '%@' not in atlas", name);
    
    return image;
}

#pragma mark - 
#pragma mark helper functions

- (NSDictionary *)dictFromName:(NSString *)fileName
{
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:filePath1 options:NSDataReadingUncached error:&error];
    NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    return dict;
}

- (NSArray *)spritesWithSpriteSheetImage:(UIImage *)image
                                 inRange:(NSRange)range
                              spriteSize:(CGSize)size
{
    if (!image || CGSizeEqualToSize(size, CGSizeZero) || range.length == 0)
    {
        return nil;
    }
    
    CGImageRef spriteSheet = [image CGImage];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    CGFloat width = CGImageGetWidth(spriteSheet);
    CGFloat height = CGImageGetHeight(spriteSheet);
    
    NSUInteger maxI = (NSUInteger)(width / size.width);
    
    NSUInteger startI = 0;
    NSUInteger startJ = 0;
    NSUInteger length = 0;
    
    NSUInteger startPosition = range.location;
    
    // Extracting initial I & J values from range info
    if (startPosition != 0)
    {
        for (int k=1; k<=maxI; k++)
        {
            NSUInteger d = k * maxI;
            
            if (d/startPosition == 1)
            {
                startI = maxI - (d % startPosition);
                break;
            }
            else if (d/startPosition > 1)
            {
                startI = startPosition;
                break;
            }
            
            startJ++;
        }
    }
    
    CGFloat positionX = startI * size.width;
    CGFloat positionY = startJ * size.height;
    BOOL isReady = NO;
    
    while (positionY < height)
    {
        while (positionX < width)
        {
            CGImageRef sprite = CGImageCreateWithImageInRect(spriteSheet,
                                                             CGRectMake(positionX,
                                                                        positionY,
                                                                        size.width,
                                                                        size.height));
            [tempArray addObject:[UIImage imageWithCGImage:sprite]];
            
            CGImageRelease(sprite);
            
            length++;
            
            if (length == range.length)
            {
                isReady = YES;
                break;
            }
            
            positionX += size.width;
        }
        
        if (isReady) break;
        
        positionX = 0;
        positionY += size.height;
    }
    
    return [NSArray arrayWithArray:tempArray];
}

@end
