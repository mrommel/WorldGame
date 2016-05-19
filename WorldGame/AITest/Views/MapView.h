//
//  MapView.h
//  AITest
//
//  Created by Michael Rommel on 15.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapPoint;

@protocol MapViewDelegate

- (void)focusChanged:(MapPoint *)newFocus;
- (void)longPressChanged:(MapPoint *)newFocus;

@end

/*!
 UIView that can display and interact with a Map
 */
@interface MapView : UIView

@property (atomic) BOOL showGrid;
@property (atomic) BOOL showDebug;
@property (nonatomic, weak) id <MapViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (id)initWithCoder:(NSCoder *)aDecoder;

- (void)moveToX:(NSInteger)x andY:(NSInteger)y;
- (void)redrawMap;

@end
