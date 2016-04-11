//
//  ChartView.h
//  AITest
//
//  Created by Michael Rommel on 07.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setValues:(NSArray *)values;

@end
