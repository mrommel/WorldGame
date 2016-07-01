//
//  TextureAtlas.m
//  SimWorld
//
//  Created by Michael Rommel on 20.10.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "TextureAtlas.h"

#import "OpenGLUtil.h"
#import "XMLReader.h"
#import "NSDictionary+Extension.h"

@interface TextureAtlasItem : NSObject

@property (nonatomic, copy) NSNumber *Index;
@property (nonatomic, copy) NSString *Name;

- (id)initWithName:(NSString *)name andIndexNumber:(NSNumber *)number;
- (id)initWithName:(NSString *)name andIndex:(int)number;

@end

@implementation TextureAtlasItem

- (id)initWithName:(NSString *)name andIndexNumber:(NSNumber *)number
{
    self = [super init];
    if (self) {
        self.Name = name;
        self.Index = number;
    }
    return self;
}

- (id)initWithName:(NSString *)name andIndex:(int)number
{
    return [self initWithName:name andIndexNumber:[NSNumber numberWithInt:number]];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"[TextureAtlasItem:%@, %@]", self.Name, self.Index];
}

@end

@interface TextureAtlas () {
    int _columns;
    int _rows;
}

@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) UIImage *image;

@end

@implementation TextureAtlas

- (id)initWithAtlasFileName:(NSString *)atlasFilename
{
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:atlasFilename ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    NSError *error = nil;
    NSDictionary *atlasDict = [XMLReader dictionaryForXMLData:xmlData error:&error];
    
    if (error) {
        return nil;
    }
    
    int dictRows = [atlasDict getIntValueForKeyPath:@"Atlas/Rows" withDefaultValue:0];
    int dictCols = [atlasDict getIntValueForKeyPath:@"Atlas/Cols" withDefaultValue:0];
    NSString *textureFileName = [atlasDict getValueForKeyPath:@"Atlas/Texture" withDefaultValue:@""];
    
    self.items = [[NSMutableArray alloc] init];
    NSArray *items = [atlasDict getArrayForKeyPath:@"Atlas/Items/Item"];
    for (NSDictionary *dict in items) {
        int index = [dict getIntValueForKeyPath:@"Index" withDefaultValue:0];
        NSString *name = [dict getValueForKeyPath:@"Name"];
        
        [self.items addObject:[[TextureAtlasItem alloc] initWithName:name andIndex:index]];
    }
    
    self = [self initWithTexture:textureFileName andColumns:dictCols andRows:dictRows];
    self.image = [UIImage imageNamed:textureFileName];
    
    return self;
}

- (id)initWithTexture:(NSString *)textureFileName andColumns:(int)columns andRows:(int)rows
{
    self = [super init];
    
    if (self) {
        _columns = columns;
        _rows = rows;
        
        self.texture = [[OpenGLUtil sharedInstance] setupTexture:textureFileName];
    }
    
    return self;
}

- (CGRect)tileForIndex:(int)frameIndex
{
    return [self tileForColumn:frameIndex % _columns andRow:frameIndex / _columns];
}

- (CGRect)tileForColumn:(int)col andRow:(int)row
{
    if (col < 0 || row < 0 || col >= _columns || row >= _rows) {
        return CGRectZero;
    }
    
    CGFloat x = ((float)col) / _columns;
    CGFloat y = ((float)row) / _rows;
    CGFloat width = 1.0f / _columns;
    CGFloat height = 1.0f / _rows;
    return CGRectMake(x, y, width, height);
}

- (CGRect)tileForName:(NSString *)name
{
    for (TextureAtlasItem *item in self.items) {
        if ([item.Name isEqualToString:name]) {
            return [self tileForIndex:[item.Index intValue]];
        }
    }
    NSLog(@"Atlas: No hit for %@", name);
    return CGRectZero;
}

- (UIImage *)imageForIndex:(int)frameIndex
{
    return [self imageForColumn:frameIndex % _columns andRow:frameIndex / _columns];
}

- (UIImage *)imageForColumn:(int)col andRow:(int)row
{
    if (col < 0 || row < 0 || col >= _columns || row >= _rows) {
        return nil;
    }
    
    CGFloat x = (((float)col) / _columns) * self.image.size.width;
    CGFloat y = (((float)row) / _rows) * self.image.size.height;
    CGFloat width = self.image.size.width / _columns;
    CGFloat height = self.image.size.height / _rows;
    
    CGImageRef sprite = CGImageCreateWithImageInRect([self.image CGImage],CGRectMake(x, y, width, height));
    return [UIImage imageWithCGImage:sprite];
}

- (UIImage *)imageForName:(NSString *)name
{
    for (TextureAtlasItem *item in self.items) {
        if ([item.Name isEqualToString:name]) {
            return [self imageForIndex:[item.Index intValue]];
        }
    }
    NSLog(@"Atlas: No hit for %@", name);
    return nil;
}

@end
