//
//  UIConstants.h
//  AITest
//
//  Created by Michael Rommel on 19.02.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#ifndef UIConstants_h
#define UIConstants_h

#define COLOR_CLEAR                         [UIColor clearColor]
#define COLOR_BLACK                         [UIColor colorWithWhite:0.0/255.0 alpha:1.0f]
#define COLOR_BLACK_A85                     [UIColor colorWithWhite:0.0/255.0 alpha:.85f]
#define COLOR_WHITE                         [UIColor colorWithWhite:255/255.0 alpha:1.0f]
#define COLOR_WHITE_A85                     [UIColor colorWithWhite:255/255.0 alpha:.85f]

#define COLOR_MIRO_WHITE                    [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0f]
#define COLOR_MIRO_BLACK                    [UIColor colorWithRed:55/255.0 green:65/255.0 blue:70/255.0 alpha:1.0f]
#define COLOR_MIRO_RED                      [UIColor colorWithRed:84/255.0 green:23/255.0 blue:31/255.0 alpha:1.0f]
#define COLOR_MIRO_SAND                     [UIColor colorWithRed:233/255.0 green:223/255.0 blue:182/255.0 alpha:1.0f]


#define SWLocalizedString(text) ([text isEqualToString:NSLocalizedString(text,nil)] ? [NSString stringWithFormat:@"##%@##", text] : NSLocalizedString(text,nil))

#define PRINT_RECT(text, frame) NSLog(@"%@: %d,%d -> %dx%d", text, (int)frame.origin.x, (int)frame.origin.y, (int)frame.size.width, (int)frame.size.height)

//#define STATUSBAR_HEIGHT    ([UIApplication sharedApplication].statusBarFrame.size.height)
//#define STATUSBAR_HEIGHT    64

#define BU_HALF 6
#define BU      12
#define BU2     24
#define BU3     36
#define BU4     48
#define BU5     60
#define BU6     72
#define BU7     84
#define BU8     96
#define BU9     108
#define BU10     120

#define DEVICE_WIDTH    ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_HEIGHT    ([[UIScreen mainScreen] bounds].size.height)

#define GETX(view)              (view.frame.origin.x)
#define SETX(view,x)            view.frame = CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height)
#define SETXY(view,x,y)         view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height)
#define ADDX(view,deltax)       view.frame = CGRectMake(view.frame.origin.x + deltax, view.frame.origin.y, view.frame.size.width, view.frame.size.height)

#define GETY(view)              (view.frame.origin.y)
#define SETY(view,y)            view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height)
#define ADDY(view,deltay)       view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + deltay, view.frame.size.width, view.frame.size.height)
#define GETRIGHT(view)          (view.frame.origin.x + view.frame.size.width)

#define GETBOTTOM(view)         (view.frame.origin.y + view.frame.size.height)
#define SETBOTTOM(view,bottom)  view.frame = CGRectMake(view.frame.origin.x, bottom - view.frame.size.height, view.frame.size.width, view.frame.size.height)

#define GETHEIGHT(view)         (view.frame.size.height)
#define SETHEIGHT(view,height)  view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height)
#define ADDHEIGHT(view,deltaHeight)  view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + deltaHeight)

#define GETWIDTH(view)          (view.frame.size.width)
#define SETWIDTH(view,width)    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, view.frame.size.height)
#define SETFILLWIDTH(view)      view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, DEVICE_WIDTH, view.frame.size.height)

#define CENTERINFRAME(label)    [((UILabel*)label) setTextAlignment: NSTextAlignmentCenter]
#define CENTERINPARENT(view,parent) view.frame = CGRectMake((DEVICE_WIDTH/2)-(view.frame.size.width/2), parent.center.y-(view.frame.size.height/2), view.frame.size.width, view.frame.size.height)
#define CENTERHORIZONTAL(view,parent) view.frame = CGRectMake(parent.center.x-(view.frame.size.width/2), view.frame.origin.y, view.frame.size.width, view.frame.size.height)

#define EXPAND(view,delta)      view.frame = CGRectMake(view.frame.origin.x - delta, view.frame.origin.y - delta, view.frame.size.width + 2 * delta, view.frame.size.height + 2 * delta)

#define ALIGNLEFT(imageView)    imageView.frame = CGRectMake(0, imageView.frame.origin.y, imageView.image.size.width * imageView.frame.size.height / imageView.image.size.height, imageView.frame.size.height)

#define PRINTFRAME(text, view)  NSLog(@"%@: %d, %d => %d, %d", text, (int)view.frame.origin.x, (int)view.frame.origin.y, (int)view.frame.size.width, (int)view.frame.size.height)
#define PRINTBOUNDS(text, view) NSLog(@"%@: %d, %d => %d, %d", text, (int)view.bounds.origin.x, (int)view.bounds.origin.y, (int)view.bounds.size.width, (int)view.bounds.size.height)
#define PRINTRECT(text, rect)   NSLog(@"%@: %d, %d => %d, %d", text, (int)rect.origin.x, (int)rect.origin.y, (int)rect.size.width, (int)rect.size.height)
#define PRINTSIZE(text, size)   NSLog(@"%@: %d x %d", text, (int)size.width, (int)size.height)

#define STATUSBAR_HEIGHT        ([[UIApplication sharedApplication] statusBarFrame].size.height)

#endif /* UIConstants_h */
