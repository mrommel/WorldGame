//
//  Economy.h
//  WorldGame
//
//  Created by Michael Rommel on 02.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 (Money), 
 Construction material (some regions provide little such as deserts), 
 Food (some regions provide little such as deserts), 
 Goods (different?), 
 Luxury (different?)
 */
typedef NS_ENUM(NSInteger, Product) {
    ProductDefault,
    ProductFood,
    ProductMaterial,
    ProductGoods,
    ProductLuxuty
};

@interface Economy : NSObject



@end
