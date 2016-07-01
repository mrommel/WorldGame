//
//  ZoomManager.m
//  SimWorld
//
//  Created by Michael Rommel on 03.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import "ZoomManager.h"

@implementation ZoomLevel

- (id)initWithName:(NSString *)name andLevel:(float)zoom
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.zoom = zoom;
    }
    
    return self;
}

@end

@interface ZoomManager() {
    
}

@property (nonatomic,retain) NSMutableArray *levels;
@property (atomic)          int             current;

@end

@implementation ZoomManager

- (id)init
{
    self = [super init];
    
    if (self) {
        self.levels = [[NSMutableArray alloc] init];
        self.current = 0;
    }
    
    return self;
}

- (void)addZoomLevel:(float)zoomLevel withName:(NSString *)zoomName
{
    [self.levels addObject:[[ZoomLevel alloc] initWithName:zoomName andLevel:zoomLevel]];
    
    [self.levels sortedArrayUsingComparator:^(id obj1, id obj2) {
        if ([obj1 isKindOfClass:[ZoomLevel class]] && [obj2 isKindOfClass:[ZoomLevel class]]) {
            ZoomLevel *s1 = obj1;
            ZoomLevel *s2 = obj2;
            
            if (s1.zoom > s2.zoom) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if (s1.zoom < s2.zoom) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }

        return (NSComparisonResult)NSOrderedSame;
    }];
}

- (void)zoomIn
{
    if (self.current > 0) {
        self.current--;
    }
}

- (void)zoomOut
{
    if (self.current < ([self.levels count] - 1)) {
        self.current++;
    }
}

- (void)setZoomName:(NSString *)zoomName
{
    int i = 0;
    for (ZoomLevel *level in self.levels) {
        if ([level.name isEqualToString:zoomName]) {
            self.current = i;
        }
        i++;
    }
}

- (void)setZoomLevel:(float)zoomLevel
{
    int i = 0;
    for (ZoomLevel *level in self.levels) {
        if (level.zoom == zoomLevel) {
            self.current = i;
        }
        i++;
    }
}

- (ZoomLevel *)currentZoomLevel
{
    return [self.levels objectAtIndex:self.current];
}

@end
