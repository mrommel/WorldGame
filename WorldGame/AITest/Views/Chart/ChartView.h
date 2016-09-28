//
//  ChartView.h
//  AITest
//
//  Created by Michael Rommel on 07.03.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "GraphData.h"
#import "GraphDataEntry.h"
#import "GraphBackgroundRenderer.h"

/*!
 * color schemes
 */
// pastell
#define GraphColorSchemePastellColors [NSArray arrayWithObjects:\
[UIColor colorWithRed:64/255.0f green:89/255.0f blue:128/255.0f alpha:1.0f],\
[UIColor colorWithRed:149/255.0f green:165/255.0f blue:124/255.0f alpha:1.0f],\
[UIColor colorWithRed:217/255.0f green:184/255.0f blue:162/255.0f alpha:1.0f],\
[UIColor colorWithRed:191/255.0f green:134/255.0f blue:134/255.0f alpha:1.0f],\
[UIColor colorWithRed:179/255.0f green:48/255.0f blue:80/255.0f alpha:1.0f],\
nil]
// liberty
#define GraphColorSchemeLibertyColors [NSArray arrayWithObjects:\
[UIColor colorWithRed:207/255.0f green:248/255.0f blue:246/255.0f alpha:1.0f],\
[UIColor colorWithRed:148/255.0f green:212/255.0f blue:212/255.0f alpha:1.0f],\
[UIColor colorWithRed:136/255.0f green:180/255.0f blue:187/255.0f alpha:1.0f],\
[UIColor colorWithRed:118/255.0f green:174/255.0f blue:175/255.0f alpha:1.0f],\
[UIColor colorWithRed:42/255.0f green:109/255.0f blue:130/255.0f alpha:1.0f],\
nil]

/*!
 *
 */
@interface ChartView : UIView

@property (nonatomic) GraphBackgroundRenderer *backgroundRenderer;

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

- (void)addGraphData:(GraphData *)graphData;

@end
