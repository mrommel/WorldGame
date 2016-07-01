//
//  ZoomManager.h
//  SimWorld
//
//  Created by Michael Rommel on 03.12.14.
//  Copyright (c) 2014 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoomLevel : NSObject

@property (nonatomic,retain) NSString *name;
@property (atomic)              float zoom;

- (id)initWithName:(NSString *)name andLevel:(float)zoom;

@end

@interface ZoomManager : NSObject

- (id)init;

- (void)addZoomLevel:(float)zoomLevel withName:(NSString *)zoomName;
- (void)zoomIn;
- (void)zoomOut;
- (void)setZoomName:(NSString *)zoomName;
- (void)setZoomLevel:(float)zoomLevel;

- (ZoomLevel *)currentZoomLevel;

@end
