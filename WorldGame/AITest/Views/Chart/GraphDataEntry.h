//
//  GraphDataEntry.h
//  WorldGame
//
//  Created by Michael Rommel on 22.09.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

/*!
 *
 */
@interface GraphDataEntry : NSObject

@property (atomic) NSInteger index;
@property (nonatomic) NSNumber *value;

- (instancetype)initWithValue:(NSNumber *)value atIndex:(NSInteger)index;

@end
