//
//  MunicipalEntity.m
//  WorldGame
//
//  Created by Michael Rommel on 02.05.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

#import "MunicipalEntity.h"

@implementation MunicipalEntity

- (instancetype)initWithName:(NSString *)name andInhabitants:(NSInteger)inhabitants
{
    self = [super init];
    
    if (self) {
        self.name = name;
        self.inhabitants = inhabitants;
        self.city = NO;
    }
    
    return self;
}

@end

#pragma mark -